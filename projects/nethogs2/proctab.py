from common import *

Connection = collections.namedtuple("Connection", ("local", "remote", "family", "protocol"))
ProcessInfo = collections.namedtuple("ProcessInfo", ("pid", "cmdline", "user"))

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

_SOCKET_INODE_REGEXP = re.compile(r"socket:\[(\d+)\]$")

def map_sockino_to_procinfo():
    retval = {}
    for procdir in os.listdir("/proc"):
        try:
            pid = int(procdir)
        except ValueError:
            pass
        else:
            try:
                fdlist = os.listdir(os.path.join("/proc", procdir, "fd"))
            except OSError as e:
                if e.errno != errno.ENOENT:
                    raise
            else:
                procinfo = None
                for fd in fdlist:
                    try:
                        linkdata = os.readlink("/proc/" + procdir + "/fd/" + fd)
                    except OSError:
                        pass
                    else:
                        matchobj = _SOCKET_INODE_REGEXP.match(linkdata)
                        if matchobj:
                            if not procinfo:
                                procinfo = procinfo_from_pid(pid)
                            inode = int(matchobj.group(1))
                            assert inode != 0
                            retval[inode] = procinfo
    return retval

_SOCKET_TABLE_LINE_DELIMITER = re.compile("[%s:]+" % string.whitespace)

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

    retval = []
    # 1 connection per line, the first contains the headers
    for l in itertools.islice(iter(open(filename)), 1, None):
        cols = _SOCKET_TABLE_LINE_DELIMITER.split(l.strip())
        endps = (make_endpoint(cols[1:3]), make_endpoint(cols[3:5]))
        inode = int(cols[13])
        retval.append(endps + (inode,))
        #yield endps + (inode,)
    return retval

def map_netconn_to_inode():
    """Returns {Connection: inode}"""
    retval = {}
    for filename, proto, family in (
            ("/proc/net/tcp", socket.IPPROTO_TCP, socket.AF_INET),
            ("/proc/net/tcp6", socket.IPPROTO_TCP, socket.AF_INET6),
            ("/proc/net/udp", socket.IPPROTO_UDP, socket.AF_INET),
            ("/proc/net/udp6", socket.IPPROTO_UDP, socket.AF_INET6),):
        for local, remote, inode in _parse_socket_table(filename, family):
            netconn = Connection(local=local, remote=remote, protocol=proto, family=family)
            # if the inode is already present, i think that's ok
            retval[netconn] = inode
    return retval

class ProcTable(object):
    def __init__(self, logger):
        self.logger = logger
        self.__conn2inode = {}
        self.__inode2proc = {}
    def update_table(self):
        self.__inode2proc.update(map_sockino_to_procinfo())
        for conn, inode in map_netconn_to_inode().iteritems():
            assert isinstance(inode, int)
            if inode != 0 or conn not in self.__conn2inode:
                self.__conn2inode[conn] = inode
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
