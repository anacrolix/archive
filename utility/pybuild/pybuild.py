import os
import re
import shutil
import stat
import subprocess
import sys

from terminfo import TermInfo
import globals

class Variable:
    def __init__(self, args, shell=False):
        self.args = args
        self.shell = shell
    def __call__(self, input=None):
        if self.shell and not isinstance(self.args, str):
            args = subprocess.list2cmdline(self.args)
        else:
            args = self.args
        #if verbose: print args
        child = subprocess.Popen(args, shell=self.shell, stdout=subprocess.PIPE)
        return child.communicate(input)[0].strip("\n ")
    def __str__(self):
        return self()

class BuildStep:
    # command is a callable that takes ([targets], [dependents]), eg lambda ts, ds
    def __init__(self, command, shell=True):
        self.command = command
        self.shell = shell
    def __call__(self, targets, dependents):
        ti = TermInfo()
        args = self.command(targets, dependents)
        if self.shell: args = subprocess.list2cmdline(args)
        if globals.verbose:
            sys.stdout.write(ti.FG_BLUE)
            print args
        # find a way to print the shell input
        sys.stdout.write(ti.NORMAL)
        sys.stdout.flush() # lol flush the termcap str
        subprocess.check_call(args, shell=self.shell)
        return True

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
            # windows having a mad gay about this?
            #SEP = "\n" + 8 * " "
            #print SEP.join(outputs)
            if len(outputs) > 1:
                print
                for a in outputs:
                    print "\t%s%s" % (target, a)
            else:
                assert outputs[0] == curtarg
                print target + outputs[0]
            assert buildstep(outputs, depends) == True
            if is_target_outdated(curtarg, *depends):
                raise Exception("Target file not produced", curtarg)
            else:
                print current + "Updated:", target + curtarg
        else:
            print current + "Current:", target + curtarg

class Relationship:
    # command must be a buildstep
    def __init__(self, outputs, inputs, command):
        for a in outputs:
            self.relationships()[a] = self
        self.outputs = outputs
        self.inputs = inputs
        self.command = command
    def relationships(self):
        return globals.relationships # this is global :)
    def update(self, targets):
        update(self.outputs, self.inputs, self.command, targets=targets)
    def update_all(self):
        self.update(self.outputs)

class PatternRule:
    # command must be a buildstep
    def __init__(self, pattern, command, depgen):
        self.pattern = pattern
        self.command = command
        self.depgen = depgen
        globals.pattern_rules.append(self)
    # return True if this rule can build the target
    def update(self, target):
        if re.match(self.pattern, target):
            outputs, inputs = self.depgen(target)
            update(outputs, inputs, self.command, targets=[target])
            return True
        else:
            #print self.pattern
            #print target
            return False

#def clean():
    #print "Cleaning all targets"
    #for target in relationships.iterkeys():
        #print "Archiving", target
        #shutil.move(target, "." + target + "~")

#if __name__ == "__main__":
    #print "I R HOOK U"

#def main():
    ## parse args here...
    #pass
