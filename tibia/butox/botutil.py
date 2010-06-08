from __future__ import division

import collections, contextlib, subprocess, sys, time, traceback

import defcon, pytibia
from defcon.level import *

def cutil_path(exename):
	from os.path import join
	return join("cutil", exename)

def send_key_press(self, windowid, keystr):
	args = [cutil_path("xsendkey"), "-window", hex(windowid), keystr]
	subprocess.check_call(args)

def beep(frequency=None, duration=None):
	args = ["beep"]
	if frequency is not None:
		args += ["-f", str(frequency)]
	if duration is not None:
		args += ["-l", str(duration)]
	return subprocess.Popen(args)

def wait_for_next_tick(curtick=None):
	if curtick is None:
		curtick = int(time.time())
	slptime = curtick + 1 - time.time()
	if slptime > 0:
		time.sleep(slptime)
	newtick = int(time.time())
	assert newtick == curtick + 1
	return newtick

def _notify(level, fmtstr, *pargs, **kwargs):
	#setbeep = kwargs.pop("setbeep", True)
	#persist = kwargs.pop("persist", setbeep and level >= DANGER)
	# persist cannot be True if setbeep is False
	#assert not persist or setbeep
	name = kwargs.pop("name", "root")
	#assert len(kwargs) == 0, "Unused parameters: {0}".format(kwargs)
	print >>sys.stderr, "{time}:{name}:{level}:{message}".format(
			time=time.strftime("%a %H:%M:%S"),
			name=name,
			level=level,
			message=(fmtstr % pargs))
	#if setbeep:
		#beeper.set(level, persist=persist)

def get_window_id(wintitle):
	return int(subprocess.Popen(
			[cutil_path("getxwin"), wintitle],
			stdout=subprocess.PIPE
		).communicate()[0], 0)

@contextlib.contextmanager
def beep_catch_all(notifier):
	try:
		yield
	except Exception:
		notifier.critical("Unhandled exception", persist=True)
		traceback.print_exc()
		while True:
			try:
				wait_for_next_tick()
			except KeyboardInterrupt:
				raise SystemExit()
			notifier.do_stuff()

#def _pick_items(srcdict, *keyseq, leave=False):
	#retval = {}
	#for key in keyseq:
		#if key in srcdict:
			#retval[key] = srcdict[key]
			#if not leave:
				#del srcdict[key]
	#return retval

class TibiaBot(object):
	def __init__(self, sklpglvl=INFO, silent=False):
		self.__sklpglvl = sklpglvl
		self.client = pytibia.Client()
		self.__defcon = defcon.BotDefcon() if silent else defcon.BeepingBotDefcon()
		self.__skilprog = [self.client.skill_progress(skillnam) for skillnam in pytibia.SKILL_NAMES]
		assert len(self.__skilprog) == len(pytibia.SKILL_NAMES)
	def start_up(self):
		pass
	def do_stuff(self):
		raise NotImplementedError()
	def notify(self, level, *pargs, **kwargs):
		kwargs.setdefault("persist", level >= DANGER)
		self.__defcon.set(level, **kwargs)
		kwargs.setdefault("name", self.client.player_entity().name)
		return _notify(level, *pargs, **kwargs)
	@property
	def defcon_level(self):
		return self.__defcon.level
	def __main_loop(self):
		while True:
			begstuff = time.time()
			self.__defcon.clear()
			self.__check_skill_progress()
			self.do_stuff()
			stufftim = time.time() - begstuff
			if stufftim >= 0.2:
				self.notify(ATTEND, "Bot main loop consumed %ums", 1000 * stufftim)
			try:
				time.sleep(1.0)
			except KeyboardInterrupt:
				raise SystemExit()
	def __call__(self):
		self.start_up()
		self.notify(INFO, "Bot started up")
		return self.__main_loop()
	def __check_skill_progress(self):
		# check for changes in skill progress
		for skillidx, skillnam in enumerate(pytibia.SKILL_NAMES):
			newprog = self.client.skill_progress(skillnam)
			oldprog = self.__skilprog[skillidx]
			if newprog != oldprog:
				self.notify(
						self.__sklpglvl,
						"Skill %s has %u%% remaining",
						skillnam.upper(),
						100 - newprog)
				self.__skilprog[skillidx] = newprog
