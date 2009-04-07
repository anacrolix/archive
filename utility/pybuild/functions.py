from terminfo import TermInfo
import globals

import os
import stat
import sys

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

    for dep in depends:
        try:
            # try to update via explicit relationships
            globals.relationships[dep].update([dep])
        except KeyError:
            # look for a pattern rule
            for rule in globals.pattern_rules:
                if rule.update(dep):
                    break
            else:
                # no relationship is defined, the file should exist
                # (eg the file is created by moi)
                if not os.path.exists(dep):
                    raise Exception("No rule to generate file", dep)
                else:
                    #print current + "Provided:", target + dep
                    pass

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
