import optparse
import os
import re
import stat
import sys
import types

import classes
import constants
import globals
from terminfo import TermInfo

def is_target_outdated(target, *dependencies):
    """Return True if any of the dependencies, or the build script are newer than the target"""
    try:
        targ_mtime = os.stat(target)[stat.ST_MTIME]
    except OSError, e:
        assert e.errno == 2 # only file missing is ok
        return True
    for dep in dependencies + (sys.argv[0],):
        # this should never fail, as the dep should exist by the time this function is called
        dep_mtime = os.stat(dep)[stat.ST_MTIME]
        if dep_mtime > targ_mtime:
            return True
    else:
        return False

def find_rule(target):
    """Find a build rule for the given target. Searches for an explicit rule, then an implicit rule, asserting that only one implicit rule matches."""
    try:
        retval = globals.explicit_rules[target]
    except KeyError:
        matched = False
        for rule in globals.implicit_rules:
            assert isinstance(rule, classes.ImplicitRule)
            if rule.match(target):
                assert not matched
                matched = True
                retval = rule
        if not matched: retval = None
    assert isinstance(retval, (classes.Rule, types.NoneType))
    return retval

def update(outputs, depends, buildstep, targets=None):
    #print "update(", outputs, depends, buildstep, targets, ")"
    if outputs == None: outputs = ()

    ti = TermInfo() # ~TermInfo will normalize terminal
    current = ti.FG_GREEN
    normal = ti.NORMAL
    outdated = ti.FG_YELLOW
    target = ti.FG_CYAN

    # try to generate via an explicit rule
    # then by an implicit rule
    # lastly assume the file is provided by the user
    for dep in depends:
        rule = find_rule(dep)
        if rule != None:
            rule.update([dep])
        else:
            # no relationship is defined, the file should exist
            # (eg the file is created by moi)
            if not os.path.exists(dep):
                raise Exception("No rule to generate file %s needed for %s" % (repr(dep), outputs))
            else:
                #print current + "Provided:", target + dep
                pass

    # for each of the targets, check they're up to date
    # and execute the buildstep if they're not
    for curtarg in targets or outputs:
        if targets != None: assert curtarg in targets
        else: assert curtarg in outputs

        if is_target_outdated(curtarg, *depends):
            assert curtarg not in globals.updated
            print outdated + "Regenerating:",
            if len(outputs) > 1:
                print
                for a in outputs:
                    print "\t%s%s" % (target, a)
            else:
                assert outputs[0] == curtarg
                print target + outputs[0] + ti.FG_RED
                sys.stdout.flush()
            assert buildstep(outputs, depends) == True
            if is_target_outdated(curtarg, *depends):
                raise Exception("Target file not produced", curtarg)
            else:
                print current + "Updated:", target + curtarg
                globals.updated.add(curtarg)
        else:
            if curtarg not in globals.updated:
                print current + "Current:", target + curtarg
                globals.updated.add(curtarg)

def neardeath(type, value, traceback):
    """This is an excepthook that turns the display red prior to printing an exception"""
    display = TermInfo()
    display.immediate(display.FG_RED)
    sys.__excepthook__(type, value, traceback)

def initialize():
    """Called when pybake is imported. Installs an excepthook"""
    sys.excepthook = neardeath

def pybake_main():
    """Function to be called at the end of the user build script. This kicks off option parsing, and target building"""
    if find_rule("clean") is None:
        classes.PhonyRule("clean", clean_targets)

    parser = optparse.OptionParser(prog=constants.PROGRAM, version=constants.VERSION)
    parser.disable_interspersed_args()
    opts, args = parser.parse_args()
    #print opts
    if len(args) == 0:
        # default "build all targets" kinda thing
        #classes.ExplicitRule.update_all()
        update(None, [ x[0] for x in globals.explicit_rules.iteritems() if not x[1].phony ], None)
    else:
        update([], args, None)

def clean_targets(targets=None):
    display = TermInfo()
    if targets == None:
        targets = [ x[0] for x in globals.explicit_rules.iteritems() if not x[1].phony ]
    for t in targets:
        rule = find_rule(t)
        if rule != None:
            clean_targets(rule.get_inputs(t))
            try:
                os.remove(t)
                print display.FG_RED + "Removing:", display.FG_CYAN + t
            except OSError, e:
                assert e.errno == 2
                print display.FG_YELLOW + "Missing:", display.FG_CYAN + t

# i want *components here but it won't work? read something about a proposal for this in py3
def install(components, mode=None, target_not_dir=False, make_dirs=False, dir_first=False):
    """Wraps the GNU coreutils install command"""
    args = ["install"]
    if mode != None: args.append("-m" + str(mode))
    if target_not_dir: args.append("-T")
    if make_dirs: args.append("-d")
    if dir_first: args.append("-t")
    args.extend(components)
    classes.SystemTask(args)()

def which(program):
    import os
    for path in os.environ["PATH"].split(os.pathsep):
        exePath = os.path.join(path, program)
        if os.path.exists(exePath) and os.access(exePath, os.X_OK):
            return exePath
    else:
        return None

def build_tool(lang):
    if lang in ["c", "cxx", "c++"]:
        defaultCompilerOrder = {
                "nt": ["msvc", "gcc"],
                "posix": ["gcc"],
            }[os.name]
        for compilerName in defaultCompilerOrder:
            compiler = __import__(".lang." + compilerName)
            if compiler.is_present():
                return compiler
