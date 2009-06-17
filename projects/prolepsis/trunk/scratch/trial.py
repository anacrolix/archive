#!/usr/bin/env python

import PIL.Image
import tkinter.tix

root = tkinter.tix.Tk()

listbox = tkinter.tix.TList(root)
listbox.pack()

listbox.insert(tkinter.tix.END, text="hi")

balloon = tkinter.tix.Balloon(root)
balloon.bind(listbox, msg="yoyo ;D")

#a = root.getimage("../1240838489448.jpg")
#a = Tix.PhotoImage(PIL.Image.open("../1240838489448.jpg"))
#listbox.insert(Tix.END, itemtype="image", image=a)

root.mainloop()
