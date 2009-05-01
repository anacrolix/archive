#!/usr/bin/python

import sys
sys.path.append("tibdb")
import tibiacom
#import copy
import os
#import shelve
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
    def __init__(self, parent, listbox):
	self.menu = Tkinter.Menu(parent, tearoff=False)
	for i in range(len(STANCES)):
	    self.menu.add_command(
		    label="Set as " + STANCES[i],
		    command=Functor(lambda s: self.set_stance(s), i))
	self.menu.add_command(label="Close")
	self.listbox = listbox
    def set_stance(self, stance):
	print "set stance", stance, "on index", self.index
    def handler(self, event):
	self.menu.post(event.x_root, event.y_root)
	self.index = self.listbox.nearest(event.y)

def open_char_page(event):
    name = event.widget.data[int(event.widget.curselection()[0])]
    print "opening character info in browser:", name
    webbrowser.open("http://www.tibia.com/community/?" + urllib.urlencode({"subtopic": "characters", "name": name}))

class MainDialog:
    def __init__(self, root):
	self.tkref = root
	self.tkref.title("Prolepsis 0.2.0")

	statusbar = Tkinter.Label(self.tkref,
		text="Loading...",
		anchor=Tkinter.W,
		relief=Tkinter.SUNKEN,
		borderwidth=1)
	statusbar.pack(side=Tkinter.BOTTOM, fill=Tkinter.X)

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

	listbox = Tkinter.Listbox(
		self.tkref,
		yscrollcommand=scrollbar.set,
		font=listbox_font,
		bg="light yellow",
		selectmode=Tkinter.SINGLE,
		height=30,
		width=40,
		relief=Tkinter.FLAT,
	    )
	listbox.config(selectbackground=listbox["bg"], selectforeground=listbox["fg"])
	listbox.bind("<Double-Button-1>", open_char_page)

	listbox.bind("<Button-3>", CharListboxMenu(root, listbox).handler)
	listbox.pack(fill=Tkinter.BOTH, expand=Tkinter.YES)

	scrollbar.config(command=listbox.yview)

	root.update_idletasks()
	root.after_idle(update, root, statusbar, listbox)

def char_item_string(char):
    fmt = "%3i%3s %-20s"
    vals = [char.level, char.vocation, char.name]
    for gld, mbrs in guild_members.iteritems():
	if char.name in mbrs:
	    fmt += " (%s)"
	    vals.append(gld)
	    break
    return fmt % tuple(vals)

def display_predicate(char):
    return char.level >= 45 and char.vocation != "N" or not get_fg_config(char) is None

def get_fg_config(char):
    colors = ("blue", "sea green", "red")
    try:
	return colors[char_stances[char.name]]
    except:
	for gld, clri in guild_stances.iteritems():
	    if not guild_members.has_key(gld):
		update_guild_members([gld])
	    if char.name in guild_members[gld]:
		return colors[clri]

def update(root, statusbar, listbox):
    start = time.time()
    count = None
    oldlabel = statusbar.cget("text")
    try:
	statusbar.config(text="Updating...")
	root.update_idletasks()
	stamp, online = tibiacom.online_list("Dolera")
	oldsize = listbox.size()
	count = len(online)
	print time.ctime(stamp) + ":", "retrieved", count, "characters"
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
	#global listbox_data
	listbox.data = [x[0].name for x in items]
	statusbar.config(text="Updated: " + time.ctime(stamp))
    except:
	statusbar.config(text=oldlabel)
	raise
    else:
	statusbar.config(text="Updated: " + time.ctime(stamp))
    finally:
	# update every 60s, until the online count changes, this must be within 60s of the server update time, which has an alleged interval of 5min. then we delay 10s short of 5mins until we get a repeated online count, we must have fallen short of the next update. this prevents us from migrating away from the best time to update.
	if not oldcount or count is None or oldcount == count:
	    delay = 60000
	else:
	    delay = 290000
	# take into account the time taken to perform this update. negative delays will just trigger an immediate update
	delay -= int((time.time() - start) * 1000)
	print "next update in", delay, "ms"
	root.after(delay, update, root, statusbar, listbox)
    stale = online
    oldcount = count

guild_members = {}
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
char_stances = {'Lyndon': 0, 'Red Hat': 0, 'Eruanno': 0, 'Chaotic Resonance': 0}
guild_stances = {'Del Chaos': 1, 'Murderers Inc': 1, 'Deadly': 1, 'Blackened': 1, 'Torture': 1, 'Blitzkriieg': 1, 'Malibu-Nam': 1, 'Chaos Riders': 1, 'Ka Bros': 1, 'Unholly Soulz': 1, 'Tartaro': 1, 'Dipset': 2, 'Waterloo': 2}

stale = []
oldcount = None

root = Tkinter.Tk()
main = MainDialog(root)
update_guild_members(guild_stances.keys())
root.mainloop()
