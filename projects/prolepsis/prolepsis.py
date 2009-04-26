#!/usr/bin/python

import sys
sys.path.append("tibdb")
import tibiacom
import Tkinter
import tkFont
import os
import threading
import time

root = Tkinter.Tk()
root.title("prolepsis")
#root.geometry("300x400")
#root.config(width=300)

scrollbar = Tkinter.Scrollbar(root)
scrollbar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)

listbox_font = tkFont.Font(size=9)
try: listbox_font.config(family={"posix": "Monospace", "nt": "Courier New"}[os.name])
except KeyError: pass
listbox = Tkinter.Listbox(
        root,
        yscrollcommand=scrollbar.set,
        font=listbox_font,
        bg="light yellow",
        selectmode=Tkinter.SINGLE,
        height=30,
        width=40,
    )
listbox.config(selectbackground=listbox["bg"], selectforeground=listbox["fg"])
listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)

scrollbar.config(command=listbox.yview)
root.update_idletasks()

stale = []
oldcount = None

guilds = {}
def _update_guild_members(gld):
    guilds[gld] = tibiacom.guild_info(gld)
    print "retrieved", len(guilds[gld]), "members of guild:", gld

def update_guild_members(*glds):
    thrds = []
    for g in glds:
        thrds.append(threading.Thread(target=_update_guild_members, args=[g]))
        thrds[-1].start()
    for t in thrds:
        t.join()

enemies = [
        ["Dipset", "Waterloo"],
        []
    ]
allies = [
        ["Del Chaos", "Murderers Inc", "Deadly", "Blackened", "Torture", "Blitzkriieg", "Malibu-Nam"],
        []
    ]

update_guild_members(*set(enemies[0] + allies[0]))
root.update_idletasks()

def char_item_string(char):
    fmt = "%3i%3s %-20s"
    vals = [char.level, char.vocation, char.name]
    for gld, mbrs in guilds.iteritems():
        if char.name in mbrs:
            fmt += " (%s)"
            vals.append(gld)
            break
    return fmt % tuple(vals)

def display_predicate(char):
    return char.level >= 45 and char.vocation != "N"

def get_fg_config(char):
    conf = {
            "red": enemies,
            "sea green": allies,
        }
    for fg, (glds, chrs) in conf.iteritems():
        for c in chrs:
            if char.name == c:
                return fg
        for g in glds:
            if not guilds.has_key(g):
                update_guild_members(g)
            if char.name in guilds[g]:
                return fg

def update():
    oldsize = listbox.size()
    start =time.time()
    online = tibiacom.online_list("Dolera")[1]
    count = len(online)
    print time.ctime() + ":", "retrieved", count, "characters"
    # list(tuple(Character, background))
    items = []
    global stale, oldcount
    for char in stale:
        if not char in online and display_predicate(char):
            items += [(char, "light grey")]
    # take a copy of online, modifying the list being iterated caused a serious bug
    for char in online[:]:
        if display_predicate(char):
            # bg is default unless the char has recently logged in
            items += [(char, None if char in stale else "white")]
        else:
            # prevent the char from hitting the stale list. this way a char suddenly satisfying the predicate is considered a new threat
            online.remove(char)
    items.sort(key=lambda x: x[0].level, reverse=True)
    for i in items:
        # this must be done before the call to char_item_string to ensure the necessary guilds have been populated
        fg = get_fg_config(i[0])
        listbox.insert(Tkinter.END, char_item_string(i[0]))
        if fg is not None:
            listbox.itemconfig(Tkinter.END, fg=fg, selectforeground=fg)
        if i[1] is not None:
            listbox.itemconfig(Tkinter.END, bg=i[1], selectbackground=i[1])
    listbox.delete(0, oldsize - 1)

    # update every 60s, until the online count changes, this must be within 60s of the server update time, which has an alleged interval of 5min. then we delay 5s short of 5mins until we get a repeated online count, we must have fallen short of the next update. this prevents us from migrating away from the best time to update.
    if not oldcount or oldcount == count:
        delay = 60000
    else:
        delay = 295000
    # take into account the time taken to perform this update. negative delays will just trigger an immediate update
    delay -= int((time.time() - start) * 1000)
    print "next update in", delay, "ms"
    root.after(delay, update)
    stale = online
    oldcount = count

update()
root.mainloop()
