#!/usr/bin/env python

import PIL.Image
import Tix

root = Tix.Tk()

listbox = Tix.TList(root)
listbox.pack()

listbox.insert(Tix.END, text="hi")

balloon = Tix.Balloon(root)
balloon.bind(listbox, msg="yoyo ;D")

#a = root.getimage("../1240838489448.jpg")
#a = Tix.PhotoImage(PIL.Image.open("../1240838489448.jpg"))
#listbox.insert(Tix.END, itemtype="image", image=a)

root.mainloop()
