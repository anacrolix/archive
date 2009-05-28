#!/usr/bin/python

import Tkinter

def vcmd(*args):
    print "vcmd(", args, ")"
    #print spinbox.cget("validate")
    print text.get()
    return True

root = Tkinter.Tk()
text = Tkinter.StringVar()
text.trace('w', vcmd)
spinbox = Tkinter.Scale(root, from_= 5, to=150, command=vcmd, orient=Tkinter.HORIZONTAL)
spinbox.pack(fill=Tkinter.X)
spinbox.config(label="hi")
#spinbox.config(validate="key")
#spinbox.config(validatecommand=vcmd)
root.mainloop()
