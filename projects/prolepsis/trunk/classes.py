import os
import sys
import threading
import time
import webbrowser

import tkFont
import Tkinter

from tibdb import tibiacom
from functions import get_char_guild, open_char_page, update_guild_members
from globals import char_stances, guild_stances, guild_members, VERSION, STANCES

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
        #if sys.platform not in ("win32",):
            #self.menu.add_command(label="Close")
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
            self.menu.tk_popup(event.x_root, event.y_root)

class ListboxContextMenu:
    def __init__(self, parent, listbox, callback, itemdata, char_stances, guild_stances):
        self.parent = parent
        self.listbox = listbox
        self.callback = callback
        self.itemdata = itemdata
        self.char_stances = char_stances
        self.guild_stances = guild_stances
    def handler(self, event):
        try: self.menu.destroy()
        except AttributeError: pass

        index = self.listbox.nearest(event.y)
        if index < 0: return
        self.curdatum = self.itemdata[index]
        self.menu = Tkinter.Menu(self.parent, tearoff=False)
        for i in range(len(STANCES)):
            self.menu.add_command(
                    label="Set char as " + STANCES[i][0],
                    command=Functor(self.set_char_stance, i))
        if self.char_stances.has_key(self.curdatum):
            self.menu.add_command(
                    label="Unset char stance",
                    command=Functor(self.set_char_stance, None))
        guild = get_char_guild(self.curdatum)
        if guild is not None:
            self.menu.add_separator()
            for i in range(len(STANCES)):
                self.menu.add_command(
                        label="Set guild as " + STANCES[i][0],
                        command=Functor(self.set_guild_stance, i))
            if self.guild_stances.has_key(guild):
                self.menu.add_command(
                        label="Unset guild stance",
                        command=Functor(self.set_guild_stance, None))
        #if sys.platform not in ("win32",):
            #self.menu.add_separator()
            #self.menu.add_command(label="Close")
        self.menu.tk_popup(event.x_root, event.y_root)
    def set_char_stance(self, stance):
        key = self.curdatum
        if stance is None:
            if self.char_stances.has_key(key):
                del self.char_stances[key]
        else:
            self.char_stances[key] = stance
        print self.char_stances
        self.callback()
    def set_guild_stance(self, stance):
        key = get_char_guild(self.curdatum)
        assert key is not None
        if stance is None:
            if self.guild_stances.has_key(key):
                del self.guild_stances[key]
        else:
            self.guild_stances[key] = stance
        print self.guild_stances
        self.callback()

class GuildStanceDialog:
    def __init__(self, parent, callback):
        self.callback = callback

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
        self.callback()

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
        # determine changed
        char_set = set([
                tuple([getattr(x, y) for y in ("name", "level", "vocation")])
                for x in chars])
        if self.last_online_list is not None:
            went_offline = self.last_online_list.difference(char_set)
            came_online = char_set.difference(self.last_online_list)
            changed = len(went_offline) + len(came_online)
            if changed:
                print "came online:", sorted(came_online, key=lambda x: x[1], reverse=True)
                print "went offline:", sorted(went_offline, key=lambda x: x[1], reverse=True)
        else:
            changed = False
        self.last_online_list = char_set
        # update chars
        for name, info in self.chars.iteritems():
            assert "name" not in vars(info).keys()
            if not name in [x.name for x in chars]:
                info.set_online(False, stamp)
        for c in chars:
            name = c.name
            del c.name
            if self.chars.has_key(name):
                self.chars[name].update(c)
            else:
                self.chars[name] = c
            self.chars[name].set_online(True, stamp)
        return stamp, changed
    def parse_potential_recent_deaths(self):
        threads = []
        slowdown = threading.Semaphore(20)
        for name, info in self.chars.iteritems():
            if not info.is_online() or time.time() - info.last_offline() > 1200:
                continue
            def get_info(name):
                with slowdown:
                    info = tibiacom.char_info(name)
                self.chars[name].deaths = info["deaths"]
                sys.stdout.write(".")
                sys.stdout.flush()
            thrd = threading.Thread(target=get_info, args=(name,))
            thrd.start()
            threads.append(thrd)
        for t in threads: t.join()
    def online_count(self):
        return len(filter(lambda x: x.is_online(), self.chars.values()))
    class PlayerKill:
        def __init__(self, victim, time, final):
            self.victim = victim
            self.time = time
            self.final = final
        def is_pzlocked(self):
            return time.time() - tibiacom.tibia_time_to_unix(self.time) < (1020 if self.final else 180)
    def get_player_killers(self):
        retval = {}
        def add_player_kill(killer, victim, time, final):
            retval.setdefault(killer, [])
            retval[killer].append(self.PlayerKill(victim, time, final))
        for name, info in self.chars.iteritems():
            if not hasattr(info, "deaths"): continue
            for death in info.deaths:
                if death[2][0]:
                    add_player_kill(death[2][1], name, death[0], True)
                if death[3] is not None and death[3][0]:
                    add_player_kill(death[3][1], name, death[0], False)
        return retval

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

        self.pzlock_button = Tkinter.Button(text="Update PZ locks", command=self.update_pzlocks)
        self.pzlock_button.pack(side=Tkinter.BOTTOM)

        # can't seem to flatten the scrollbar on windows
        self.scrollbar = Tkinter.Scrollbar(self.dialog)
        self.scrollbar.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)


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
                yscrollcommand=self.scrollbar.set,
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
                ListboxContextMenu(
                        root, self.listbox, self.refresh_listbox,
                        self.listbox_data, char_stances, guild_stances)
                    .handler)
        self.listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)

        self.scrollbar.config(command=self.listbox.yview)

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
                command=lambda: GuildStanceDialog(self.dialog, self.refresh_listbox))

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
                last = "%ds ago" % (round(time.time() - self.last_update),)
            if self.next_update is None:
                next = "now"
            else:
                next = "in %ds" % (round(self.next_update - time.time()),)
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
            player_kills = self.char_data.get_player_killers()
            items = []
            for name, info in self.char_data.chars.iteritems():
                death = False
                if hasattr(info, "deaths"):
                    for d in info.deaths:
                        if tibiacom.tibia_time_to_unix(d[0]) > time.time() - 1200:
                            death = True
                            break
                # get guild
                guild = get_char_guild(name)
                # get stance
                try: stance = char_stances[name]
                except KeyError:
                    try: stance = guild_stances[guild]
                    except KeyError: stance = None
                # background
                #assert info.last_offline != info.last_online
                background = None
                if info.is_online():
                    assert self.first_update is not None
                    if time.time() - info.last_offline() < 300 and info.last_offline() != self.first_update:
                        background = "white"
                else:
                    if time.time() - info.last_online() < 300:
                        background = "light grey"
                    else:
                        if not death: continue
                pzlocked = False
                if player_kills.has_key(name):
                    for kill in player_kills[name]:
                        if kill.is_pzlocked():
                            pzlocked = True
                if not death and not pzlocked and (info.vocation == "N" or stance is None and (info.level < 45 or not self.list_show_unguilded.get())):
                    continue
                items.append((name, info.level, info.vocation, background, stance, guild, death, pzlocked))

            STANCE_KEY = dict(zip((2, 0, 1, None), range(4)))
            level_sort = lambda x: -x[1]
            stance_sort = lambda x: STANCE_KEY[x[4]]
            vocation_sort = lambda x: dict(
                    zip(("MS", "ED", "RP", "EK", "S", "D", "P", "K", "N"), range(9)))[x[2]]

            def guild_sort(item):
                guild = item[5]
                try: guild_stance = guild_stances[item[5]]
                except KeyError: guild_stance = None
                return (STANCE_KEY[guild_stance], guild)

            items.sort(key=lambda x: tuple([y(x) for y in {
                    'level': (level_sort,),
                    'stance': (stance_sort, level_sort,),
                    'vocation': (vocation_sort, stance_sort, level_sort,),
                    'guild': (guild_sort, level_sort,),
                }[self.list_sort_mode.get()]]))

            listbox_offset = self.listbox.yview()[0]
            print listbox_offset
            self.listbox.delete(0, Tkinter.END)
            for name, level, vocation, background, stance, guild, death, pzlocked in items:
                fmt = "%3i%3s %-20s"
                vals = [level, vocation, name]
                if guild is not None and self.list_show_guild.get():
                    fmt += " (%s)"
                    vals.append(guild)
                text = fmt % tuple(vals)
                self.listbox.insert(Tkinter.END, text)
                fg = None
                if stance is not None:
                    fg = STANCES[stance][1]
                if death: fg = "magenta"
                if not fg is None:
                    self.listbox.itemconfig(Tkinter.END, fg=fg, selectforeground=fg)
                if not background is None:
                    self.listbox.itemconfig(Tkinter.END, bg=background, selectbackground=background)
                if pzlocked:
                    for opt in ("bg", "fg"):
                        clrstr = self.listbox.itemcget(Tkinter.END, opt) or self.listbox.cget(opt)
                        fliprgb = tuple([255 - (x >> 8) for x in self.listbox.winfo_rgb(clrstr)])
                        clrstr = "#" + 3 * "%02x" % fliprgb
                        print name, opt, clrstr
                        self.listbox.itemconfig(Tkinter.END, **dict(((opt, clrstr),)))
            self.listbox.yview_moveto(listbox_offset)
            self.listbox_data[:] = [x[0] for x in items]
            print "refreshed listbox" + (" (daemon)" if daemonic else ""), time.ctime()
        finally:
            if daemonic:
                self.dialog.after(30000, self.refresh_listbox, True)

    def update_pzlocks(self):
        self.char_data.parse_potential_recent_deaths()
        self.refresh_listbox()

    def update(self):
        update_started = time.time()
        update_delay = 60000
        self.next_update = None
        try:
            self.refresh_statusbar(daemonic=False)
            self.dialog.update_idletasks()

            stamp, changed = self.char_data.update_from_online_list()
            if self.first_update is None: self.first_update = stamp
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
