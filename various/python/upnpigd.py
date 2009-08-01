#!/usr/bin/env python

import collections
import socket
import urllib

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
        "upnp:rootdevice")

MSearchReply = collections.namedtuple("MSearchReply", ["response", "headers"])

def __parse_msearch_reply(packet):
    print repr(packet)
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

def __parse_root_desc(device):
    print urllib.urlopen(device[0]).read()

def discover():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(('', PORT))
    devlist = set()
    for device in DEVICES:
        packet = M_SEARCH_MSG_FMT % (device,)
        #print repr(packet)
        s.settimeout(None) # must discard of data
        s.sendto(packet, (UPNP_MCAST_ADDR, PORT))
        while True:
            s.settimeout(1) # wait 1s before giving up
            try:
                reply = __parse_msearch_reply(s.recv(1536))
            except socket.timeout:
                break
            else:
                devlist.add(tuple([reply.headers[x.upper()] for x in ('location', 'st')]))
        if len(devlist): break
    return devlist

devices = discover()
__parse_root_desc(devices.pop())
