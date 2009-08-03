#!/usr/bin/env python

import collections
import pdb
import socket
import sys
import urllib2
from xml.etree.ElementTree import ElementTree

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

MSearchReply = collections.namedtuple("MSearchReply",
        ["response", "headers"])
UPnPService = collections.namedtuple("UPnPService",
        ["serviceType", "serviceId", "controlURL", "eventSubURL", "SCPDURL"])

def __parse_msearch_reply(packet):
    #print repr(packet)
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

def __parse_rootspec(location):
    tree = ElementTree()
    tree.parse(urllib2.urlopen(location))
    services = []
    url_base = tree.find("{%s}%s" % (ROOTSPEC_XMLNS, "URLBase")).text
    for service_element in tree.findall("//{%s}service" % (ROOTSPEC_XMLNS,)):
        data = {}
        for field in UPnPService._fields:
            value = service_element.find("{%s}%s" % (ROOTSPEC_XMLNS, field)).text
            if field[-len("URL"):] == "URL": value = url_base + value
            data[field] = value
        else:
            services.append(UPnPService(**data))
    return services

def discover():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
    if sys.platform == 'win32':
        optname = socket.SO_EXCLUSIVEADDRUSE
    else:
        optname = socket.SO_REUSEADDR
    s.setsockopt(socket.SOL_SOCKET, optname, 1)
    s.bind((str(), PORT))
    for device in DEVICES:
        packet = M_SEARCH_MSG_FMT % (device,)
        #print repr(packet)
        s.settimeout(None) # block until data is sent
        s.sendto(packet, (UPNP_MCAST_ADDR, PORT))
    devlist = set()
    while True:
        s.settimeout(2.0) # wait 1s before giving up
        try:
            reply = __parse_msearch_reply(s.recv(1536))
        except socket.timeout:
            break
        else:
            devlist.add(tuple([reply.headers[x.upper()] for x in ('location', 'st')]))
    return devlist

def selectigd(devices):
    for d in devices:
        services = __parse_rootspec(d[0])
        for s in services:
            if s.serviceType == "urn:schemas-upnp-org:service:WANIPConnection:1":
                return WANIPConnection(s)
    else:
        return None

def _simple_upnp_command(url, service, action, args=None):
    assert args == None
    body = \
            ('<?xml version="1.0"?>\r\n' + \
            '<s:Envelope' + \
                    ' xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"' + \
                    ' s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">' + \
                '<s:Body>' + \
                    '<u:%s xmlns:u="%s">' + \
                    '</u:%s>' + \
                '</s:Body>' + \
            '</s:Envelope>' + \
        '\r\n') % (action, service, action)
    request = urllib2.Request(url, body)
    request.add_header("SOAPAction", '"%s#%s"' % (service, action))
    request.add_header("Content-Type", "text/xml")
    f = urllib2.urlopen(request)
    return f

class WANIPConnection(object):
    def __init__(self, upnp_service):
        self.upnp_service = upnp_service
    def GetExternalIPAddress(self):
        reply = _simple_upnp_command(
                self.upnp_service.controlURL,
                self.upnp_service.serviceType,
                "GetExternalIPAddress")
        return ElementTree(file=reply).find("//NewExternalIPAddress").text

devices = discover()
igd = selectigd(devices)
print igd.GetExternalIPAddress()

""" SOAP REQUEST DUMPS

0000   00 0f b5 7c 89 dc 00 1a 4d 5a 05 35 08 00 45 00  ...|....MZ.5..E.
0010   02 88 f2 3c 40 00 40 06 c4 df c0 a8 00 02 c0 a8  ...<@.@.........
0020   00 01 e0 ec c0 00 5d c6 8a 0d 7a 87 03 b4 80 18  ......]...z.....
0030   00 2e a9 fc 00 00 01 01 08 0a 00 0c 78 36 00 78  ............x6.x
0040   da 73 50 4f 53 54 20 2f 75 70 6e 70 2f 63 6f 6e  .sPOST /upnp/con
0050   74 72 6f 6c 2f 57 41 4e 49 50 43 6f 6e 6e 65 63  trol/WANIPConnec
0060   74 69 6f 6e 20 48 54 54 50 2f 31 2e 31 0d 0a 48  tion HTTP/1.1..H
0070   6f 73 74 3a 20 31 39 32 2e 31 36 38 2e 30 2e 31  ost: 192.168.0.1
0080   3a 34 39 31 35 32 0d 0a 55 73 65 72 2d 41 67 65  :49152..User-Age
0090   6e 74 3a 20 44 65 62 69 61 6e 2f 34 2e 30 2c 20  nt: Debian/4.0,
00a0   55 50 6e 50 2f 31 2e 30 2c 20 4d 69 6e 69 55 50  UPnP/1.0, MiniUP
00b0   6e 50 63 2f 31 2e 32 0d 0a 43 6f 6e 74 65 6e 74  nPc/1.2..Content
00c0   2d 4c 65 6e 67 74 68 3a 20 32 38 35 0d 0a 43 6f  -Length: 285..Co
00d0   6e 74 65 6e 74 2d 54 79 70 65 3a 20 74 65 78 74  ntent-Type: text
00e0   2f 78 6d 6c 0d 0a 53 4f 41 50 41 63 74 69 6f 6e  /xml..SOAPAction
00f0   3a 20 22 75 72 6e 3a 73 63 68 65 6d 61 73 2d 75  : "urn:schemas-u
0100   70 6e 70 2d 6f 72 67 3a 73 65 72 76 69 63 65 3a  pnp-org:service:
0110   57 41 4e 49 50 43 6f 6e 6e 65 63 74 69 6f 6e 3a  WANIPConnection:
0120   31 23 47 65 74 45 78 74 65 72 6e 61 6c 49 50 41  1#GetExternalIPA
0130   64 64 72 65 73 73 22 0d 0a 43 6f 6e 6e 65 63 74  ddress"..Connect
0140   69 6f 6e 3a 20 43 6c 6f 73 65 0d 0a 43 61 63 68  ion: Close..Cach
0150   65 2d 43 6f 6e 74 72 6f 6c 3a 20 6e 6f 2d 63 61  e-Control: no-ca
0160   63 68 65 0d 0a 50 72 61 67 6d 61 3a 20 6e 6f 2d  che..Pragma: no-
0170   63 61 63 68 65 0d 0a 0d 0a 3c 3f 78 6d 6c 20 76  cache....<?xml v
0180   65 72 73 69 6f 6e 3d 22 31 2e 30 22 3f 3e 0d 0a  ersion="1.0"?>..
0190   3c 73 3a 45 6e 76 65 6c 6f 70 65 20 78 6d 6c 6e  <s:Envelope xmln
01a0   73 3a 73 3d 22 68 74 74 70 3a 2f 2f 73 63 68 65  s:s="http://sche
01b0   6d 61 73 2e 78 6d 6c 73 6f 61 70 2e 6f 72 67 2f  mas.xmlsoap.org/
01c0   73 6f 61 70 2f 65 6e 76 65 6c 6f 70 65 2f 22 20  soap/envelope/"
01d0   73 3a 65 6e 63 6f 64 69 6e 67 53 74 79 6c 65 3d  s:encodingStyle=
01e0   22 68 74 74 70 3a 2f 2f 73 63 68 65 6d 61 73 2e  "http://schemas.
01f0   78 6d 6c 73 6f 61 70 2e 6f 72 67 2f 73 6f 61 70  xmlsoap.org/soap
0200   2f 65 6e 63 6f 64 69 6e 67 2f 22 3e 3c 73 3a 42  /encoding/"><s:B
0210   6f 64 79 3e 3c 75 3a 47 65 74 45 78 74 65 72 6e  ody><u:GetExtern
0220   61 6c 49 50 41 64 64 72 65 73 73 20 78 6d 6c 6e  alIPAddress xmln
0230   73 3a 75 3d 22 75 72 6e 3a 73 63 68 65 6d 61 73  s:u="urn:schemas
0240   2d 75 70 6e 70 2d 6f 72 67 3a 73 65 72 76 69 63  -upnp-org:servic
0250   65 3a 57 41 4e 49 50 43 6f 6e 6e 65 63 74 69 6f  e:WANIPConnectio
0260   6e 3a 31 22 3e 3c 2f 75 3a 47 65 74 45 78 74 65  n:1"></u:GetExte
0270   72 6e 61 6c 49 50 41 64 64 72 65 73 73 3e 3c 2f  rnalIPAddress></
0280   73 3a 42 6f 64 79 3e 3c 2f 73 3a 45 6e 76 65 6c  s:Body></s:Envel
0290   6f 70 65 3e 0d 0a                                ope>..

0000   50 4f 53 54 20 2f 75 70 6e 70 2f 63 6f 6e 74 72  POST /upnp/contr
0010   6f 6c 2f 57 41 4e 49 50 43 6f 6e 6e 65 63 74 69  ol/WANIPConnecti
0020   6f 6e 20 48 54 54 50 2f 31 2e 31 0d 0a 41 63 63  on HTTP/1.1..Acc
0030   65 70 74 2d 45 6e 63 6f 64 69 6e 67 3a 20 69 64  ept-Encoding: id
0040   65 6e 74 69 74 79 0d 0a 43 6f 6e 74 65 6e 74 2d  entity..Content-
0050   4c 65 6e 67 74 68 3a 20 32 38 35 0d 0a 53 6f 61  Length: 285..Soa
0060   70 61 63 74 69 6f 6e 3a 20 22 47 65 74 45 78 74  paction: "GetExt
0070   65 72 6e 61 6c 49 50 41 64 64 72 65 73 73 22 0d  ernalIPAddress".
0080   0a 48 6f 73 74 3a 20 31 39 32 2e 31 36 38 2e 30  .Host: 192.168.0
0090   2e 31 3a 34 39 31 35 32 0d 0a 55 73 65 72 2d 41  .1:49152..User-A
00a0   67 65 6e 74 3a 20 50 79 74 68 6f 6e 2d 75 72 6c  gent: Python-url
00b0   6c 69 62 2f 32 2e 36 0d 0a 43 6f 6e 6e 65 63 74  lib/2.6..Connect
00c0   69 6f 6e 3a 20 63 6c 6f 73 65 0d 0a 43 6f 6e 74  ion: close..Cont
00d0   65 6e 74 2d 54 79 70 65 3a 20 74 65 78 74 2f 78  ent-Type: text/x
00e0   6d 6c 0d 0a 0d 0a                                ml....

"""
