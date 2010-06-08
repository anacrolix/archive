class BotDefcon(object):
	def __init__(self):
		self.__constlvl = None
		self.__curlevel = None
	@property
	def level(self):
		return self.__curlevel
	def set(self, level, persist=False):
		self.__curlevel = max(self.__curlevel, level)
		if persist:
			self.__constlvl = max(self.__constlvl, level)
	def clear(self):
		self.__curlevel = self.__constlvl

import collections, pdb, threading, time

import botutil
from level import *

_BeepParams = collections.namedtuple(
		"_BeepParams",
		["interval", "frequency", "duration"])

_DEFAULT_BEEP_PARAMS = {
		ATTEND: _BeepParams(15, 880, 100),
		DANGER: _BeepParams(4, None, None),
		CRITICAL: _BeepParams(2, 220, 400),}

class BeepingBotDefcon(BotDefcon):
	def __init__(self):
		BotDefcon.__init__(self)
		self.lstbeptk = None
		self.lstbplvl = None
		self.condvar = threading.Condition(threading.Lock())
		self.beepthrd = threading.Thread(target=self.run)
		self.beepthrd.daemon = True
		self.beepthrd.start()
	def set(self, *pargs, **kwargs):
		with self.condvar:
			BotDefcon.set(self, *pargs, **kwargs)
			self.condvar.notify()
	def clear(self, *pargs, **kwargs):
		with self.condvar:
			BotDefcon.clear(self)
	def run(self):
		with self.condvar:
			while True:
				try:
					beepprms = _DEFAULT_BEEP_PARAMS[self.level]
				except KeyError:
					self.condvar.wait()
				else:
					nextbeep = self.lstbeptk
					if nextbeep is not None:
						nextbeep += beepprms.interval
					curtime = time.time()
					if curtime >= nextbeep or self.level > self.lstbplvl:
						self.lstbplvl = self.level
						self.condvar.release()
						assert botutil.beep(
								duration=beepprms.duration,
								frequency=beepprms.frequency,
							).wait() == 0
						self.condvar.acquire()
						self.lstbeptk = time.time()
					else:
						self.condvar.wait(nextbeep - curtime)
