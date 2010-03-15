#!/usr/bin/env python

import calendar, logging, pdb, pprint, Queue, sys, threading, time, urllib2

import dbiface, tibiacom
from tibiacom import next_whoisonline_update as next_tibiacom_whoisonline_update

class TibstatDatabase(dbiface.TibstatDatabase):

    def update_guilds(self, world):
        for guild in tibiacom.get_world_guilds(world):
            print >>sys.stderr, "Updating guild", guild
            for member in tibiacom.get_guild_members(guild):
                dbiface.update_char(member, guild=guild, world=world)

    def update_world_online(self, world):
        html, headers = tibiacom.http_get(tibiacom.world_online_url(world))
        players = tibiacom.parse_world_online(html)
        logging.info("Found %d players on %s", len(players), world)
        serverStamp = dbiface.to_unixepoch(headers["Date"])
        assert abs(int(time.time()) - serverStamp) < 30
        print dbiface.to_unixepoch(headers["Date"]), int(time.time())
        for p in players:
            self._update_char(
                    p.name, level=p.level, vocation=p.vocation, online=True,
                    stamp=serverStamp, world=world)
        #self.commit()

    def update_char(self, name):
        info = tibiacom.get_char_page(name)
        self._update_char(info.pop("name"), **info)

    def update_recent_deaths(self, after):
        for row in dbiface.get_online_chars(after):
            update_char(row["name"])

_tsdb = TibstatDatabase()
for a in ("update_world_online", "update_char"):
    assert not hasattr(sys.modules[__name__], a)
    setattr(sys.modules[__name__], a, getattr(_tsdb, a))

def standard_world_update(world, *options):
    nextUpdate = next_tibiacom_whoisonline_update()
    options = list(options)
    while True:
        if "immediate" not in options:
            logging.info("Waiting for %s", time.asctime(time.localtime(nextUpdate)))
            while True:
                if time.time() >= nextUpdate:
                    break
                else:
                    time.sleep(1)
            nextUpdate = next_tibiacom_whoisonline_update()
        else:
            options.remove("immediate")
        startTime = int(time.time())
        update_world_online(world)
        update_recent_deaths(world)
        logging.info("Update took %ds", int(time.time()) - startTime)
        if "once" in options:
            break

def update_world_list():
    dbiface.set_worlds(tibiacom.tibia_worlds())

def _continuous_update_thread_func(jobqueue, errflag):
    tsdb = TibstatDatabase()
    while not errflag.is_set():
        try:
            job = jobqueue.get()
            #print job
            if job is None:
                return
            job[0](tsdb, *job[1:])
            tsdb.commit()
        except:
            errflag = True
            raise
        finally:
            jobqueue.task_done()

def continuous_update(*worlds):

    worlds = set(worlds)
    def get_option(optstr):
        try:
            worlds.remove(optstr)
            return True
        except KeyError:
            return False
    immediate = get_option("immediate")
    once = get_option("once")
    if not worlds:
        worlds = set((x["name"] for x in dbiface.get_worlds()))

    jobqueue = Queue.Queue()
    threads = []
    errflag = threading.Event()
    for a in xrange(5):
        threads.append(threading.Thread(
                target=_continuous_update_thread_func,
                args=(jobqueue, errflag)))
        threads[-1].start()

    try:
        nextUpdate = next_tibiacom_whoisonline_update()
        while True:
            if not immediate:
                logging.info("Waiting for %s", time.asctime(time.localtime(nextUpdate)))
                while True:
                    if time.time() >= nextUpdate:
                        break
                    else:
                        time.sleep(int(time.time()) + 1 - time.time())
                nextUpdate = next_tibiacom_whoisonline_update()

            startTime = int(time.time())

            # update the world online lists
            for w in worlds:
                jobqueue.put((TibstatDatabase.update_world_online, w))
            jobqueue.join()

            # check the time hasn't gone over into the next update period
            if not immediate:
                assert time.time() < nextUpdate

            charCount = 0
            for w in worlds:
                for row in dbiface.get_online_chars(
                        after=(nextUpdate - 10 * 60),
                        world=w):
                    jobqueue.put((TibstatDatabase.update_char, row["name"]))
                    charCount += 1
            logging.info("Updating %d chars", charCount)
            jobqueue.join()

            logging.info("Update took %ds", int(time.time()) - startTime)
            if once:
                break
            immediate = False
    finally:
        assert jobqueue.empty()
        for a in threads:
            jobqueue.put(None)
        for a in threads:
            a.join()
        jobqueue.join()

def main():
    logging.basicConfig(
            level=logging.INFO,
            stream=sys.stdout,
            format="%(levelname)s:%(process)d:%(message)s")
    pprint.pprint(globals()[sys.argv[1]](*sys.argv[2:]))
    _tsdb.commit()

if __name__ == "__main__":
    main()

#>>> import urllib2
#>>> class HeadRequest(urllib2.Request):
#...     def get_method(self):
#...         return "HEAD"
