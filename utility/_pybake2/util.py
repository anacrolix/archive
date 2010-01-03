import os
from os import path
import pdb
import re

def regex_glob(basepath, regex):
    reobj = re.compile(regex)
    for root, dirs, files in os.walk(basepath):
        for f in files:
            p = path.join(root, f)
            if reobj.search(p):
                yield p

def find_sources(basedir, extensions, ignoreDirs=None):
    if ignoreDirs == None:
	ignoreDirs = []
    ignoreDirs += [".svn", ".hg"]
    for root, dirs, files in os.walk(basedir):
	for f in files:
	    for e in extensions:
		if f.endswith(e):
		    yield path.join(root, f)
	for d in dirs[:]:
	    if d in ignoreDirs:
		dirs.remove(d)

def library_config(cmdstr):
    import subprocess
    child = subprocess.Popen(cmdstr, shell=True, stdout=subprocess.PIPE)
    return child.communicate()[0].split()

def parse_make_rule(rule):
    import re
    retval = rule
    # concatenate lines
    retval = retval.replace("\\\n", "")
    # break into targets: depends
    targs, deps = retval.split(":", 1)
    # split allowing for whitespace escapes
    targs, deps = [ filter(None, re.split(r"(?<!\\)\s", x)) for x in [targs, deps] ]
    #pdb.set_trace()
    return targs, deps
