import atexit
import os
import shelve
import configparser
import tkinter.font

print("run config")

config = configparser.RawConfigParser()
config.add_section("listbox font")
config.set("listbox font", "size", 9)
config.set("listbox font", "weight", tkinter.font.BOLD)
try:
    config.set("listbox font", "family", {
            "posix": "Monospace",
            "nt": "Courier New"
        }[os.name])
except KeyError:
    pass

__STANCE_TITLES = ("friend", "ally", "enemy")
config.add_section("stance colors")
for st_c in zip(__STANCE_TITLES, ("blue", "#20b020", "red")):
    config.set("stance colors", *st_c)

__CONFNAME = "prolepsis.conf"

config_file = open(__CONFNAME, "r+" if os.path.exists(__CONFNAME) else "w+")
config.readfp(config_file)
config_file.seek(0)
config.write(config_file)
config_file.close()
del config_file

STANCES = tuple([(st.capitalize(), config.get("stance colors", st)) for st in __STANCE_TITLES])
VERSION = "0.3.0_svn"

members_shelf = shelve.open("members", writeback=True)
guild_members = members_shelf

stances_shelf = shelve.open("stances", writeback=True)
char_stances = stances_shelf.setdefault("char", {})
guild_stances = stances_shelf.setdefault("guild", {})

@atexit.register
def cleanup():
    members_shelf.sync()
    stances_shelf.sync()
