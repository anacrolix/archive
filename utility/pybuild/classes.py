from functions import update
from terminfo import TermInfo
import globals

import re
import subprocess
import sys

class Configure:
    def __init__(self, symbols, prefix="@", suffix="@"):
        self.symbols = symbols
        self.prefix = prefix
        self.suffix = suffix
    def __call__(self, targets, depends):
        assert len(targets) == 1
        assert len(depends) == 1
        confed = open(depends[0]).read()
        substitutions = symbolsused = 0
        for sym in self.symbols:
            confed, subcount = re.subn(re.escape(self.prefix + sym[0] + self.suffix), sym[1], confed)
            substitutions += subcount
            if subcount > 0: symbolsused += 1
        ti = TermInfo()
        print ti.FG_MAGENTA + "Used", symbolsused, "symbols,", substitutions, "substitutions"
        sys.stdout.write(ti.FG_RED)
        sys.stdout.flush()
        open(targets[0], 'wb').write(confed)
        return True

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
    def update(self, targets=None):
        update(self.outputs, self.inputs, self.command, targets=targets)
    @staticmethod
    def update_all():
        """Update all the registered relationships"""
        update([], globals.relationships.keys(), None)

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

