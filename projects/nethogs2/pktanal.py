from common import *

PacketEndpoints = collections.namedtuple("PacketEndpoints", ("source", "destination", "family", "protocol"))

class PacketAnalysisError(Exception):
    pass

class _PacketAnalyzer(object):
    def __init__(self, logger):
        self.logger = logger
    def layer4(self, data, protocol):
        if protocol in ('tcp', 'udp'):
            retval = tuple(struct.unpack("!H", data[i:i+2])[0] for i in (0, 2))
        elif protocol == 'icmp':
            retval = (None, None)
        else:
            raise ValueError(protocol)
        return retval
    def layer3(self, data, family):
        if family == 'ipv4':
            assert (ord(data[0]) >> 4) == 4 # version
            hdrl = 4 * (ord(data[0]) & 0xf) # header length
            assert hdrl >= 20
            proto = ord(data[9])
            ports = self.layer4(data[hdrl:], {
                        1: 'icmp',
                        6: 'tcp',
                        17: 'udp',
                    }[proto])
            inaddrs = [socket.inet_ntoa(i) for i in (data[12:16], data[16:20])]
            self.logger.debug("ports=%s, inaddrs=%s", ports, inaddrs)
            retval = PacketEndpoints(**dict(zip(("source", "destination"), zip(inaddrs, ports)) + [("family", socket.AF_INET), ("protocol", proto)]))
        elif family == 'arp':
            assert ord(data[4]) == 6 # MAC
            assert ord(data[5]) == 4 # IPv4
            self.logger.info("ARP Operation: %d" % (struct.unpack("!H", data[6:8])))
            retval = PacketEndpoints(
                    source=(socket.inet_ntoa(data[14:18]), None),
                    destination=(socket.inet_ntoa(data[24:28]), None),
                    family=None,
                    protocol='arp')
        else:
            raise ValueError(family)
        assert isinstance(retval, PacketEndpoints)
        return retval
    def layer2(self, data, datalink):
        if datalink == 'ethernet':
            ethertype = struct.unpack("!H", data[12:14])[0]
            try:
                protocol = {
                        0x0800: 'ipv4',
                        0x0806: 'arp',
                    }[ethertype]
            except KeyError:
                raise PacketAnalysisError("Unhandled ethernet type: {0:#0x}".format(ethertype))
            else:
                retval = self.layer3(data[14:], protocol)
        assert isinstance(retval, PacketEndpoints)
        return retval

def analyse_packet(data, datalink, logger=None):
    return _PacketAnalyzer(logger).layer2(data, datalink)
