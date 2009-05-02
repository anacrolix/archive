#!/usr/bin/python

import sys
sys.path.append("tibdb")
import tibiacom
import os
import shelve
import threading
import time
import Tkinter
import tkFont
import types
import urllib
import webbrowser

class Functor:
    def __init__(self, func, *largs, **kwargs):
        self.func = func
        self.largs = largs
        self.kwargs = kwargs
    def __call__(self):
        self.func(*self.largs, **self.kwargs)

STANCES = ("Friend", "Ally", "Enemy")

class CharListboxMenu:
    def __init__(self, parent, listbox, callback, listbox_data):
        self.menu = Tkinter.Menu(parent, tearoff=False)
        for i in range(len(STANCES)):
            self.menu.add_command(
                    label="Set as " + STANCES[i],
                    command=Functor(lambda s: self.set_stance(s), i))
        self.menu.add_command(label="Close")
        self.parent = parent
        self.listbox = listbox
        self.callback = callback
        self.listbox_data = listbox_data
    def set_stance(self, stance):
        print "set stance", stance, "on index", self.index
        char_stances[self.listbox_data[self.index]] = stance
        print char_stances
        self.callback()
    def handler(self, event):
        self.menu.post(event.x_root, event.y_root)
        self.index = self.listbox.nearest(event.y)

def open_char_page(event, data):
    name = data[int(event.widget.curselection()[0])]
    print "opening character info in browser:", name
    webbrowser.open("http://www.tibia.com/community/?" + urllib.urlencode({"subtopic": "characters", "name": name}))

class MainDialog:
    def __init__(self, root):
        self.tkref = root
        self.tkref.title("Prolepsis 0.2.0")

        self.statusbar = Tkinter.Label(
                self.tkref,
                text="Error!",
                anchor=Tkinter.W,
                relief=Tkinter.SUNKEN,
                borderwidth=1)
        self.statusbar.pack(side=Tkinter.BOTTOM, fill=Tkinter.X)

        scrollbar = Tkinter.Scrollbar(self.tkref)
        scrollbar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)

        listbox_font = tkFont.Font(size=9)
        try:
            listbox_font.config(family={
                    "posix": "Monospace",
                    "nt": "Courier New"
                }[os.name])
        except KeyError:
            pass

        self.listbox_data = []
        self.listbox = Tkinter.Listbox(
                self.tkref,
                yscrollcommand=scrollbar.set,
                font=listbox_font,
                bg="light yellow",
                selectmode=Tkinter.SINGLE,
                height=30,
                width=40,
                relief=Tkinter.FLAT,
            )
        self.listbox.config(
                selectbackground=self.listbox["bg"],
                selectforeground=self.listbox["fg"])
        self.listbox.bind(
                "<Double-Button-1>",
                lambda event: open_char_page(event, self.listbox_data))

        self.listbox.bind(
                "<Button-3>",
                CharListboxMenu(
                        root, self.listbox, self.refresh, self.listbox_data)
                    .handler)
        self.listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)

        scrollbar.config(command=self.listbox.yview)

        self.tkref.update_idletasks()
        self.tkref.after_idle(self.update)

        self.last_count = None
        self.stale_chars = {}
        self.online_chars = {}

    def refresh(self):
        # list(tuple(name, level, vocation, background))
        listbox_items = []
        for name, (level, vocation, stamp) in self.stale_chars.iteritems():
            if not name in self.online_chars.keys() \
                    and display_predicate(name, level, vocation) \
                    and time.time() - stamp < 900:
                print "add stale:", time.ctime(stamp), name
                listbox_items += [(name, level, vocation, "light grey")]
        for name, (level, vocation, stamp) in self.online_chars.iteritems():
            if display_predicate(name, level, vocation):
                # bg is default unless the char has recently logged in
                if self.stale_chars.has_key(name) and stamp - self.stale_chars[name][2] > 150:
                    bg = None
                else:
                    bg = "white"
                listbox_items.append((name, level, vocation, bg))
        listbox_items.sort(key=lambda x: x[1], reverse=True)
        self.listbox.delete(0, self.listbox.size() - 1)
        for name, level, vocation, bg in listbox_items:
            # this must be done before the call to char_item_string to ensure the necessary guilds have been populated
            fg = get_fg_config(name)
            self.listbox.insert(Tkinter.END, char_item_string(name, level, vocation))
            if fg is not None:
                self.listbox.itemconfig(Tkinter.END, fg=fg, selectforeground=fg)
            if bg is not None:
                self.listbox.itemconfig(Tkinter.END, bg=bg, selectbackground=bg)
        self.listbox_data[:] = [x[0] for x in listbox_items]

    def update(self):
        update_started = time.time()
        prev_sb_text = self.statusbar.cget("text")
        update_delay = 60000
        try:
            self.statusbar.config(text="Updating...")
            self.tkref.update_idletasks()

            stamp, o = tibiacom.online_list("Dolera")
            print time.ctime(stamp) + ":", "retrieved", len(o), "characters"
            for k, v in self.online_chars.iteritems():
                if self.stale_chars.has_key(k):
                    self.stale_chars[k] = (v[0], v[1], self.stale_chars[k][2])
                else:
                    self.stale_chars[k] = v
            self.online_chars = {}
            for c in o:
                self.online_chars[c.name] = (c.level, c.vocation, stamp)
            del c, o

            self.refresh()

            self.statusbar.config(text="Updated: " + time.strftime("%I:%M:%S %p", time.localtime(stamp)))
        except:
            self.statusbar.config(text=prev_sb_text)
            raise
        else:
            if len(self.online_chars) != self.last_count and self.last_count is not None:
                update_delay = 290000
            self.last_count = len(self.online_chars)
        finally:
            # take into account the time taken to perform this update. negative delays will just trigger an immediate update
            update_delay -= int((time.time() - update_started) * 1000)
            print "next update in", update_delay, "ms"
            self.tkref.after(update_delay, self.update)

def char_item_string(name, level, vocation):
    fmt = "%3i%3s %-20s"
    vals = [level, vocation, name]
    for gld, mbrs in guild_members.iteritems():
        if name in mbrs:
            fmt += " (%s)"
            vals.append(gld)
            break
    return fmt % tuple(vals)

def display_predicate(name, level, vocation):
    return level >= 45 and vocation != "N" or not get_fg_config(name) is None

def get_fg_config(name):
    colors = ("blue", "sea green", "red")
    try:
        return colors[char_stances[name]]
    except:
        for gld, clri in guild_stances.iteritems():
            if not guild_members.has_key(gld):
                update_guild_members([gld])
            if name in guild_members[gld]:
                return colors[clri]

guild_members = shelve.open("members")
stdout_lock = threading.Lock()
def _update_guild_members(gld):
    guild_members[gld] = tibiacom.guild_info(gld)
    with stdout_lock:
        print "retrieved", len(guild_members[gld]), "members of guild:", gld

def update_guild_members(glds):
    assert not isinstance(glds, types.StringTypes)
    thrds = []
    for g in glds:
        thrds.append(threading.Thread(target=_update_guild_members, args=(g,)))
        thrds[-1].start()
    for t in thrds:
        t.join()

# 0 friend, 1 ally, 2 enemy
char_stances = shelve.open("stances").setdefault("char", {})
guild_stances = {'Del Chaos': 1, 'Murderers Inc': 1, 'Deadly': 1, 'Blackened': 1, 'Torture': 1, 'Blitzkriieg': 1, 'Malibu-Nam': 1, 'Chaos Riders': 1, 'Ka Bros': 1, 'Unholly Soulz': 1, 'Tartaro': 1, 'Dipset': 2, 'Waterloo': 2, 'State': 0}

root = Tkinter.Tk()
main = MainDialog(root)
root.mainloop()
