import errno, os, pdb
import Queue as queue
import threading
import traceback
import subprocess, sys
from os import path
from constant import *

class FatalThread(threading.Thread):
    def __init__(self, errflag, *args, **kwargs):
	threading.Thread.__init__(self, *args, **kwargs)
	self.errflag = errflag
    def run(self):
	try:
	    threading.Thread.run(self)
	except PybakeStop as e:
	    #if not self.errflag:
	    self.errflag.set()
	    pb_print(str(e), color=ERROR)
	except:
	    self.errflag.set()
	    with _printLock:
		sys.stderr.write(
			"Exception in thread %s:\n%s\n" %
			(self.name, traceback.format_exc()))

# might be necessary to let threads finish gracefully and then exit?
class ThreadPool(object):
    def __init__(self, errflag):
	object.__init__(self)
	self.__threads = []
	self.errflag = errflag
    def add_thread(self, *args, **kwargs):
	if not self.errflag:
	    #print "starting thread", kwargs["name"]
	    self.__threads.append(FatalThread(self.errflag, *args, **kwargs))
	    self.__threads[-1].start()
    def join_all(self):
	for t in self.__threads:
	    #print "joining thread", t.name
	    t.join()
    def __enter__(self):
	pass
    def __exit__(self, *exc_info):
	self.join_all()

def make_file_path(filepath):
    try:
	os.makedirs(path.split(filepath)[0])
    except OSError as e:
	if e.errno not in [errno.EEXIST, errno.ENOENT]:
	    raise

class UpdateGuard(object):
    def __init__(self):
	self.__lock = threading.Lock()
	self.__updating = set()
	self.__updated = set()
	self.__condition = threading.Condition(self.__lock)
	self.__passall = False
    def claim_update(self, outputs):
	with self.__lock:
	    if set(outputs) <= self.__updating:
		return False
	    elif outputs <= self.__updated:
		return False
	    else:
		assert self.__updating.isdisjoint(outputs)
		self.__updating.update(outputs)
		return True
    def updated(self, outputs):
	with self.__lock:
	    if not outputs <= self.__updating:
		pdb.set_trace()
	    self.__updating -= outputs
	    self.__updated |= outputs
	    self.__condition.notify_all()
    def notify_error(self):
	with self.__lock:
	    self.__passall = True
	    self.__condition.notify_all()
    def wait_updated(self, deps):
	with self.__condition:
	    while not deps <= self.__updated and self.__passall == False:
		self.__condition.wait()

class PybakeError(Exception):
    pass

class PybakeStop(Exception):
    pass

def is_outdated(target, deps):
    #print "is_outdated(", target, deps, ")"
    try:
        targetMtime = os.stat(target).st_mtime
    except OSError as e:
        if e.errno == errno.ENOENT:
            return True
        else:
            raise
    for d in deps:
        if os.stat(d).st_mtime > targetMtime:
            return True
    else:
        return False

_printLock = threading.Lock()

def pb_print(*text, **kwargs):
    sep = kwargs.get("sep", " ")
    color = kwargs.get("color", None)
    text = sep.join(text)#.rstrip()
    with _printLock:
	if color == None:
	    print text
	else:
	    import termclr
	    with termclr.set_color(color):
		print text

class ErrorFlag(object):
    def __init__(self, *notifiees):
	self.__event = threading.Event()
	self.notifiees = notifiees
    def __nonzero__(self):
	return self.__event.is_set()
    def set(self):
	print "Error flag set"
	self.__event.set()
	for n in self.notifiees:
	    n.notify_error()

class Recipe(object):
    def set_configs(self, *configs):
	self._configs = configs
	if self.curconf == None:
	    default = self._configs[0]
	    pb_print("Defaulting to config %s" % default)
	    self.curconf = default
	elif not self.curconf in self._configs:
	    raise PybakeStop("%s is not in the declared configs %s" % (repr(self.curconf), self._configs))
    def get_config(self):
	return self.curconf
    def add_project(self, project):
	self._projects.add(project)
    def __init__(self, bakefpath, curconf):
	# projects are ditched to generate phonies and rules
	self._projects = set([])
	self._phonies = {}
	self._rules = {}
	self._guard = UpdateGuard()
	self._jobchoke = threading.BoundedSemaphore(4)
	self._bakefpath = bakefpath
	self.curconf = curconf
	self.errflag = ErrorFlag(self._guard)
    def add_rules(self, *rules):
	for r in rules:
	    assert len(r) == 3
	    for a in zip(r[0:2], map(set, r[0:2])):
		assert len(a[0]) == len(a[1])
	    #assert set(tuple(r[0])).isdisjoint(set(self._rules.keys()))
	    for t in r[0]:
		#print t
		self._rules[t] = (set(r[0]), set(r[1]), r[2])
    def generate_projects(self):
	for p in self._projects:
	    assert not p.name in self._phonies
	    topTargets, rules = p.generate_rules()
	    self._phonies[p.name] = topTargets
	    self.add_rules(*rules)
	del self._projects
    def build(self, projectName):
	self.update(self._phonies[projectName])
    def update_seq(self, targets):
	tp = ThreadPool(self.errflag)
	with tp:
	    for t in targets:
		if self.errflag:
		    return
		tp.add_thread(target=self.update, name=t, args=[t])
    def update(self, target):
	outputs, inputs, commands = self._rules[target]
	#with _printLock:
	#    print outputs
	if self.errflag:
	    return
	if not self._guard.claim_update(outputs):
	    return
	self.update_seq([i for i in inputs if i in self._rules])
	if self.errflag:
	    return
	self._guard.wait_updated(set(inputs).intersection(self._rules.keys()))
	if self.errflag:
	    return
	for o in outputs:
	    if is_outdated(o, inputs):
		break
	else:
	    self._guard.updated(outputs)
	    return
	#if not is_outdated(target, inputs):# | set([self._bakefpath])):
	    #self._guard.updated(set([target]))
	#    return
	with self._jobchoke:
	    if self.errflag:
		return
	    for o in outputs:
		make_file_path(o)
	    pb_print(", ".join(outputs), color=TARGET)
	    if self.errflag:
		return
	    for c in commands:
		c()
	    if self.errflag:
		return
	for o in outputs:
	    assert not is_outdated(o, inputs)
	self._guard.updated(outputs)
    def update_all(self):
	self.update_seq(self._rules.keys())
    def clean(self):
	rmCount = 0
	for t in self._rules:
	    try:
		os.unlink(t)
	    except OSError as e:
		if e.errno not in [errno.ENOENT]:
		    raise
	    else:
		print "unlinked", t
		rmCount += 1
	print rmCount, "files removed"
