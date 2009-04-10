import os
import stat
import sys

import classes
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

def update(outputs, depends, buildstep, targets=None):
    #print "update(", outputs, depends, buildstep, targets, ")"

    ti = TermInfo() # ~TermInfo will normalize terminal
    current = ti.FG_GREEN
    normal = ti.NORMAL
    outdated = ti.FG_YELLOW
    target = ti.FG_CYAN

    # try to generate via an explicit rule
    # then by an implicit rule
    # lastly assume the file is provided by the user
    for dep in depends:
        try:
            # try to update via explicit relationships
            globals.explicit_rules[dep].update([dep])
        except KeyError:
            # look for a pattern rule
            matched = False
            for rule in globals.implicit_rules:
                if rule.update(dep):
                    assert not matched
                    matched = True
            if not matched:
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

def bake():
    # use optparse eventually...
    classes.ExplicitRule.update_all()

def shipit():
    bake()
