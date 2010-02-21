#!/usr/bin/env python

# this must go first, we require true division
from __future__ import division

# constants for tweaking by packagers
PROGNAME = "Nethogs2"
VERSION = "0.1-dev"

from common import *

import proctab
import pktanal

#os.close(sys.stderr.fileno())
#sys.stderr = open("nethogs2.stderr", "w")
#print sys.stderr.fileno()

def transform(unaries, iterable):
    return map(lambda a, b: a(b) if a is not None else b, unaries, iterable)

UNKNOWN_PROCINFO = proctab.ProcessInfo(pid=None, cmdline="[UNKNOWN]", user=None)
ARP_PROCINFO = proctab.ProcessInfo(pid=None, cmdline="[ARP]", user=None)
INODE0_PROCINFO = proctab.ProcessInfo(pid=None, cmdline="[INODE 0]", user=None)
NetworkHog = collections.namedtuple("NetworkHog", ("pid", "cmdline", "user", "device"))

class DeviceCapture(object):
    import pcap # here to force the interface to be pcap free
    def __init__(self, name, logger, promisc=False):
        self.name = name
        self.logger = logger
        self.handle = self.pcap.pcapObject()

        # configure the pcap device
        self.logger.info("Opening device %s" % repr(name))
        try:
            # snaplen must be long enough for all headers, and short enough that packets aren't dropped
            self.handle.open_live(name, 150, promisc, 1)
        except Exception as e:
            sys.exit("Error opening %s: %s" % (name, e))
        self.handle.setnonblock(True)
        assert self.handle.getnonblock()

        # make a set of all the specific and broadcast addresses from capture object
        self.addresses = set()
        for name, desc, addrs, flags in self.pcap.findalldevs():
            if name == self.name:
                self.addresses.update(*map(lambda x: (x[0], x[2]), addrs))
    def dispatch(self, count, callback):
        def callback_wrapper(pktlen, data, ts):
            callback(pktlen, data, ts, self)
        self.logger.info("Finished dispatching %d packets", self.handle.dispatch(count, callback_wrapper))
    @property
    def datalink(self):
        """Returns the datalink type as a string"""
        return {
                self.pcap.DLT_EN10MB: 'ethernet',
            }[self.handle.datalink()]
    def stats(self):
        """Returns a tuple containing the number of packets transited on the network, and the number of packets dropped by the driver"""
        return self.handle.stats()[0:2]

class EpochHogTraffic(object):
    EPOCH_TYPE = int
    def __init__(self):
        self.__data = {}
    def add_data(self, epoch, nethog, trafdir, nrbytes):
        index = {'out': 0, 'in': 1}[trafdir]
        self[epoch][nethog][index] += nrbytes
    def __getitem__(self, epoch):
        if not isinstance(epoch, self.EPOCH_TYPE):
            raise TypeError()
        return self.__data.setdefault(epoch, ProcessTraffic())
    def get_traffic_for_epochs(self, epochs):
        traffic = ProcessTraffic()
        for e in epochs:
            if e in self.__data:
                traffic += self.__data[e]
        return traffic
    def __setitem__(self, key, value):
        assert self.__data[key] is value
    def iteritems(self):
        return self.__data.iteritems()
    def __iadd__(self, other):
        for epoch, traffic in other.iteritems():
            #existing = self[epoch]
            #existing += traffic
            self[epoch] += traffic
        return self

class ProcessTraffic(dict):
    def __getitem__(self, key):
        return self.setdefault(key, [0, 0])
    def __iadd__(self, other):
        for proc, rates in other.iteritems():
            assert len(rates) == 2
            self[proc][:] = map(operator.add, self[proc], rates)
        return self
    #def __itruediv__(self, other):
        #for rates in self.itervalues():
            #rates[:] = map(lambda x: x / other, rates)
        #return self
    def __truediv__(self, divisor):
        retval = self.__class__()
        for key, value in self.iteritems():
            retval[key] = map(lambda x: x / divisor, value)
            #rates[:] = map(lambda x: x / other, rates)
        return retval

def normalize_data_quantity(quantity, multiple=1024):
    assert (7 / 3) != 2 # ensure true division is in effect
    SUFFIXES = ["B"] + [i + {1000: "B", 1024: "iB"}[multiple] for i in "KMGTPEZY"]
    for suffix in SUFFIXES:
        if quantity < multiple:
            break
        else:
            quantity /= multiple
    if suffix == SUFFIXES[0]:
        quantity = math.ceil(quantity)
        assert quantity.is_integer()
    return ("%5d" if quantity.is_integer() else "%5.1f") % quantity, suffix

def connection_to_procinfo(connection, proctable, lcladdrs, logger):
    inode = proctable.connection_to_inode(connection)
    if inode != None:
        procinfo = proctable.inode_to_procinfo(inode)
        if procinfo != None:
            return procinfo
        else:
            logger.debug("Unknown inode: %d, %s", inode, connection)
            return INODE0_PROCINFO
    assert len(connection.local) == 2
    if connection.local[0] in lcladdrs:
        if connection.family == None:
            if connection.protocol == 'arp':
                return ARP_PROCINFO
            else:
                raise ValueError()
        else:
            logger.debug("Unknown connection: %s" % str(connection))
            return UNKNOWN_PROCINFO

def packet_endpoints_to_connection(pktendps, pktdir):
    if pktdir == 'outbound':
        local = pktendps.source
        remote = pktendps.destination
    elif pktdir == 'inbound':
        remote = pktendps.source
        local = pktendps.destination
    return proctab.Connection(
            local=local, remote=remote,
            family=pktendps.family, protocol=pktendps.protocol)

def packet_endpoints_to_endpoint_process_info(pktendps, proctable, lcladdrs, logger):
    outproci = connection_to_procinfo(
            packet_endpoints_to_connection(pktendps, 'outbound'),
            proctable, lcladdrs, logger)
    inproci = connection_to_procinfo(
            packet_endpoints_to_connection(pktendps, 'inbound'),
            proctable, lcladdrs, logger)
    return outproci, inproci

def process_info_to_network_hog(procinfo, devname):
    return NetworkHog(device=devname, **procinfo._asdict())

def dispatch_traffic_per_process_per_epoch(devcaps, proctable, logger):
    """Return a dictionary mapping an integer epoch to the recorded per process send and receive byte counts for that second."""
    trafdata = EpochHogTraffic()
    def packet_callback(pktlen, data, ts, devcap):
        pktendps = pktanal.analyse_packet(data, devcap.datalink, logger)
        logger.debug("Packet analysis returned: %s, length=%d" % (pktendps, pktlen))
        outproc, inproc = packet_endpoints_to_endpoint_process_info(
                pktendps, proctable, devcap.addresses, logger)
        assert outproc != None or inproc != None
        for procinfo, trafdir in ((outproc, 'out'), (inproc, 'in')):
            if procinfo == None: # the packet has no local endpoint in this direction
                continue
            trafdata.add_data(int(ts), process_info_to_network_hog(procinfo, devcap.name), trafdir, pktlen)
    for dc in devcaps:
        dc.dispatch(-1, packet_callback)
        # don't allow any packets to drop, this should be moved further down the stack
        assert dc.stats()[1] == 0, (dc.name, dc.stats())
    return trafdata

def redraw_screen(win, trafinfo):
    win.clear()
    win.addstr(0, 0, "%s v. %s" % (PROGNAME, VERSION))
    # cols determination could be broken out here, to allow dynamically resizing columns
    COLS = ("pid", 5), ("user", 8), ("program", 33), ("dev", 7), ("sent", 11), ("received", 11)
    LINEFMT = " ".join(["{{{0}:{1}.{1}}}".format(colhdr, width) for colhdr, width in COLS])
    win.addstr(2, 0, LINEFMT.format(**dict([(a[0], a[0].upper()) for a in COLS])), curses.A_REVERSE)
    def keyfunc(x):
        """Sort by the sum of incoming and outgoing traffic"""
        return sum(x[1])
    def rate_to_str(byterate):
        return "%s%s/s" % normalize_data_quantity(byterate)
    linenr = 3
    for nethog, traf in sorted(trafinfo.iteritems(), key=keyfunc, reverse=True):
        if nethog.cmdline != None:
            progargs = nethog.cmdline.split("\x00")
            program = " ".join([os.path.basename(progargs[0])] + progargs[1:])
        else:
            program = "[unknown]"
        line = LINEFMT.format(
                pid=(str(nethog.pid) if nethog.pid != None else ""),
                program=program,
                sent=rate_to_str(traf[0]),
                received=rate_to_str(traf[1]),
                user=nethog.user or "",
                dev=nethog.device)
        #logging.debug(repr(line))
        win.addstr(linenr, 0, line)
        linenr += 1
        #win.addstr(str((proc, traf)) + "\n")
    win.refresh()

class Nethogs2(object):

    def __init__(self, intervals, devnames):
        # make the loggers
        import logging
        self.displayLog = logging.getLogger("display")
        self.packetLog = logging.getLogger("packet")
        self.timingLog = logging.getLogger("timing")
        self.procLog = logging.getLogger("proc")

        # store all the pcap devices we're interested in
        self.devcaps = []
        for dn in devnames:
            dc = DeviceCapture(dn, self.packetLog)
            self.devcaps.append(dc)

        self.proctable = proctab.ProcTable(self.procLog)
        self.refresh = True # refresh immediately
        self.trafinfo = EpochHogTraffic() # {epoch: {NetworkHog: [sent, received]}}
        self.smoothing = intervals['smoothing']
        self.redrawInterval = intervals['refresh']
        self.lastRedraw = None # forces a redraw ASAP

        # set the SIGALRM callback, and ensure it's not already customized
        assert signal.SIG_DFL == signal.signal(signal.SIGALRM, self.alarm_callback)
        # fire a SIGALRM right after the next epoch boundary, and every dispatchInterval thereafter
        dispatchInterval = intervals['dispatch']
        self.firstAlarmEpoch = int(math.ceil(time.time()))
        assert self.firstAlarmEpoch > time.time() # never trust floating point :)
        firstInterval = self.firstAlarmEpoch - time.time()
        # high resolution alarm, also assert it's not already set
        assert (0, 0) == signal.setitimer(signal.ITIMER_REAL, firstInterval, dispatchInterval)

        # start up the pig
        self.run()

    def quit_requested(self):
        while True:
            key = self.stdscr.getch()
            if key == ord('q'):
                return True
            elif key == curses.ERR:
                return False

    def main_loop(self):
        self.redraw_screen(int(time.time()))
        while True:
            while self.refresh:
                self.refresh = False
                if self.quit_requested():
                    return
                self.do_refresh()
            if self.quit_requested():
                return
            signal.pause()

    def alarm_callback(self, *args):
        alarmTime = time.time()
        self.timingLog.debug("Alarm triggered at %f", alarmTime)
        assert alarmTime > self.firstAlarmEpoch
        self.refresh = True

    def run(self):
        print "Starting user interface..."

        def curses_wrapper(stdscr):
            self.stdscr = stdscr
            self.stdscr.nodelay(1)
            try:
                self.main_loop()
            finally:
                del self.stdscr

        #save stderr, and restore it after we return from curses
        oldStderr = sys.stderr
        try:
            sys.stderr = open("nethogs2.stderr", "w")
            curses.wrapper(curses_wrapper)
        finally:
            sys.stderr = oldStderr

    def redraw_screen(self, cursec):
        end = cursec - 1 # don't include this epoch it's incomplete!!
        start = max(end - self.smoothing + 1, self.firstAlarmEpoch)
        sumepochs = tuple(range(start, end + 1))
        self.displayLog.debug("Displaying traffic over %d epochs: %s", len(sumepochs), sumepochs)
        meantraf = self.trafinfo.get_traffic_for_epochs(iter(sumepochs)) / len(sumepochs)
        redraw_screen(self.stdscr, meantraf)
        self.lastRedraw = cursec

    # redraw if necessary
    def should_redraw(self, currentEpoch):
        if self.lastRedraw == None:
            # haven't drawn at all yet
            return True
        elif currentEpoch > self.lastRedraw:
            # the data set has changed
            if currentEpoch - self.lastRedraw >= self.redrawInterval:
                # the redraw interval has expired
                return True
            elif currentEpoch - self.firstAlarmEpoch < self.redrawInterval:
                # we don't yet have a full smoothing period of data
                self.timingLog.info("Traffic for smoothing period incomplete")
                return True
        return False

    def do_refresh(self):
        # this is the epoch for which we cannot display data, it has not finished yet
        updstart = int(time.time())
        self.timingLog.info("Incomplete epoch: %s", updstart)

        # update the proc tables, dispatch packets, and merge the data
        self.proctable.update_table()
        newinfo = dispatch_traffic_per_process_per_epoch(self.devcaps, self.proctable, self.packetLog)
        self.trafinfo += newinfo

        # redraw the screen if required
        if self.should_redraw(updstart):
            self.redraw_screen(updstart)

def unittests():
    pass

def main():
    # parse options
    parser = optparse.OptionParser(version=VERSION)
    parser.usage += " DEVICES..."
    parser.add_option("-d", "--dispatch", help="seconds between packet dispatches and proc polling", type='float')
    parser.add_option("-r", "--refresh", help="time between display updates in seconds", type='int')
    parser.add_option("-s", "--smoothing", help="average the traffic over this many preceding seconds", type='int')
    parser.add_option("--unittests", help="run the tests", action='store_true')
    parser.add_option("--log-conffile", help="filename of a python logging configuration file", type='string')
    parser.add_option("--log-level", help="logging level for root logger", type='string')
    parser.set_defaults(dispatch=0.25, refresh=3, smoothing=3, runtests=False)
    parser.disable_interspersed_args()

    options, posargs = parser.parse_args()

    # configure logging
    import logging
    # set default formatting, and always output to stderr
    logging._defaultFormatter = logging.Formatter(
            "%(levelname)s:%(name)s:%(filename)s(%(lineno)d):%(message)s")
    logging.getLogger().addHandler(logging.StreamHandler(sys.stderr))

    logging.getLogger().setLevel(getattr(logging, (options.log_level or 'warning').upper()))
    if options.log_conffile:
        import logging.config
        logging.config.fileConfig(options.log_conffile)

    if options.unittests:
        unittests()
    else:
        if len(posargs) == 0:
            print "No device specified, defaulting to eth0"
        Nethogs2(
                intervals=dict(dispatch=options.dispatch, refresh=options.refresh, smoothing=options.smoothing),
                devnames=posargs or ("eth0",))

if __name__ == "__main__":
    main()
