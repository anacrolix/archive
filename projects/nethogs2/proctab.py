#!/usr/bin/env python

from common import *

#Connection = collections.namedtuple("Connection", ("local", "remote", "family", "protocol"))
class Connection(collections.namedtuple("Connection", ("local", "remote", "family", "protocol"))):
    #def __new__(cl
    pass
ProcessInfo = collections.namedtuple("ProcessInfo", ["pid", "cmdline", "user"])

def reversed_connection_endpoints(netconn):
    a = netconn._asdict()
    a["local"] = netconn.remote
    a["remote"] = netconn.local
    return Connection(**a)
#EndpointProcesses = collections.namedtuple("EndpointProcesses", ("outgoing", "incoming"))

def group(iterable, n=2):
    return itertools.izip(*((iter(iterable),) * n))

def htonhexstr(hexstr):
    return reversed(["".join(s) for s in group(hexstr)])

def procinfo_from_pid(pid):
    try:
        return ProcessInfo(
                pid=pid,
                cmdline=open("/proc/%s/cmdline" % pid).read(),
                user=pwd.getpwuid(os.stat("/proc/%s" % pid).st_uid).pw_name)
    except IOError as e:
        logging.info(e)
        return None

def map_sockino_to_procinfo(logger):
    inode2procinfo = {}
    for procdir in os.listdir("/proc"):
        if not re.match(r"\d+$", procdir):
            # not a process entry
            continue
        pid = int(procdir)
        try:
            fdlist = os.listdir(os.path.join("/proc", procdir, "fd"))
        except OSError as e:
            logger.info(e)
            continue # next proc entry, this one has probably disappeared
        for fd in fdlist:
            try:
                linkdata = os.readlink(os.path.join("/proc", procdir, "fd", fd))
            except OSError as e:
                if pid != os.getpid():
                    logger.info(e)
                continue # next fd, this one probably closed
            matchobj = re.match(r"socket:\[(\d+)\]$", linkdata)
            if not matchobj:
                # not a socket
                continue # next fd
            inode = int(matchobj.group(1))
            inode2procinfo[inode] = procinfo_from_pid(int(procdir))
    return inode2procinfo

def _parse_socket_table(filename, family):
    """Returns {(localaddr, remaddr): inode} from a proc socket table file"""

    def make_endpoint((addr, port)):
        """Returns human readable network address from socket table line"""
        # reverse hex string octets and pack as binary string
        packstr = "".join([chr(int(o, 16)) for o in htonhexstr(addr)])
        addrstr = socket.inet_ntop(family, packstr)
        # convert hex string to port number (doesn't need to be reversed)
        port = int(port, 16)
        return (addrstr, port) # ipv6 might want a different separator

    # 1 connection per line, the first contains the headers
    for l in open(filename).readlines()[1:]:
        cols = re.split("[%s:]+" % string.whitespace, l.strip())
        conn = (make_endpoint(cols[1:3]), make_endpoint(cols[3:5]))
        inode = int(cols[13])
        yield conn + (inode,)


def map_netconn_to_inode():
    """Returns {Connection: inode}"""
    mapping = {}
    for filename, proto, family in (
            ("/proc/net/tcp", socket.IPPROTO_TCP, socket.AF_INET),
            ("/proc/net/tcp6", socket.IPPROTO_TCP, socket.AF_INET6),
            ("/proc/net/udp", socket.IPPROTO_UDP, socket.AF_INET),
            ("/proc/net/udp6", socket.IPPROTO_UDP, socket.AF_INET6),):
        for local, remote, inode in _parse_socket_table(filename, family):
            netconn = Connection(local=local, remote=remote, protocol=proto, family=family)
            if netconn in mapping:
                # there is a duplicate connection, check it points to the same inode
                assert mapping[netconn] == inode
            else:
                mapping[netconn] = inode
    return mapping

class ProcTests(unittest.TestCase):
    def testSocketTables(self):
        # the netstat output contains 2 header lines
        self.assertEqual(len(map_netconn_to_inode()), int(subprocess.Popen("netstat -tuna | wc -l", stdout=subprocess.PIPE, shell=True).communicate()[0]) - 2)
    def testUniqueConnections(self):
        for n in itertools.repeat(None, 100):
            map_netconn_to_inode()

class ProcTable(object):
    def __init__(self, logger):
        self.logger = logger
        self.__conn2inode = {}
        self.__inode2proc = {}
    def update_table(self):
        self.__inode2proc.update(map_sockino_to_procinfo(self.logger))
        self.__conn2inode.update(map_netconn_to_inode())
    def connection_to_inode(self, connection):
        assert type(connection) == Connection, type(connection)
        try:
            return self.__conn2inode[connection]
        except KeyError:
            return None
    def inode_to_procinfo(self, inode):
        if inode in self.__inode2proc:
            return self.__inode2proc[inode]
        else:
            return None

if __name__ == "__main__":
    unittest.main()
