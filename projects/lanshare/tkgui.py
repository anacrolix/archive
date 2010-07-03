from Tkinter import *
import tkFileDialog

class LanshareGui(object):

	def __call__(self):
		self.tkroot.mainloop()

	def gui_idle_handler(self):
		# the gui is polled 50 times a second
		self.server.serve_forever(use_poll=True, count=1, timeout=0.02)
		self.tkroot.after_idle(self.gui_idle_handler)

	def new_share(self):
		shrroot = tkFileDialog.askdirectory()
		print shrroot

	def __init__(self, title, config, server):
		tkroot = Tk()
		#tkroot.title(title)
		tkroot = Window(tkroot)

		sharefrm = LabelFrame(tkroot, text="Shares")
		sharefrm.pack(fill=BOTH, expand=True)
		sharelb = Listbox(sharefrm, width=0)
		for virtdir, shrroot in config.shares.iteritems():
			sharelb.insert(END, "{0}: {1}".format(virtdir, shrroot))
		sharelb.pack(fill=BOTH, side=LEFT, expand=True)
		sharebtns = Frame(sharefrm)
		sharebtns.pack(side=LEFT, fill=Y)
		newshbtn = Button(sharebtns, text="New", command=self.new_share)
		newshbtn.pack(fill=X)
		#newshbtn.bind("<Button-1>", self.new_share)
		remshbtn = Button(sharebtns, text="Remove")
		remshbtn.pack(fill=X)

		peerfrm = LabelFrame(tkroot, text="Peers")
		peerfrm.pack(fill=BOTH, expand=True)
		peerlb = Listbox(peerfrm, width=0)
		peerlb.pack(side=LEFT, fill=BOTH, expand=True)
		peerbtns = Frame(peerfrm)
		peerbtns.pack(fill=Y, side=LEFT)
		browzbtn = Button(peerbtns, text="Browse")
		browzbtn.pack()
		refpeerbtn = Button(peerbtns, text="Refresh")
		refpeerbtn.pack()

		closebtn = Button(tkroot, text="Shutdown", command=tkroot.quit)
		closebtn.pack()

		tkroot.update_idletasks()
		tkroot.after_idle(self.gui_idle_handler)

		self.tkroot = tkroot
		self.server = server

def start_gui(*args):
	LanshareGui(*args)()
