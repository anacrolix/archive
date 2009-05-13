#!/usr/bin/python

# imports ordered in ascending ubiquity

import sys
sys.path.append("tibdb")
import tibiacom

import tkFont
import Tkinter

import os
import shelve
import threading
import time
import types
import urllib
import webbrowser

STANCES = (
        ("Friend", "blue"),
        ("Ally", "#20b020"),
        ("Enemy", "red"),
    )

VERSION = "0.3.0_svn"

class Functor:
    def __init__(self, func, *largs, **kwargs):
        self.func = func
        self.largs = largs
        self.kwargs = kwargs
    def __call__(self):
        self.func(*self.largs, **self.kwargs)

class StanceContextMenu:
    def __init__(self, parent, listbox, callback, itemdata, stances):
        self.menu = Tkinter.Menu(parent, tearoff=False)
        for i in range(len(STANCES)):
            self.menu.add_command(
                    label="Set as " + STANCES[i][0],
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

        self.button = Tkinter.Button(
                self.dialog,
                text="Fetch Guild List",
                command=self.fetch_guild_list)
        self.button.pack(side=Tkinter.BOTTOM)

        self.scrollbar = Tkinter.Scrollbar(self.dialog)
        self.scrollbar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)

        self.listbox_data = []

        self.listbox = Tkinter.Listbox(
                self.dialog,
                height=20,
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

        self.refresh_listbox()

    def stance_changed(self):
        self.refresh_listbox()
        main_dialog.refresh_listbox()

    def refresh_listbox(self):
        self.listbox.delete(0, Tkinter.END)
        del self.listbox_data[:]
        # sort by stances first, then by guild name
        items = sorted(guild_stances.items(), key=lambda (k, v): (v, k))
        items += [ (x, None) for x in sorted(guild_members.keys()) if x not in guild_stances.keys() ]
        for guild, stance in items:
            self.listbox.insert(Tkinter.END, guild)
            if stance is not None:
                self.listbox.itemconfig(Tkinter.END, fg=STANCES[stance][1])
            self.listbox_data.append(guild)

    def fetch_guild_list(self):
        guilds = tibiacom.guild_list("Dolera")
        for g in guilds:
            guild_members.setdefault(g, set())
        self.refresh_listbox()

class ActiveCharacterList:
    def __init__(self, world):
        self.world = world
        self.chars = {}
        self.last_online_list = None
    def update_from_online_list(self):
        stamp, chars = tibiacom.online_list(self.world)
        print time.ctime(stamp) + ": retrieved", len(chars), "characters"
        char_set = set([
                tuple([getattr(x, y) for y in ("name", "level", "vocation")])
                for x in chars])
        if self.last_online_list is not None:
            went_offline = self.last_online_list.difference(char_set)
            came_online = char_set.difference(self.last_online_list)
            changed = len(went_offline) + len(came_online)
            print "came online:", sorted(came_online, key=lambda x: x[1], reverse=True)
            print "went offline:", sorted(went_offline, key=lambda x: x[1], reverse=True)
        else:
            changed = False
        self.last_online_list = char_set
        for name, info in self.chars.iteritems():
            assert "name" not in vars(info)
            if not name in [x.name for x in chars]:
                info.last_offline = stamp
        for c in chars:
            name = c.name
            del c.name
            c.last_online = stamp
            if self.chars.has_key(name):
                self.chars[name].update(c)
            else:
                c.last_offline = None
                self.chars[name] = c
        return stamp, changed
    def online_count(self):
        return len(filter(lambda x: x.last_offline is None or x.last_offline < x.last_online, self.chars.values()))

class MainDialog:
    def __init__(self, root):
        self.dialog = root
        self.dialog.title("Prolepsis " + VERSION)

        self.statusbar = Tkinter.Label(
                self.dialog,
                text="Error!",
                anchor=Tkinter.W,
                justify=Tkinter.LEFT,
                relief=Tkinter.SUNKEN,
                borderwidth=1)
        self.statusbar.pack(side=Tkinter.BOTTOM, fill=Tkinter.X)

        scrollbar = Tkinter.Scrollbar(self.dialog)
        scrollbar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)

        listbox_font = tkFont.Font(size=9, weight=tkFont.BOLD)
        try:
            listbox_font.config(family={
                    "posix": "Monospace",
                    "nt": "Courier New"
                }[os.name])
        except KeyError:
            pass

        self.listbox_data = []

        self.listbox = Tkinter.Listbox(
                self.dialog,
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
                        root, self.listbox, self.refresh_listbox, self.listbox_data, char_stances)
                    .handler)
        self.listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)

        scrollbar.config(command=self.listbox.yview)

        self.menubar = Tkinter.Menu(root)

        self.list_sort_mode = Tkinter.StringVar(value='level')

        self.list_menu = Tkinter.Menu(self.menubar, tearoff=False)

        self.sortby_menu = Tkinter.Menu(self.dialog, tearoff=False)
        for s in ("level", "stance", "vocation", "guild"):
            self.sortby_menu.add_radiobutton(
                    label=s.capitalize(),
                    variable=self.list_sort_mode,
                    command=self.refresh_listbox,
                    value=s)

        self.list_menu.add_cascade(label="Sort by", menu=self.sortby_menu)

        self.list_show_guild = Tkinter.BooleanVar(value=True)
        self.list_show_unguilded = Tkinter.BooleanVar(value=True)

        self.list_menu.add_checkbutton(
                label="Show character's guild",
                variable=self.list_show_guild,
                command=self.refresh_listbox)
        self.list_menu.add_checkbutton(
                label="Show unguilded characters",
                variable=self.list_show_unguilded,
                command=self.refresh_listbox)

        self.menubar.add_cascade(label="List", menu=self.list_menu)

        self.guild_menu = Tkinter.Menu(self.menubar, tearoff=False)
        self.guild_menu.add_command(label="Update members", command=self.update_guild_members)
        self.guild_menu.add_command(
                label="Modify stances",
                command=lambda: GuildStanceDialog(self.dialog))

        self.menubar.add_cascade(label="Guilds", menu=self.guild_menu)

        self.always_on_top = Tkinter.BooleanVar(value=False)

        self.window_menu = Tkinter.Menu(self.menubar, tearoff=False)
        self.window_menu.add_checkbutton(
                label="Always on top",
                variable=self.always_on_top,
                command=self.always_on_top_command)

        self.menubar.add_cascade(label="Window", menu=self.window_menu)

        self.help_menu = Tkinter.Menu(self.menubar, tearoff=False)
        self.help_menu.add_command(
                label="Wiki Howto",
                command=lambda: webbrowser.open("http://code.google.com/p/anacrolix/wiki/Prolepsis"))
        self.help_menu.add_command(
                label="Report issue",
                command=lambda: webbrowser.open("http://code.google.com/p/anacrolix/issues/list"))
        self.help_menu.add_separator()
        self.help_menu.add_command(label="About", state=Tkinter.DISABLED)

        self.menubar.add_cascade(label="Help", menu=self.help_menu)

        self.dialog.config(menu=self.menubar)

        self.dialog.update()
        self.dialog.after_idle(self.refresh_statusbar, True)
        self.dialog.after_idle(self.refresh_listbox, True)
        self.dialog.after_idle(self.update)

        self.first_update = None
        self.last_update = None
        self.next_update = None
        self.char_data = ActiveCharacterList("Dolera")

    def update_guild_members(self):
        update_guild_members()
        self.refresh_listbox()

    def always_on_top_command(self):
        self.dialog.wm_attributes("-topmost", self.always_on_top.get())

    def refresh_statusbar(self, daemonic=False):
        try:
            if self.last_update is None:
                last = "never"
            else:
                last = "%ds ago" % (time.time() - self.last_update,)
            if self.next_update is None:
                next = "now"
            else:
                next = "in %ds" % (self.next_update - time.time(),)
            text = \
                ("World: Dolera (%d players online)\n" + \
                "Last update: %s. Next update: %s") \
                % (self.char_data.online_count(), last, next,)
            self.statusbar.config(text=text)
            self.statusbar.pack()
        except:
            self.statusbar.config(text="Fucking Error!")
            raise
        finally:
            if daemonic:
                self.dialog.after(1000, self.refresh_statusbar, True)
            #else:
                # considering an idle update here to push statusbar changes

    def refresh_listbox(self, daemonic=False):
        try:
            items = []
            for name, info in self.char_data.chars.iteritems():
                if info.vocation == "N": continue
                # get guild
                for g, m in guild_members.iteritems():
                    if name in m:
                        guild = g
                        break
                    else:
                        guild = None
                # get stance
                try: stance = char_stances[name]
                except KeyError:
                    try: stance = guild_stances[guild]
                    except KeyError: stance = None
                if stance is None and (info.level < 45 or not self.list_show_unguilded.get()):
                    continue
                # background
                assert info.last_offline != info.last_online
                background = None
                if info.last_online > info.last_offline:
                    if not info.last_offline is None and time.time() - info.last_offline < 300:
                        background = "white"
                else:
                    if time.time() - info.last_online < 600:
                        background = "light grey"
                    else:
                        continue
                items.append([name, info.level, info.vocation, background, stance, guild])

            level_sort = lambda x: -x[1]
            stance_sort = lambda x: dict(zip((0, 2, 1, None), range(4)))[x[4]]
            vocation_sort = lambda x: dict(
                    zip(("MS", "ED", "RP", "EK", "S", "D", "P", "K", "N"), range(9)))[x[2]]
            guild_sort = lambda x: x[5]

            items.sort(key=lambda x: tuple([y(x) for y in {
                    'level': (level_sort,),
                    'stance': (stance_sort, level_sort,),
                    'vocation': (vocation_sort, stance_sort, level_sort,),
                    'guild': (guild_sort, level_sort,),
                }[self.list_sort_mode.get()]]))

            self.listbox.delete(0, Tkinter.END)
            for i in items:
                fmt = "%3i%3s %-20s"
                vals = [i[1], i[2], i[0]]
                if not i[5] is None and self.list_show_guild.get():
                    fmt += " (%s)"
                    vals.append(i[5])
                text = fmt % tuple(vals)
                self.listbox.insert(Tkinter.END, text)
                if not i[3] is None:
                    self.listbox.itemconfig(Tkinter.END, bg=i[3], selectbackground=i[3])
                stance = i[4]
                if stance is not None:
                    fg = STANCES[i[4]][1]
                    if not i[4] is None:
                        self.listbox.itemconfig(Tkinter.END, fg=fg, selectforeground=fg)
            self.listbox_data[:] = [x[0] for x in items]
            print "refreshed listbox" + (" (daemon)" if daemonic else ""), time.ctime()
        finally:
            if daemonic:
                self.dialog.after(30000, self.refresh_listbox, True)

    def update(self):
        update_started = time.time()
        update_delay = 60000
        self.next_update = None
        try:
            self.refresh_statusbar(daemonic=False)
            self.dialog.update_idletasks()

            stamp, changed = self.char_data.update_from_online_list()
            self.last_update = stamp

            if changed: update_delay = 290000

            self.refresh_listbox()
        finally:
            # take into account the time taken to perform this update. negative delays will just trigger an immediate update
            mark = time.time()
            update_delay -= int((mark - update_started) * 1000)
            self.dialog.after(update_delay, self.update)
            self.next_update = mark + update_delay / 1000
            print "next update in", update_delay, "ms"

def display_predicate(name, level, vocation):
    return level >= 45 and vocation != "N" or not get_char_fg_config(name) is None

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
