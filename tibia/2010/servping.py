#!/usr/bin/env python

import sys

SERVIPS_FNAME = "ips.txt"

def download_server_ips():
    print >>sys.stderr, "Downloading World Server IPs"
    import  urllib, zipfile
    from StringIO import StringIO as MemFile
    params = urllib.urlencode({"txtDownloadID": "112", "submit": "Download"})
    r = urllib.urlopen("http://www.blackdtools.com/freedownloads.php", params)
    f = MemFile(r.read())
    z = zipfile.ZipFile(f, 'r')
    z.extract(SERVIPS_FNAME)

def parse_server_ips():
    for line in open(SERVIPS_FNAME):
        server, ip = line.split()
        yield line.split()

def server_latencies(count, timeout=1.0, subset=None):
    import random, socket, sys, time
    servips = dict(parse_server_ips())
    pingservs = servips.keys()
    if subset != None:
        subset = set(map(str.capitalize, subset))
        for s in subset:
            if s not in pingservs:
                sys.exit("Server %r is not in server list file" % (s,))
        pingservs = list(subset.intersection(pingservs))
    times = {}
    for _ in xrange(count):
        random.shuffle(pingservs)
        for servname in pingservs:
            times.setdefault(servname, [])
            sock = socket.socket()
            sock.settimeout(timeout)
            address = (servips[servname], 7171)
            started = time.time()
            try:
                sock.connect(address)
            except socket.error as e:
                logger.warning("Error pinging %s (%s): %s", servname, address[0], e)
                latency = 10 * timeout
            else:
                latency = time.time() - started
                #sys.stderr.write(".")
                logger.debug("Connected to %s in %d ms", servname, round(1000 * latency))
            times[servname].append(latency)
            sock.close()
    return dict(((k, (servips[k], v)) for k, v in times.iteritems()))

def print_server_latencies(count, subset, timeout, sortcol, sortdir):
    lags = server_latencies(count=count, subset=subset)
    meaned = []
    for server, (ipstr, times) in lags.iteritems():
        logger.info("Timings for %s: %s", server, times)
        item = (int(round(1000 * sum(times) / float(count))), server, ipstr)
        meaned.append(item)
    keyfunc, defsort = {
            'name': (lambda x: x[1], False),
            'ping': (lambda x: x[0], True),
            'ip': (lambda x: x[2], False),
        }[sortcol]
    if sortdir in ("asc",):
        sortdesc = False
    elif sortdir in ("desc",):
        sortdesc = True
    else:
        sortdesc = defsort
    for a in sorted(meaned, key=keyfunc, reverse=sortdesc):
        print "%5d %-32s %s" % a

def main():
    # pause after executing for noobs not running from the shell
    import atexit, os
    def press_any_key():
        if os.name == 'nt':
            os.system("pause")
    atexit.register(press_any_key)

    import optparse
    parser = optparse.OptionParser()
    parser.usage += " SERVERS..."
    parser.description = "Pings the given SERVERS (all servers if SERVERS is the empty set) COUNT times each, and returns the mean connect latency."
    parser.add_option("-c", "--count", help="number of pings to each server", type='int', default=2)
    parser.add_option("-u", "--update", help="update server list from internet", action='store_true')
    parser.add_option("-t", "--timeout", help="timeout on pings after this many seconds", type='float', default=1.0)
    parser.add_option("-s", "--sort", help="sort by name (default), ping, ip", type='string', default='name')
    parser.add_option("-d", "--sort-dir", help="sort ascending or descending, default is appropriate for the sort column")
    options, posargs = parser.parse_args()

    import os.path
    if not os.path.exists(SERVIPS_FNAME) or options.update:
        download_server_ips()
    print_server_latencies(
            options.count,
            subset=(posargs or None),
            timeout=options.timeout,
            sortcol=options.sort,
            sortdir=options.sort_dir)

if __name__ == "__main__":
    # put logger on global level
    import logging
    logging.basicConfig(level=logging.WARNING)
    logger = logging.getLogger()
    del logging
    main()
