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

PORT = 1900
UPNP_MCAST_ADDR = "239.255.255.250"
M_SEARCH_MSG_FMT = "\r\n".join((
        "M-SEARCH * HTTP/1.1",
        "HOST: %s:%d" % (UPNP_MCAST_ADDR, PORT),
        "ST: %s",
        "MAN: \"ssdp:discover\"",
        "MX: 3",
    )) + 2 * "\r\n"
DEVICES = (
        "urn:schemas-upnp-org:device:InternetGatewayDevice:1",
        "urn:schemas-upnp-org:service:WANIPConnection:1",
        "urn:schemas-upnp-org:service:WANPPPConnection:1",
        "upnp:rootdevice"
    )
IGD_SERVICE_TYPES = DEVICES[1:3]
#print IGD_SERVICE_TYPES

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
        s.sendto(packet, (UPNP_MCAST_ADDR, PORT))
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

def selectigd(devices):
    for d in devices:
        services = _parse_rootspec(urllib2.urlopen(d[0]))
        for s in services:
            if s.serviceType in IGD_SERVICE_TYPES:
            #if s.serviceType == "urn:schemas-upnp-org:service:WANIPConnection:1":
                return WANIPConnection(s)
    else:
        log.debug("No UPnP IGD found")

UPNP_ERROR_NAMESPACE = "urn:schemas-upnp-org:control-1-0"

class UPnPError(Exception):
    def __init__(self, message, soap=None, httpec=None):
        #assert len(args) >= 1
        Exception.__init__(self, message)
        log.error(message)
        if soap != None:
            xml = etree.ElementTree(file=io.BytesIO(soap))
            #pdb.set_trace()
            self.code = int(xml.find("//{%s}errorCode" % (UPNP_ERROR_NAMESPACE,)).text)
            self.desc = xml.find("//{%s}errorDescription" % (UPNP_ERROR_NAMESPACE,)).text
    #def __str__(self):
        #return "UPnPError"

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
    log.debug("Sending SOAP request: " + repr(body))
    request = urllib2.Request(control_url, body)
    request.add_header("SOAPAction", '"%s#%s"' % (service_type, action))
    request.add_header("Content-Type", "text/xml")
    params = {}
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
        log.debug("SOAP Response: " + repr(soap))
    xml_response = etree.ElementTree(file=io.BytesIO(soap))
    for respns in (service_id, service_type):
        respelt = xml_response.find("//{%s}%sResponse" % (respns, action))
        if respelt is not None: break
    else:
        raise UPnPError("Failed to parse SOAP response: " + repr(f.getvalue()))
    for element in respelt.getchildren():
        params[element.tag] = element.text
    return params

"""
    AddPortMappingArgs = calloc(9, sizeof(struct UPNParg));
    AddPortMappingArgs[0].elt = "NewRemoteHost";
    AddPortMappingArgs[0].val = remoteHost;
    AddPortMappingArgs[1].elt = "NewExternalPort";
    AddPortMappingArgs[1].val = extPort;
    AddPortMappingArgs[2].elt = "NewProtocol";
    AddPortMappingArgs[2].val = proto;
    AddPortMappingArgs[3].elt = "NewInternalPort";
    AddPortMappingArgs[3].val = inPort;
    AddPortMappingArgs[4].elt = "NewInternalClient";
    AddPortMappingArgs[4].val = inClient;
    AddPortMappingArgs[5].elt = "NewEnabled";
    AddPortMappingArgs[5].val = "1";
    AddPortMappingArgs[6].elt = "NewPortMappingDescription";
    AddPortMappingArgs[6].val = desc?desc:"libminiupnpc";
    AddPortMappingArgs[7].elt = "NewLeaseDuration";
    AddPortMappingArgs[7].val = "0";
"""

def getifname(remhost):
    return socket.gethostbyname(socket.getfqdn())

class WANIPConnection(object):
    def __init__(self, upnp_service):
        self.upnp_service = upnp_service
    def _simple_upnp_command(self, action, **args):
        return _simple_upnp_command(
                action,
                args,
                *self.upnp_service[0:3])
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
            if e.code == 402: return None
            else: raise
    def AddPortMapping(self, proto, intport, extport=None, inthost=None, desc=None, remhost=None):
        #if inthost == None: inthost
        return self._simple_upnp_command(
                "AddPortMapping",
                NewRemoteHost=remhost or '',
                NewExternalPort=(extport if extport != None else intport),
                NewProtocol=proto,
                NewInternalPort=intport,
                NewInternalClient=getifname(inthost or urlparse.urlsplit(self.upnp_service.controlURL).hostname),
                NewEnabled="1",
                NewPortMappingDescription=(desc or "upnpigd"),
                NewLeaseDuration="0")

def _configure_logger(logfile_path):
    import logging
    global log
    log = logging.getLogger("upnpidg")
    log.setLevel(logging.DEBUG)
    fmtr = logging.Formatter("%(name)s:%(levelname)s:%(message)s")
    fh = logging.FileHandler(logfile_path, "wb")
    fh.setLevel(logging.DEBUG)
    fh.setFormatter(fmtr)
    ch = logging.StreamHandler()
    ch.setLevel(logging.CRITICAL)
    ch.setFormatter(fmtr)
    log.addHandler(ch)
    log.addHandler(fh)

if __name__ == "__main__":
    atexit.register(lambda: os.system("pause"))
    _configure_logger("log.upnpigd")
    #logging.error("test blah\0")
    devices = discover()
    igd = selectigd(devices)
    if not igd: sys.exit("No IGD devices were found")
    print "External IP Address:", igd.GetExternalIPAddress()
    igd.AddPortMapping("TCP", 1337)
    print "UPnP port mappings in effect:"
    for index in itertools.count():
        gpme = igd.GetGenericPortMappingEntry(index)
        if gpme: print "\t" + str(gpme)
        else: break
    if index == 0:
        print "\tNone"
