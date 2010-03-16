#!/usr/bin/env python

import calendar, logging, pdb, pprint, Queue, sys, threading, time, traceback, urllib2

import dbiface, tibiacom
from dbiface import TibstatDatabase
from tibiacom import next_whoisonline_update as next_tibiacom_whoisonline_update

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
    try:
        tsdb = TibstatDatabase()
        while not errflag.is_set():
            job = jobqueue.get()
            try:
                #print job
                if job is None:
                    return
                job[0](tsdb, *job[1:])
                #tsdb.commit()
            finally:
                jobqueue.task_done()
    except:
        errflag.set()
        while not jobqueue.empty():
            try:
                jobqueue.get_nowait()
            except Queue.Empty:
                break
        raise
    finally:
        print "thread quit", errflag.is_set()

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
            if errflag.is_set():
                return

            # check the time hasn't gone over into the next update period
            if not immediate:
                assert time.time() < nextUpdate

            charCount = 0
            for w in worlds:
                for row in TibstatDatabase().get_online_chars(
                        after=(nextUpdate - 10 * 60),
                        world=w):
                    jobqueue.put((TibstatDatabase.update_char, row["name"]))
                    charCount += 1
            logging.info("Updating %d chars", charCount)
            jobqueue.join()
            if errflag.is_set():
                return

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
        #jobqueue.join()

def _char_incomplete(charRow):
    for field in charRow.keys():
        if field not in ("guild", "created", "deletion", "former_names"):
            if charRow[field] is None:
                return True
    else:
        return False

def update_incomplete_chars(world=None):
    for char in dbiface.get_all_chars(world):
        #print char
        charName = char["name"]
        assert charName
        if _char_incomplete(char):
            logging.info("Updating %r", charName)
            try:
                newCharName = dbiface.update_char(charName)
            except tibiacom.CharDoesNotExist as e:
                assert e.args[0] == charName
                logging.warning("Character %r does not exist", charName)
            else:
                newCharRow = dbiface.get_char(newCharName)
                #print newCharRow
                assert not _char_incomplete(newCharRow), newCharRow
                #dbiface.commit()

def main():
    logging.basicConfig(
            level=logging.INFO,
            stream=sys.stdout,
            format="%(levelname)s:%(process)d:%(message)s")
    pprint.pprint(globals()[sys.argv[1]](*sys.argv[2:]))

if __name__ == "__main__":
    main()

#>>> import urllib2
#>>> class HeadRequest(urllib2.Request):
#...     def get_method(self):
#...         return "HEAD"
