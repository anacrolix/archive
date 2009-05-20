import os
import pdb
import sys
import ConfigParser
import Tkinter
import tkFont
import dialogs

config = ConfigParser.RawConfigParser()
config.add_section("listbox font")
config.set("listbox font", "size", 9)
config.set("listbox font", "weight", tkFont.BOLD)
try:
    config.set("listbox font", "family", {
            "posix": "Monospace",
            "nt": "Courier New"
        }[os.name])
except KeyError:
    pass

CONFNAME = "prolepsis.conf"

config_file = open(CONFNAME, "r+" if os.path.exists(CONFNAME) else "w+")
#config.readfp(open(CONFNAME, "r+"))
config.readfp(config_file)
config_file.seek(0)
config.write(config_file)
config_file.close()

root = Tkinter.Tk()
listbox_font = tkFont.Font(**dict(config.items("listbox font")))
main_dialog = dialogs.MainDialog(root, listbox_font)

def main():
    root.mainloop()
    print "Exited Tk mainloop."
