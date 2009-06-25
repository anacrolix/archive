import tkinter
import tkinter.font
from tkinter import ttk

root = tkinter.Tk()
print("available ttk themes:", tkinter.ttk.Style().theme_names())
print("default ttk theme:", tkinter.ttk.Style().theme_use())

from . import dialogs
from .globals import config

# this will probably break on windows
for theme in eval(config.get("global theme", "priority")):
    ttk.Style().theme_use(theme)
    break
listbox_font = tkinter.font.Font(**dict(config.items("listbox font")))
ttk.Style().configure("charlist."+ttk.Treeview().winfo_class(), font=listbox_font)
main_dialog = dialogs.MainDialog(root, listbox_font)

def main():
    root.mainloop()
    print("Exited Tk mainloop.")
