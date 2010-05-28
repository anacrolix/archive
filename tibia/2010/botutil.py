from __future__ import division
import collections, contextlib, subprocess, time, traceback

beepproc = None
def beep(frequency=None, duration=None):
	global beepproc
	if beepproc is not None:
		if beepproc.returncode is None:
			beepproc.wait()
	args = ["beep"]
	if frequency is not None:
		args += ["-f", str(frequency)]
	if duration is not None:
		args += ["-l", str(duration)]
	beepproc = subprocess.Popen(args)

def wait_for_next_tick(curtick=None):
	if curtick is None:
		curtick = int(time.time())
	slptime = curtick + 1 - time.time()
	if slptime > 0:
		time.sleep(slptime)
	newtick = int(time.time())
	assert newtick == curtick + 1
	return newtick


def get_window_id(wintitle):
	return int(subprocess.Popen(
			["./getxwin", wintitle],
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

PlayerNotifyLevel = collections.namedtuple(
		"PlayerNotifyLevel",
		["numeric", "interval", "frequency", "duration"])

class PlayerNotifier(object):
	INFO = None
	ATTEND = PlayerNotifyLevel(1, 15, 2*440, 200/2)
	DANGER = PlayerNotifyLevel(2, 4, None, None)
	CRITICAL = PlayerNotifyLevel(3, 2, 440/2, 200*2)
	def __init__(self, client):
		self.client = client
		self.persist = False
		self.level = None
		self.lastbeep = 0
	def notify(self, level, fmtstr, *pargs, **kwargs):
		print "{time}:{charname}:{message}".format(
				time=time.strftime("%a %H:%M:%S"),
				charname=self.client.player_entity().name,
				message=(fmtstr % pargs))
		self.persist = any((self.persist, kwargs.pop("persist", False)))
		if level > self.level:
			if self.persist:
				self.lastbeep = 0
			self.level = level
	def info(self, *pargs, **kwargs):
		return self.notify(self.INFO, *pargs, **kwargs)
	def attend(self, *pargs, **kwargs):
		return self.notify(self.ATTEND, *pargs, **kwargs)
	def danger(self, *pargs, **kwargs):
		kwargs.setdefault("persist", True)
		return self.notify(self.DANGER, *pargs, **kwargs)
	def critical(self, *pargs, **kwargs):
		kwargs.setdefault("persist", True)
		return self.notify(self.CRITICAL, *pargs, **kwargs)
	def do_stuff(self):
		if self.level is not None:
			curtime = int(time.time())
			assert curtime > self.lastbeep
			if curtime >= self.lastbeep + self.level.interval:
				beep(frequency=self.level.frequency, duration=self.level.duration)
				self.lastbeep = curtime
		if not self.persist:
			self.level = None
assert PlayerNotifier.INFO < PlayerNotifier.ATTEND \
		< PlayerNotifier.DANGER < PlayerNotifier.CRITICAL
