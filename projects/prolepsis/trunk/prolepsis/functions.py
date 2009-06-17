import threading
import types
import urllib.request, urllib.parse, urllib.error
import webbrowser

from .tibdb import tibiacom

from .globals import guild_members

def get_char_guild(name):
    for g, m in guild_members.items():
        if name in m:
            guild = g
            break
    else:
        guild = None
    return guild

def open_char_page(event, data):
    name = data[int(event.widget.curselection()[0])]
    print("opening character info in browser:", name)
    webbrowser.open(
            "http://www.tibia.com/community/?"
            + urllib.parse.urlencode({"subtopic": "characters", "name": name}))

stdout_lock = threading.Lock()
def _update_guild_members(gld):
    fresh_gi = tibiacom.guild_info(gld)
    guild_members.setdefault(gld, set())
    with stdout_lock:
        print("updated %-32s (%4d members)" % (gld, len(fresh_gi)))
        for mbr in guild_members[gld].difference(fresh_gi):
            print(mbr, "left", gld)
        for mbr in fresh_gi.difference(guild_members[gld]):
            print(mbr, "joined", gld)
    guild_members[gld].clear()
    guild_members[gld].update(fresh_gi)

def update_guild_members(guilds=None):
    assert not isinstance(guilds, str)
    if guilds is None:
        guilds = tibiacom.guild_list("Dolera")
        prune = True
    else:
        prune = False
    threads = []
    for g in sorted(guilds):
        thrd = threading.Thread(target=_update_guild_members, args=(g,))
        thrd.start()
        threads.append(thrd)
    for t in threads:
        t.join()
    if prune:
        for g in list(guild_members.keys()):
            if g not in guilds:
                print("pruning", g)
                del guild_members[g]
    print("guild member update completed.")

