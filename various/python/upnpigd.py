#!/usr/bin/env python

import atexit
import code
import collections
import io
import httplib
import itertools
import os
import pdb
import socket
import sys
import time
import urllib2
import urlparse
import xml.etree.ElementTree as etree

SSDP_PORT = 1900
UPNP_MCAST_ADDR = "239.255.255.250"
M_SEARCH_MSG_FMT = "\r\n".join((
        "M-SEARCH * HTTP/1.1",
        "HOST: %s:%d" % (UPNP_MCAST_ADDR, SSDP_PORT),
        "ST: %s",
        "MAN: \"ssdp:discover\"",
        "MX: 3",
    )) + 2 * "\r\n"
DEVICES = (
        "urn:schemas-upnp-org:device:InternetGatewayDevice:1",
        "urn:schemas-upnp-org:service:WANIPConnection:1",
        "urn:schemas-upnp-org:service:WANPPPConnection:1",
        "upnp:rootdevice",
    )
#IGD_SERVICE_TYPES = DEVICES[1:3]

MSearchReply = collections.namedtuple("MSearchReply",
        ["response", "headers"])
UPnPService = collections.namedtuple("UPnPService",
        ["serviceType", "serviceId", "controlURL", "eventSubURL", "SCPDURL"])

def __parse_msearch_reply(packet):
    #print repr(packet)
    log.info("msearch reply: " + repr(packet))
    lines = packet.split("\r\n")[:-2]
    headers = {}
    for l in lines[1:]:
        try:
            keyword, value = l.split(":", 1)
        except ValueError:
            print l
        else:
            headers[keyword.upper()] = value.lstrip(" ")
    return MSearchReply(response=lines[0], headers=headers)

ROOTSPEC_XMLNS = "urn:schemas-upnp-org:device-1-0"

def _parse_rootspec(rootspec):
    """Can take a file object or path. Returns a list of UPnPServices."""
    rootspec = io.BytesIO(rootspec.read())
    log.debug("Parsing UPnP root spec: " + repr(rootspec.getvalue()))
    tree = etree.ElementTree(file=rootspec)
    #tree.parse(urllib2.urlopen(location))
    services = []
    url_base = tree.find("{%s}%s" % (ROOTSPEC_XMLNS, "URLBase")).text
    for service_element in tree.findall("//{%s}service" % (ROOTSPEC_XMLNS,)):
        data = {}
        for field in UPnPService._fields:
            value = service_element.find("{%s}%s" % (ROOTSPEC_XMLNS, field)).text
            if field[-len("URL"):] == "URL":
                # try and prepend the url base if the value supports it
                try: value = url_base.rstrip("/") + value
                except TypeError: pass
            data[field] = value
        else:
            services.append(UPnPService(**data))
    return services

def discover(timeout=2.0):
    # is the 3rd parameter even necessary?
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
    if sys.platform == 'win32':
        s.setsockopt(socket.SOL_SOCKET, socket.SO_EXCLUSIVEADDRUSE, 1)
    s.bind(('', 0)) # replies come to whatever port bound to
    for device in DEVICES:
        packet = M_SEARCH_MSG_FMT % (device,)
        #print repr(packet)
        # data must go immediately, we don't want to stall or we might miss replies
        s.settimeout(0.0)
        s.sendto(packet, (UPNP_MCAST_ADDR, SSDP_PORT))
    devlist = set()
    stop_receiving = time.time() + timeout
    while True:
        s.settimeout(stop_receiving - time.time())
        try:
            reply = __parse_msearch_reply(s.recv(1536))
        except socket.timeout:
            break
        else:
            devlist.add(tuple([reply.headers[x.upper()] for x in ('location', 'st')]))
    return devlist

def selectigd(devices=None):
    for d in devices or discover():
        services = _parse_rootspec(urllib2.urlopen(d[0]))
        for s in services:
            p = UPnPServiceProxy(s)
            if isinstance(p, WANConnection):
                return p
    else:
        log.debug("No UPnP IGD found")

UPNP_ERROR_NAMESPACE = "urn:schemas-upnp-org:control-1-0"

class UPnPError(Exception):
    INVALID_ARGS = 402
    ARRAY_INDEX_INVALID = 713
    def __init__(self, message, soap=None, httpec=None):
        self.msg = message
        if soap != None:
            xml = etree.ElementTree(file=io.BytesIO(soap))
            self.code = int(xml.find("//{%s}errorCode" % (UPNP_ERROR_NAMESPACE,)).text)
            self.desc = xml.find("//{%s}errorDescription" % (UPNP_ERROR_NAMESPACE,)).text
    def __str__(self):
        rv = self.msg
        if self.code or self.desc:
            rv += ". UPnP error code: %u, %s" % (self.code, self.desc)
        return rv

def _simple_upnp_command(action, action_args, service_type, service_id, control_url):
    """Returns the file-like URL response"""
    # generate SOAP envelope with a UPNP service action
    body = \
            ('<?xml version="1.0"?>\r\n' + \
            '<s:Envelope' + \
                    ' xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"' + \
                    ' s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' + \
                '<s:Body>' + \
                    '<u:%s xmlns:u="%s">' + \
                        # here is the argument payload
                        '%%s' + \
                    '</u:%s>' + \
                '</s:Body>' + \
            '</s:Envelope>' + \
        '\r\n') % (action, service_type, action)
    # build up UPNP command argument XML
    upnp_args_xml = str()
    for element, value in action_args.iteritems():
        upnp_args_xml += '<%s>%s</%s>' % (element, value, element)
    # insert the arguments into the SOAP envelope
    body = body % (upnp_args_xml,)
    # make the SOAP request
    request = urllib2.Request(control_url, body)
    request.add_header("SOAPAction", '"%s#%s"' % (service_type, action))
    request.add_header("Content-Type", "text/xml")
    params = {}
    #pdb.set_trace()
    log.debug("Connecting to: " + repr(control_url))
    log.debug("Sending SOAP request: " + repr(body))
    try:
        http_response = urllib2.urlopen(request)
    except urllib2.HTTPError as e:
        soap = e.fp.read()
        raise UPnPError(
                "Received %s while opening %s" % (repr(str(e)), request.get_full_url()),
                soap=soap,
                httpec=e.code)
    else:
        soap = http_response.read()
    finally:
        try: log.debug("SOAP Response: " + repr(soap))
        except UnboundLocalError: pass
    xml_response = etree.ElementTree(file=io.BytesIO(soap))
    for respns in (service_id, service_type):
        respelt = xml_response.find("//{%s}%sResponse" % (respns, action))
        if respelt is not None: break
    else:
        raise UPnPError("Failed to parse SOAP response: " + repr(f.getvalue()))
    for element in respelt.getchildren():
        params[element.tag] = element.text
    return params

def getifname(remhost):
    """Get the name of the interface used to connect to remhost.
    >>> getifname('localhost')
    'localhost'
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect((remhost, 0))
    rv = s.getsockname()[0]
    s.close()
    return rv

_UPNP_SERVICE_PROXY_CLASSES = {}

class UPnPServiceProxy(object):
    class MonkeyPatch(type):
        def __new__(self, name, bases, dict_):
            class_ = type.__new__(self, name, bases, dict_)
            try:
                st = dict_['SERVICE_TYPE']
            except KeyError:
                pass
            else:
                assert not st in _UPNP_SERVICE_PROXY_CLASSES
                _UPNP_SERVICE_PROXY_CLASSES[st] = class_
            return class_
    __metaclass__ = MonkeyPatch
    def __new__(class_, upnp_service):
        if class_ == UPnPServiceProxy:
            try:
                child = _UPNP_SERVICE_PROXY_CLASSES[upnp_service.serviceType]
            except KeyError:
                pass
            else:
                return child.__new__(child, upnp_service)
        else:
            return super(UPnPServiceProxy, class_).__new__(class_)
    def __init__(self, upnp_service):
        self.upnp_service = upnp_service
        assert self.upnp_service.serviceType == self.SERVICE_TYPE
    def _simple_upnp_command(self, action, **args):
        return _simple_upnp_command(
                action,
                args,
                *self.upnp_service[0:3])

class WANConnection(UPnPServiceProxy):
    """Shared functionality for WANIPConnection and WANPPPConnection."""
    def GetExternalIPAddress(self):
        reply = self._simple_upnp_command("GetExternalIPAddress")
        assert len(reply) == 1
        return reply['NewExternalIPAddress']
    def GetPortMappingNumberOfEntries(self):
        reply = self._simple_upnp_command("GetPortMappingNumberOfEntries")
        return reply
    def GetGenericPortMappingEntry(self, index):
        try:
            return self._simple_upnp_command("GetGenericPortMappingEntry", NewPortMappingIndex=index)
        except UPnPError as e:
            if e.code in (e.INVALID_ARGS, e.ARRAY_INDEX_INVALID): return None
            else: raise
    def AddPortMapping(self, proto, extport, intport=0, inthost=None, desc=None, remhost=None):
        return self._simple_upnp_command(
                "AddPortMapping",
                NewRemoteHost=remhost or '',
                NewExternalPort=extport,
                NewProtocol=proto,
                NewInternalPort=(intport or extport),
                NewInternalClient=getifname(inthost or urlparse.urlsplit(self.upnp_service.controlURL).hostname),
                NewEnabled="1",
                NewPortMappingDescription=(desc or "upnpigd"),
                NewLeaseDuration="0")
    def DeletePortMapping(self, proto, extport, remhost=""):
        return self._simple_upnp_command(
                "DeletePortMapping",
                NewRemoteHost=remhost,
                NewExternalPort=extport,
                NewProtocol=proto)
    def GetSpecificPortMappingEntry(self, proto, extport, remhost=""):
        return self._simple_upnp_command(
                "GetSpecificPortMappingEntry",
                NewRemoteHost=remhost,
                NewExternalPort=extport,
                NewProtocol=proto)

class WANIPConnection(WANConnection):
    SERVICE_TYPE = "urn:schemas-upnp-org:service:WANIPConnection:1"

class WANPPPConnection(WANConnection):
    SERVICE_TYPE = "urn:schemas-upnp-org:service:WANPPPConnection:1"

def _configure_logger(logfile_path, console_level=None):
    import logging
    if console_level is None: console_level = logging.CRITICAL
    global log
    log = logging.getLogger("upnpidg")
    log.setLevel(logging.DEBUG)
    fmtr = logging.Formatter("%(name)s:%(levelname)s:%(message)s")
    fh = logging.FileHandler(logfile_path, "wb")
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(fmtr)
    ch = logging.StreamHandler()
    ch.setLevel(console_level)
    ch.setFormatter(fmtr)
    log.addHandler(ch)
    log.addHandler(fh)

_configure_logger("log.upnpigd")

if __name__ == "__main__":
    if sys.platform is 'win32':
        atexit.register(lambda: os.system("pause"))
    #logging.error("test blah\0")
    devices = discover()
    igd = selectigd(devices)
    if not igd: sys.exit("No IGD devices were found")
    print "External IP Address:", igd.GetExternalIPAddress()
    print igd.AddPortMapping("UDP", 1337)
    print igd.GetSpecificPortMappingEntry("UDP", 1337)
    print igd.DeletePortMapping("UDP", 1337)
    print "UPnP port mappings in effect:"
    for index in itertools.count():
        gpme = igd.GetGenericPortMappingEntry(index)
        if gpme: print "\t" + str(gpme)
        else: break
    if index == 0:
        print "\tNone"
