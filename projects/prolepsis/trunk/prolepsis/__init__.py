import Tkinter
import tkFont
import dialogs
from globals import config

root = Tkinter.Tk()
listbox_font = tkFont.Font(**dict(config.items("listbox font")))
main_dialog = dialogs.MainDialog(root, listbox_font)

def main():
    root.mainloop()
    print "Exited Tk mainloop."
