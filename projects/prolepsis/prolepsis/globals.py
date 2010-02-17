import atexit
import os
import configparser
import tkinter.font
from tkinter import ttk

print("run config")

config = configparser.RawConfigParser()

# set the default config values

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

config.add_section("global theme")

default_theme = ttk.Style().theme_use()
config.set(
        "global theme", "priority",
        repr([default_theme if default_theme != "default" else "clam"])
    )

# now clobber default config from configuration file

__CONFNAME = "prolepsis.conf"
config_file = open(__CONFNAME, "r+" if os.path.exists(__CONFNAME) else "w+")
config.readfp(config_file)
# write out the available themes
config.set("global theme", "available", ttk.Style().theme_names())
config_file.seek(0)
config.write(config_file)
config_file.close()
del config_file

# load several variables from their shelves

STANCES = tuple([(st.capitalize(), config.get("stance colors", st)) for st in __STANCE_TITLES])
VERSION = "1.0"

def __open_shelf(filename):
    """clobber shelf files if they're somehow incompatible (such as version change)"""
    import shelve, dbm, sys
    kwargs = dict(writeback=True)
    try:
        return shelve.open(filename, **kwargs)
    except dbm.error as e:
        print(e, file=sys.stderr)
        kwargs.update(flag='n')
        print(kwargs)
        try:
            return shelve.open(filename, **kwargs)
        except dbm.error:
            print("can't open shelf, deleting it:", filename)
            os.remove(filename)
            return shelve.open(filename, **kwargs)

members_shelf = __open_shelf("members")
guild_members = members_shelf

stances_shelf = __open_shelf("stances")
char_stances = stances_shelf.setdefault("char", {})
guild_stances = stances_shelf.setdefault("guild", {})

@atexit.register
def cleanup():
    members_shelf.sync()
    stances_shelf.sync()
