import errno, os, pdb, threading, subprocess, sys
from os import path
from constant import *

class FatalThread(threading.Thread):
    def __init__(self, *args, **kwargs):
	threading.Thread.__init__(self, *args, **kwargs)
	assert not hasattr(self, "unhandled")
	self.unhandled = False
    def run(self):
	try:
	    threading.Thread.run(self)
	except:
	    self.unhandled = True
	    raise

class ThreadPool(object):
    def __init__(self):
	object.__init__(self)
	self.__threads = []
    def add_thread(self, *args, **kwargs):
	self.__threads.append(FatalThread(*args, **kwargs))
	self.__threads[-1].start()
    def join_all(self):
	for t in self.__threads:
	    t.join()
	    if t.unhandled:
		sys.exit("wees & poos")
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
    def claim_update(self, outputs):
	with self.__lock:
	    if set(outputs) <= self.__updating | self.__updated:
		return False
	    else:
		assert self.__updating.isdisjoint(outputs)
		self.__updating.update(outputs)
		return True
    def updated(self, outputs):
	with self.__lock:
	    assert outputs <= self.__updating
	    self.__updating -= outputs
	    self.__updated |= outputs
	    self.__condition.notify_all()
    def wait_updated(self, deps):
	with self.__condition:
	    while not deps <= self.__updated:
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
    with _printLock:
	import termclr
	with termclr.set_color(color):
	    print sep.join(text).rstrip()

class Recipe(object):
    def set_configs(self, *configs):
	self._configs = configs
    def add_project(self, project):
	self._projects.add(project)
    def __init__(self, bakefpath):
	# projects are ditched to generate phonies and rules
	self._projects = set([])
	self._phonies = {}
	self._rules = {}
	self._guard = UpdateGuard()
	self._jobchoke = threading.BoundedSemaphore(4)
	self._bakefpath = bakefpath
#def add_rule(outputs, inputs, commands):
    #rule = (set(outputs), set(inputs), commands)
    #for index, seq in enumerate([outputs, inputs, commands]):
	#assert len(rule[index]) == len(seq), str(seq) + str(rule[index]) + str(index)
    #for o in outputs:
        #assert not o in __targets
        #__targets[o] = (set(outputs), set(inputs), commands)

#def add_rules(rules):
    #for r in rules:
	#add_rule(*r)
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
    def update(self, target):
	outputs, inputs, commands = self._rules[target]
	if not self._guard.claim_update(outputs):
	    return
	tp = ThreadPool()
	for i in inputs:
	    if i in self._rules:
		tp.add_thread(target=self.update, name=i, args=[i])
	tp.join_all()
	self._guard.wait_updated(set(inputs).intersection(self._rules.keys()))
	if not is_outdated(target, inputs | set([self._bakefpath])):
	    self._guard.updated(set([target]))
	    return
	with self._jobchoke:
	    for o in outputs:
		make_file_path(o)
	    pb_print(", ".join(outputs), color=TARGET)
	    for c in commands:
		c()
	for o in outputs:
	    assert not is_outdated(o, inputs)
	self._guard.updated(outputs)
    def update_all(self):
	tp = ThreadPool()
	for t in self._rules:
	    tp.add_thread(target=self.update, args=[t])
	tp.join_all()
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
