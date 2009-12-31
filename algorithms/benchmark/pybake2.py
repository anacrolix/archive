#!/usr/bin/env python

recipeGlobals = dict(globals())

import optparse
import pdb
import sys

parser = optparse.OptionParser()
parser.set_defaults(file="bake", config="default", debug=False)
parser.add_option("--config")
parser.add_option("--file", "-f")
parser.add_option("--debug", "-d", action="store_true", dest="debug")
opts, args = parser.parse_args()

def pm_exchook(type, value, tb):
    import traceback, pdb
    #oldExceptHook(type, value, tb)
    traceback.print_exception(type, value, tb)
    pdb.post_mortem(tb)

if opts.debug:
    oldExceptHook = sys.excepthook
    sys.excepthook = pm_exchook

import core
import project
import util

recipe = core.Recipe(opts.file)

def expose(symbol, name=None):
    if name == None: name = symbol.__name__
    assert not name in recipeGlobals
    recipeGlobals[name] = symbol

def expose_symbol(symbol, source):
    expose(getattr(source, symbol), symbol)

@expose
def is_config(config):
    assert config in recipe._configs
    return config == opts.config

for a in ["set_configs"]:
    expose_symbol(a, recipe)

def project_wrapper(projectClass):
    def create_project(name):
        a = projectClass(name, opts.config)
        recipe.add_project(a)
        return a
    return create_project

recipeGlobals["CxxProject"] = project_wrapper(project.CxxProject)

expose_symbol("regex_glob", util)
expose_symbol("library_config", util)

#recipeGlobals["CONFIG"] = opts.config
execfile(opts.file, recipeGlobals)

recipe.generate_projects()

def excepthook(*args):
    with _printLock:
        oldExcepthook(*args)
oldExcepthook = sys.excepthook
sys.excepthook = excepthook

#__jobSemaphore = threading.BoundedSemaphore(4)
#_printLock = threading.Lock()

if len(args) == 0:
    recipe.update_all()
else:
    if "clean" in args:
	args.remove("clean")
	recipe.clean()
    for a in args:
	for t in __phonies[a]:
	    update(t)
