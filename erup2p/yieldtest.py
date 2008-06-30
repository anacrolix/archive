#!/bin/env python

import threading
import wx
import time

event = threading.Event()
event.set()

def call_a(t):
	print "call_a()"
	time.sleep(t)
	event.set()

class Thread(threading.Thread):
	def run(self):
		print "entered Thread.run()"
		for i in range(10):
			event.clear()
			wx.CallAfter(call_a, i)
			event.wait()
			print "fell through event"
		print "leaving Thread.run()"

class WxApp(wx.App):
	def __init__(*args):
		print "WxApp.__init__()"
		wx.App.__init__(*args)
	def OnInit(self):
		print "WxApp.OnInit()"
		self.frame = wx.Frame(None)
		self.frame.Show()
		return True
	def OnExit(self):
		print "WxApp.OnExit()"
	def __del__(self):
		print "WxApp.__del__()"

def main():
	print "entered main()"
	thread = Thread()
	app = WxApp()
	thread.start()
	app.MainLoop()
	print "left MainLoop()"
	print "leaving main()"

main()
