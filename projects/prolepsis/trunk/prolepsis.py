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
COLORS = ("blue", "#20b020", "red")

class StanceContextMenu:
    def __init__(self, parent, listbox, callback, itemdata, stances):
        self.menu = Tkinter.Menu(parent, tearoff=False)
        for i in range(len(STANCES)):
            self.menu.add_command(
                    label="Set as " + STANCES[i],
                    command=Functor(self.set_stance, i))
        self.menu.add_command(label="Unset stance", command=Functor(self.set_stance, None))
        self.menu.add_command(label="Close")
        self.parent = parent
        self.listbox = listbox
        self.callback = callback
        self.itemdata = itemdata
        self.stances = stances
    def set_stance(self, stance):
        print "set stance", stance, "on index", self.index
        key = self.itemdata[self.index]
        if stance is None:
            if self.stances.has_key(key):
                del self.stances[key]
        else:
            self.stances[key] = stance
        print self.stances
        self.callback()
    def handler(self, event):
        self.index = self.listbox.nearest(event.y)
        if self.index >= 0:
            self.menu.post(event.x_root, event.y_root)

def open_char_page(event, data):
    name = data[int(event.widget.curselection()[0])]
    print "opening character info in browser:", name
    webbrowser.open(
            "http://www.tibia.com/community/?"
            + urllib.urlencode({"subtopic": "characters", "name": name}))

class GuildStanceDialog:
    def __init__(self, parent):
        self.dialog = Tkinter.Toplevel(parent)
        self.dialog.transient(parent)
        self.dialog.title("Guild Stances")
        self.dialog.grab_set()

        self.scrollbar = Tkinter.Scrollbar(self.dialog)
        self.scrollbar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)

        self.listbox_data = []

        self.listbox = Tkinter.Listbox(
                self.dialog,
                yscrollcommand=self.scrollbar.set)
        self.listbox.bind(
                "<Button-3>",
                StanceContextMenu(
                        self.dialog,
                        self.listbox,
                        self.stance_changed,
                        self.listbox_data,
                        guild_stances)
                    .handler)
        self.listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)
        self.scrollbar.config(command=self.listbox.yview)

        self.button = Tkinter.Button(self.dialog, text="Fetch Guild List", command=self.fetch_guild_list)
        self.button.pack()

        self.refresh_listbox()

    def stance_changed(self):
        self.refresh_listbox()
        main_dialog.refresh()

    def refresh_listbox(self):
        self.listbox.delete(0, Tkinter.END)
        del self.listbox_data[:]
        # sort by stances first, then by guild name
        items = sorted(guild_stances.items(), key=lambda (k, v): (v, k))
        items += [ (x, None) for x in sorted(guild_members.keys()) if x not in guild_stances.keys() ]
        for guild, stance in items:
            self.listbox.insert(Tkinter.END, guild)
            if stance is not None:
                self.listbox.itemconfig(Tkinter.END, fg=COLORS[stance])
            self.listbox_data.append(guild)

    def fetch_guild_list(self):
        guilds = tibiacom.guild_list("Dolera")
        for g in guilds:
            guild_members.setdefault(g, set())
        self.refresh_listbox()


class MainDialog:
    def __init__(self, root):
        self.tkref = root
        self.tkref.title("Prolepsis 0.2.0")
        #self.tkref.wm_attributes("-topmost", True)

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
                StanceContextMenu(
                        root, self.listbox, self.refresh, self.listbox_data, char_stances)
                    .handler)
        self.listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)

        scrollbar.config(command=self.listbox.yview)

        self.menubar = Tkinter.Menu(root)

        self.guild_menu = Tkinter.Menu(self.menubar, tearoff=False)
        self.guild_menu.add_command(label="Update members", command=self.update_guild_members)
        self.guild_menu.add_command(
                label="Modify stances",
                command=lambda: GuildStanceDialog(self.tkref))
        self.menubar.add_cascade(label="Guilds", menu=self.guild_menu)

        self.window_menu = Tkinter.Menu(self.menubar, tearoff=False)
        self.always_on_top = Tkinter.BooleanVar()
        self.always_on_top.set(False)
        self.window_menu.add_checkbutton(
                label="Always on top",
                variable=self.always_on_top,
                command=self.always_on_top_command)
        self.menubar.add_cascade(label="Window", menu=self.window_menu)

        self.help_menu = Tkinter.Menu(self.menubar, tearoff=False)
        self.help_menu.add_command(
                label="Report issue...",
                command=lambda: webbrowser.open("http://code.google.com/p/anacrolix/issues/list"))
        self.help_menu.add_separator()
        self.help_menu.add_command(label="About", state=Tkinter.DISABLED)
        self.menubar.add_cascade(label="Help", menu=self.help_menu)

        self.tkref.config(menu=self.menubar)

        self.tkref.update_idletasks()
        self.tkref.after_idle(self.update)

        self.last_count = None
        self.stale_chars = {}
        self.online_chars = {}

    def update_guild_members(self):
        update_guild_members()
        self.refresh()

    def always_on_top_command(self):
        self.tkref.wm_attributes("-topmost", self.always_on_top.get())

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
        self.listbox.delete(0, Tkinter.END)
        for name, level, vocation, bg in listbox_items:
            # this must be done before the call to char_item_string to ensure the necessary guilds have been populated
            fg = get_char_fg_config(name)
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

            self.refresh()

            new_sb_text = "Updated %s (%i online)" % (
                    time.strftime("%I:%M:%S %p", time.localtime(stamp)),
                    len(self.online_chars))
            self.statusbar.config(text=new_sb_text)
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
    return level >= 45 and vocation != "N" or not get_char_fg_config(name) is None

def get_char_fg_config(name):
    try:
        return COLORS[char_stances[name]]
    except KeyError:
        for gld, clri in guild_stances.iteritems():
            if not guild_members.has_key(gld):
                update_guild_members([gld])
            if name in guild_members[gld]:
                return COLORS[clri]

members_shelf = shelve.open("members", writeback=True)
guild_members = members_shelf
stdout_lock = threading.Lock()
def _update_guild_members(gld):
    fresh_gi = tibiacom.guild_info(gld)
    guild_members.setdefault(gld, set())
    with stdout_lock:
        print "updated %-32s (%4d members)" % (gld, len(fresh_gi))
        for mbr in guild_members[gld].difference(fresh_gi):
            print mbr, "left", gld
        for mbr in fresh_gi.difference(guild_members[gld]):
            print mbr, "joined", gld
    guild_members[gld].clear()
    guild_members[gld].update(fresh_gi)

def update_guild_members(guilds=None):
    assert not isinstance(guilds, types.StringTypes)
    if guilds is None:
        guilds = tibiacom.guild_list("Dolera")
        prune = True
    else:
        prune = False
    thrds = []
    for g in sorted(guilds):
        thrds.append(threading.Thread(target=_update_guild_members, args=(g,)))
        thrds[-1].start()
    for t in thrds:
        t.join()
    if prune:
        for g in guild_members.keys():
            if g not in guilds:
                print "pruning", g
                del guild_members[g]
    print "guild member update completed."

# 0 friend, 1 ally, 2 enemy
stances_shelf = shelve.open("stances", writeback=True)
char_stances = stances_shelf.setdefault("char", {})
guild_stances = stances_shelf.setdefault("guild", {})

root = Tkinter.Tk()
main_dialog = MainDialog(root)
root.mainloop()

print "exited mainloop cleanly."
