import tkinter
import tkinter.font
from . import dialogs
from .globals import config

root = tkinter.Tk()
# this will probably break on windows
tkinter.ttk.Style().theme_use("clam")
listbox_font = tkinter.font.Font(**dict(config.items("listbox font")))
main_dialog = dialogs.MainDialog(root, listbox_font)

def main():
    root.mainloop()
    print("Exited Tk mainloop.")
