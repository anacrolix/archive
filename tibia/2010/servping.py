#!/usr/bin/env python

SERVIPS_FNAME = "ips.txt"

def download_server_ips():
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
    return times

def print_server_latencies(count, subset, timeout):
    lags = server_latencies(count=count, subset=subset)
    meaned = []
    for server, times in lags.iteritems():
        logger.info("Timings for %s: %s", server, times)
        item = (int(round(1000 * sum(times) / float(count))), server)
        meaned.append(item)
    for ping, server in sorted(meaned, reverse=True):
        print "%5d %s" % (ping, server)

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
    parser.add_option("-c", "--count", help="number of pings to each server", type='int', default=1)
    parser.add_option("-u", "--update", help="update server list from internet", action='store_true')
    parser.add_option("-t", "--timeout", help="timeout on pings after this many seconds", type='float', default=1.0)
    #parser.add_option("-s", "--sort", help="sort by name (default), ping, ip", type='string', default='name')
    options, posargs = parser.parse_args()

    import os.path
    if not os.path.exists(SERVIPS_FNAME) or options.update:
        download_server_ips()
    print_server_latencies(options.count, subset=(posargs or None), timeout=options.timeout)

if __name__ == "__main__":
    # put logger on global level
    import logging
    logging.basicConfig(level=logging.WARNING)
    logger = logging.getLogger()
    del logging
    main()
