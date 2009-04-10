import optparse
import os
import stat
import sys
import types

import classes
import constants
import globals
from terminfo import TermInfo

def is_target_outdated(target, *dependencies):
    try:
        targ_mtime = os.stat(target)[stat.ST_MTIME]
    except OSError, e:
        assert e.errno == 2 # only file missing is ok
        return True
    for dep in dependencies:
        # this should never fail, as the dep should exist by the time this function is called
        dep_mtime = os.stat(dep)[stat.ST_MTIME]
        if dep_mtime > targ_mtime:
            return True
    else:
        return False

def find_rule(target):
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
                raise Exception("No rule to generate file", dep)
            else:
                #print current + "Provided:", target + dep
                pass

    # for each of the targets, check they're up to date
    # and execute the buildstep if they're not
    for curtarg in targets or outputs:
        if targets != None: assert curtarg in targets
        else: assert curtarg in outputs

        if is_target_outdated(curtarg, *depends):
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
        else:
            print current + "Current:", target + curtarg

# set foreground color to red before print exceptions
# params could be handled with *param...
def neardeath(type, value, traceback):
    display = TermInfo()
    display.immediate(display.FG_RED)
    sys.__excepthook__(type, value, traceback)

def initialize():
    sys.excepthook = neardeath

## names are for lols

def pybake_main():
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
