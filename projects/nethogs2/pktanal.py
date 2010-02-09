from common import *

def analyse_packet(data, datalink):
    """Return Connection"""
    def tcp(data):
        return [struct.unpack("!H", data[i:i+2])[0] for i in (0, 2)]
    udp = tcp
    def icmp(data):
        return (None, None)
    def ipv4(data):
        assert (ord(data[0]) >> 4) == 4
        hdrl = 4 * (ord(data[0]) & 0xf)
        assert hdrl >= 20
        proto = ord(data[9])
        ports = {
                1: icmp,
                6: tcp,
                17: udp,
            }[proto](data[hdrl:])
        inaddrs = [socket.inet_ntoa(i) for i in (data[12:16], data[16:20])]

        return Connection(**dict(zip(("local", "remote"), zip(inaddrs, ports)) + [("family", socket.AF_INET), ("protocol", proto)]))
    def arp(data):
        assert ord(data[4]) == 6 # MAC
        assert ord(data[5]) == 4 # IPv4
        return [socket.inet_ntoa(i) for i in (data[14:18], data[24:28])]
    #def ipv6(data):
    #    pass
    def ethernet():
        ethertype = struct.unpack("!H", data[12:14])[0]
        #ethertype = htonhexstr(data[12:14])
        try:
            nextfunc = {
                    0x0800: ipv4,
                    #0x0806: arp,
                    #0x86dd: ipv6,
                }[ethertype]
        except KeyError as e:
            logging.warning("Unhandled ethernet type: %d" % ethertype)
        else:
            return nextfunc(data[14:])
    endps = locals()[datalink]()
    if endps == None:
        return
    return endps
