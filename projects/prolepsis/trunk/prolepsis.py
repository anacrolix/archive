#!/usr/bin/python

import pdb
import sys
import Tkinter
sys.path.append("source")
from source.classes import MainDialog

root = Tkinter.Tk()
main_dialog = MainDialog(root)
root.mainloop()

print "exited mainloop cleanly."
