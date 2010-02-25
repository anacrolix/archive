#!/usr/bin/env python

import os, Queue, sys, threading, time, unittest
import __init__ as tibiacom

def sync_world_online(world):
    lastchars = None
    while True:
        html, headers = tibiacom.http_get(tibiacom.url.world_online(world))
        newchars = tibiacom.parse.world_online(html=html)[1]
        if lastchars is None:
            print "First read", headers["Date"]
        elif newchars != lastchars:
            print "Page changed", headers["Date"]
        lastchars = newchars
        time.sleep(10)

def show_recent_deaths(world):
    queue = Queue.Queue()
    outlock = threading.Lock()
    for char in tibiacom.parse.world_online(tibiacom.http_get(tibiacom.url.world_online(world))[0]):
        if char.vocation != "None":
            queue.put(char)
    def print_recent_deaths():
        while True:
            try:
                char = queue.get_nowait()
                #print "Scanning %s..." % char.name
            except Queue.Empty:
                return
            for death in tibiacom.get_char_info(char.name)["deaths"]:
                if tibiacom.parse.tibia_time_to_unix(death.time) >= time.time() - 3600:
                    with outlock:
                        tibiacom.pretty.pprint_death(death, char.name)
    allthrds = []
    for i in xrange(1):
        t = threading.Thread(target=print_recent_deaths)
        t.start()
        allthrds.append(t)
    for t in allthrds:
        t.join()

def main():
    globals()[sys.argv[1]](*sys.argv[2:])

if __name__ == "__main__":
    main()
