from functions import update
from terminfo import TermInfo
import globals

import re
import subprocess
import sys

class SystemTask:
    def __init__(self, args):
        self.args = args
    def __call__(self, stdout=False):
        display = TermInfo()
        kwargs = {}
        if stdout: kwargs["stdout"] = subprocess.PIPE
        print display.FG_BLUE + subprocess.list2cmdline(self.args)
        display.immediate(display.NORMAL)
        child = subprocess.Popen(self.args, **kwargs)
        output = child.communicate()[0]
        assert output != None if stdout else output == None
        if child.returncode:
            display.immediate(display.FG_RED)
            sys.exit("System task returned non-zero exit status %d" % child.returncode)
        return output

class BackTicks:
    def __init__(self, args):
        self.args = args


#class PkgConfig:
    #def __init__(self, *packages):
        #self.packages = packages

class Command:
    def __call__(self, outputs, inputs):
        raise NotImplementedError

class Configure(Command):
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

class BuildStep(Command):
    # command is a callable that takes ([targets], [dependents]), eg lambda ts, ds
    def __init__(self, command, shell=True):
        self.command = command
        self.shell = shell
    def __call__(self, targets, dependents):
        ti = TermInfo()
        args = self.command(targets, dependents)
        SystemTask(args)()
        return True

class RuleTargetError(Exception):
    def __init__(self, target):
        self.target = target
    def __str__(self):
        return "Explicit rule for target '%s' already exists" % self.target

class Rule:
    def __init__(self, commands):
        raise NotImplementedError
    def update(self, targets):
        raise NotImplementedError

class ExplicitRule(Rule):
    # command must be a buildstep
    def __init__(self, outputs, inputs, command):
        assert isinstance(command, Command)
        for a in outputs:
            if globals.explicit_rules.has_key(a):
                raise RuleTargetError(a)
            globals.explicit_rules[a] = self
        self.outputs = outputs
        self.inputs = inputs
        self.command = command
    def update(self, targets=None):
        update(self.outputs, self.inputs, self.command, targets=targets)
    @staticmethod
    def update_all():
        """Update all the registered relationships"""
        update([], globals.explicit_rules.keys(), None)

class ImplicitRule(Rule):
    # command must be a buildstep
    def __init__(self, pattern, command, depgen):
        assert isinstance(command, Command)
        self.pattern = pattern
        self.command = command
        self.depgen = depgen
        globals.implicit_rules.append(self)
    # return True if this rule can build the target
    def update(self, target):
        if re.match(self.pattern, target):
            outputs, inputs = self.depgen(target)
            update(outputs, inputs, self.command, targets=[target])
            return True
        else:
            return False
