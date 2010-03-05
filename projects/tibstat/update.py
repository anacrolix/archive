#!/usr/bin/env python

import calendar, logging, pdb, pprint, sys, time, urllib2

import dbiface, tibiacom

def update_guilds(world):
    for guild in tibiacom.get_world_guilds(world):
        print >>sys.stderr, "Updating guild", guild
        for member in tibiacom.get_guild_members(guild):
            dbiface.update_char(member, guild=guild, world=world)

def update_world_online(world):
    html, headers = tibiacom.http_get(tibiacom.world_online_url(world))
    players = tibiacom.parse_world_online(html)
    logging.debug(pprint.pformat(players))
    logging.info("Found %d players on %s", len(players), world)
    for p in players:
        dbiface.update_char(p.name, level=p.level, vocation=p.vocation, online=True, stamp=headers["Date"], world=world)

def update_char(name):
    info = tibiacom.get_char_page(name)
    dbiface.update_char(info.pop("name"), **info)

def update_recent_deaths(world):
    after = int(time.time()) - 300
    for row in dbiface.get_online_chars(after):
        update_char(row["name"])

def next_tibiacom_whoisonline_update(secs=None):
    """Returns the unix epoch of the next reasonable time to update from tibia.com whoisonline pages"""
    a = list(time.gmtime(secs))
    min = (((((a[4] - 1) // 5) + 1) * 5) + 1)
    return calendar.timegm(a[0:4] + [min, 0] + a[6:9])

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

def main():
    try:
        globals()[sys.argv[1]](*sys.argv[2:])
    except:
        print sys.exc_info()[1]
        print globals().keys()

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
