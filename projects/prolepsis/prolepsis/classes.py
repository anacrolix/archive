import os
import pdb
import queue
import sys
import threading
import time
import webbrowser

import tkinter.font
import tkinter

from .tibdb import tibiacom
from .functions import get_char_guild, open_char_page, update_guild_members
from .globals import char_stances, guild_stances, guild_members, VERSION, STANCES

class Functor:
    def __init__(self, func, *largs, **kwargs):
        self.func = func
        self.largs = largs
        self.kwargs = kwargs
    def __call__(self):
        self.func(*self.largs, **self.kwargs)

class StanceContextMenu:
    def __init__(self, parent, listbox, callback, itemdata, stances):
        self.menu = tkinter.Menu(parent, tearoff=False)
        for i in range(len(STANCES)):
            self.menu.add_command(
                    label="Set as " + STANCES[i][0],
                    command=Functor(self.set_stance, i))
        self.menu.add_command(label="Unset stance", command=Functor(self.set_stance, None))
        self.parent = parent
        self.listbox = listbox
        self.callback = callback
        self.itemdata = itemdata
        self.stances = stances
    def set_stance(self, stance):
        print("set stance", stance, "on index", self.index)
        key = self.itemdata[self.index]
        if stance is None:
            if key in self.stances:
                del self.stances[key]
        else:
            self.stances[key] = stance
        print(self.stances)
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

        itemid = self.listbox.identify_row(event.y)
        assert len(self.listbox.parent(itemid)) == 0
        index = self.listbox.index(itemid)
        print(itemid, index)
        if index < 0 or len(itemid) == 0: return
        self.curdatum = self.itemdata[index]
        self.menu = tkinter.Menu(self.parent, tearoff=False)
        for i in range(len(STANCES)):
            self.menu.add_command(
                    label="Set char as " + STANCES[i][0],
                    command=Functor(self.set_char_stance, i))
        if self.curdatum in self.char_stances:
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
            if guild in self.guild_stances:
                self.menu.add_command(
                        label="Unset guild stance",
                        command=Functor(self.set_guild_stance, None))
        self.menu.tk_popup(event.x_root, event.y_root)
    def set_char_stance(self, stance):
        key = self.curdatum
        if stance is None:
            if key in self.char_stances:
                del self.char_stances[key]
        else:
            self.char_stances[key] = stance
        #print self.char_stances
        self.callback()
    def set_guild_stance(self, stance):
        key = get_char_guild(self.curdatum)
        assert key is not None
        if stance is None:
            if key in self.guild_stances:
                del self.guild_stances[key]
        else:
            self.guild_stances[key] = stance
        #print self.guild_stances
        self.callback()

class PlayerKill:
    def __init__(self, victim, time, final):
        self.victim = victim
        self.time = time
        self.final = final
    def is_pzlocked(self, killer_info):
        assert isinstance(killer_info, tibiacom.Character)
        if time.time() - tibiacom.tibia_time_to_unix(self.time) >= (1080 if self.final else 180):
            #print "rejected:", self.victim, self.time, self.final
            print("NOT RECENT")
            return False
        if hasattr(killer_info, "deaths"):
            for d in killer_info.deaths:
                assert isinstance(d, tuple) and len(d) == 4
                if tibiacom.tibia_time_to_unix(d[0]) >= tibiacom.tibia_time_to_unix(self.time):
                    print("LATER DIED", d)
                    return False
        if killer_info.is_online() and killer_info.last_offline() > tibiacom.tibia_time_to_unix(self.time):
            print("OFFLINE SINCE KILL")
            return False
        #print "accepted pzlock!"
        print("ACCEPTED")
        return True
    def __repr__(self):
        return " ".join((self.time, self.victim, "(" + ("final" if self.final else "assist") + ")"))

class ActiveCharacterList:
    def __init__(self, world):
        self.world = world
        self.chars = {}
        self.last_online_list = None
    def update_from_online_list(self):
        stamp, chars = tibiacom.online_list(self.world)
        print(time.ctime(stamp) + ": retrieved", len(chars), "characters")
        # determine changed
        char_set = set([
                tuple([getattr(x, y) for y in ("name", "level", "vocation")])
                for x in chars])
        if self.last_online_list is not None:
            went_offline = self.last_online_list.difference(char_set)
            came_online = char_set.difference(self.last_online_list)
            changed = len(went_offline) + len(came_online)
            if changed:
                print("came online:", sorted(came_online, key=lambda x: x[1], reverse=True))
                print("went offline:", sorted(went_offline, key=lambda x: x[1], reverse=True))
        else:
            changed = False
        self.last_online_list = char_set
        # update chars
        for name, info in self.chars.items():
            assert "name" not in list(vars(info).keys())
            if not name in [x.name for x in chars]:
                info.set_online(False, stamp)
        for c in chars:
            name = c.name
            del c.name
            if name in self.chars:
                self.chars[name].update(c)
            else:
                self.chars[name] = c
            self.chars[name].set_online(True, stamp)
        return stamp, changed
    def parse_potential_recent_deaths(self, refresh):
        from queue import Queue, Empty
        queue = Queue()
        for name, info in self.chars.items():
            if (info.is_online() or time.time() - info.last_online() < 1200) and info.vocation != 'N':
                queue.put(name)
        task_count = queue.qsize()
        def get_info():
            while True:
                try:
                    name = queue.get(block=False)
                    tasks_left = queue.qsize()
                except Empty:
                    return
                info = tibiacom.char_info(name)
                self.chars[name].deaths = info["deaths"]
                refresh()
                queue.task_done()
                print("pzlock update: %d/%d" % ((task_count - tasks_left), task_count))
        threads = []
        for i in range(10):
            thrd = threading.Thread(target=get_info)
            thrd.start()
            threads.append(thrd)
        queue.join()
        for t in threads:
            t.join()
    def online_count(self):
        return len([x for x in list(self.chars.values()) if x.is_online()])
    def get_player_killers(self):
        retval = {}
        def add_player_kill(killer, victim, time, final):
            retval.setdefault(killer, [])
            retval[killer].append(PlayerKill(victim, time, final))
        for name, info in self.chars.items():
            if not hasattr(info, "deaths"): continue
            for death in info.deaths:
                if death[2][0]:
                    add_player_kill(death[2][1], name, death[0], True)
                if death[3] is not None and death[3][0]:
                    add_player_kill(death[3][1], name, death[0], False)
        return retval

class WidgetState:
    def __init__(self, widget, set="config", get="cget", index=None):
        self.widget = widget
        self._set = set
        self._get = get
        self.index = (index,) if index is not None else ()
    def set(self, *args, **kwargs):
        return getattr(self.widget, self._set)(*self.index + args, **kwargs)
    def get(self, *args, **kwargs):
        return getattr(self.widget, self._get)(*self.index + args, **kwargs)
    def disable(self):
        assert self.get("state") != tkinter.DISABLED
        self.set(state=tkinter.DISABLED)
    def enable(self):
        print("widget state:", self.get("state"))
        assert self.get("state") != tkinter.NORMAL
        self.set(state=tkinter.NORMAL)

class JobQueue:
    def __init__(self):
        self.__queue = queue.Queue()
    def post(self, callback, *args, **kwargs):
        assert hasattr(callback, '__call__')
        self.__queue.put((callback, args, kwargs))
    def send(self, callback, *args, **kwargs):
        self.post(callback, *args, **kwargs)
        self.__queue.join()
    def process(self):
        while True:
            try:
                callback, args, kwargs = self.__queue.get(False)
            except queue.Empty:
                break
            callback(*args, **kwargs)
            self.__queue.task_done()

class DateRape:
    def __init__(self):
        self.lock = threading.Lock()
        self.thread = None
    def __call__(self):
        if not self.lock.acquire(False):
            return False
        try:
            assert self.thread is None or self.thread.is_alive() is False
            self.thread = threading.Thread(target=self.run)
            self.thread.daemon = True
            self.thread.start()
            return True
        finally:
            self.lock.release()
    def run(self):
        raise NotImplementedError

class AsyncWidgetCommand(DateRape):
    def __init__(self, tkroot, command):
        DateRape.__init__(self)
        self.tkroot = tkroot
        self.tkroot.after(1, self.update)
        if command is not None:
            self.command = command
        self.widgets = []
        self.jobqueue = JobQueue()
    def add_widget(self, widget, setcmd):
        if not isinstance(widget, WidgetState):
            widget = WidgetState(widget)
        if setcmd: widget.set(command=self)
        self.widgets.append(widget)
        if not setcmd: return self
    def run(self):
        for w in self.widgets:
            self.jobqueue.send(w.disable)
        cmdrv = self.command(self.jobqueue)
        #print cmdrv
        if cmdrv is not None:
            assert isinstance(cmdrv, tuple)
            self.jobqueue.send(self.tkroot.after, cmdrv[0], self, *cmdrv[1:])
        for w in self.widgets:
            self.jobqueue.post(w.enable)
    def command(self):
        raise NotImplementedError
    def update(self):
        self.jobqueue.process()
        self.tkroot.after(1, self.update)
