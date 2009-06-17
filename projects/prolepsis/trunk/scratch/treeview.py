import tkinter
from tkinter import ttk

def event(*args):
    print(args)
    print(dir(args[0]))

root = tkinter.Tk()
tv = ttk.Treeview(root)
tv.pack()
dc_iid = tv.insert("", tkinter.END, text="Del Chaos", open=True)
tv.insert(dc_iid, tkinter.END, text="Eruanno", values=["121", "EK"], tags=["ally", "char"])
print(tv.cget("displaycolumns"))
tv.config(columns=["level", "vocation"])
tv.config(displaycolumns=[1, 0])
tv.heading("level", text="Level")
tv.heading("vocation", text="Vocation")
tv.heading("#0", text="Name")
tv.config(selectmode=tkinter.NONE)
tv.tag_configure("ally", background="green")
tv.tag_bind("char", "<Double-Button-1>", event)

root.mainloop()
