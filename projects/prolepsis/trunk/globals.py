import atexit
import shelve

STANCES = (
        ("Friend", "blue"),
        ("Ally", "#20b020"),
        ("Enemy", "red"),
    )

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
