#!/usr/bin/env python

import pdb, pprint, sys, time, urllib2

import dbiface
sys.path.append("..")
import tibiacom

def update_guilds(world):
    for guild in tibiacom.get_world_guilds(world):
        print >>sys.stderr, "Updating guild", guild
        for member in tibiacom.get_guild_members(guild):
            dbiface.update_char(member, guild=guild, world=world)

def update_world_online(world):
    html, headers = tibiacom.http_get(tibiacom.world_online_url(world))
    players = tibiacom.parse_world_online(html)
    pprint.pprint(players)
    for p in players:
        dbiface.update_char(p.name, level=p.level, vocation=p.vocation, online=True, stamp=headers["Date"], world=world)

def update_char(name):
    info = tibiacom.get_char_page(name)
    dbiface.update_char(info.pop("name"), **info)

def update_recent_deaths(world):
    after = int(time.time()) - 540
    for row in dbiface.get_online_chars(after):
        update_char(row["name"])

def standard_world_update(world):
    update_world_online(world)
    update_recent_deaths(world)

def update_world_list():
    dbiface.set_worlds(tibiacom.tibia_worlds())

def main():
    try:
        globals()[sys.argv[1]](*sys.argv[2:])
    except:
        print sys.exc_info()[1]
        print globals().keys()

def main():
    pprint.pprint(globals()[sys.argv[1]](*sys.argv[2:]))

if __name__ == "__main__":
    main()

#>>> import urllib2
#>>> class HeadRequest(urllib2.Request):
#...     def get_method(self):
#...         return "HEAD"
