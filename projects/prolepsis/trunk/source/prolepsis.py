#!/usr/bin/python

import Tkinter
from classes import MainDialog

root = Tkinter.Tk()
main_dialog = MainDialog(root)
root.mainloop()

print "exited mainloop cleanly."
