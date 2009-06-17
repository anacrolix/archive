#!/usr/bin/python

import tkinter

def vcmd(*args):
    print("vcmd(", args, ")")
    #print spinbox.cget("validate")
    print(text.get())
    return True

root = tkinter.Tk()
text = tkinter.StringVar()
text.trace('w', vcmd)
spinbox = tkinter.Scale(root, from_= 5, to=150, command=vcmd, orient=tkinter.HORIZONTAL)
spinbox.pack(fill=tkinter.X)
spinbox.config(label="hi")
#spinbox.config(validate="key")
#spinbox.config(validatecommand=vcmd)
root.mainloop()
