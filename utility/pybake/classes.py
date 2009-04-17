import errno
import os
import re
import subprocess
import sys

import globals
import functions
from functions import update
from terminfo import TermInfo

# this class is only ever used like a function...
class SystemTask:
    def __init__(self, args):
        self.args = args
    def __call__(self, stdout=False):
        display = TermInfo()
        kwargs = {}
        if stdout: kwargs["stdout"] = subprocess.PIPE
        print display.FG_BLUE + subprocess.list2cmdline(self.args)
        display.immediate(display.NORMAL)
        try:
            child = subprocess.Popen(self.args, **kwargs)
        except OSError, e:
            if e.errno == errno.ENOENT:
                raise Exception(e[1], kwargs.get("executable") or self.args[0])
            else:
                raise
        output = child.communicate()[0]
        assert output != None if stdout else output == None
        if child.returncode:
            display.immediate(display.FG_RED)
            sys.exit("System task returned non-zero exit status %d" % child.returncode)
        return output

class LibraryConfig:
    def __init__(self, exefile, posargs=None):
        self.exefile = exefile
        self.posargs = posargs or []
    def __call__(self, options):
        return SystemTask([self.exefile] + options + self.posargs)(stdout=True).split()

#class BackTicks:
    #def __init__(self, args):
        #self.args = args

#class PkgConfig:
    #def __init__(self, *packages):
        #self.packages = packages

class Command:
    pass

class Configure(Command):
    def __init__(self, symbols, prefix="@", suffix="@"):
        assert isinstance(symbols, dict)
        self.symbols = symbols
        self.prefix = prefix
        self.suffix = suffix
    def __call__(self, targets, depends):
        assert len(targets) == 1
        assert len(depends) == 1
        confed = open(depends[0]).read()
        substitutions = symbolsused = 0
        for key, value in self.symbols.iteritems():
            confed, subcount = re.subn(re.escape(self.prefix + key + self.suffix), value, confed)
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
    def __init__(self, argsgen):
        self.argsgen = argsgen
    def __call__(self, outputs, inputs):
        args = self.argsgen(outputs, inputs)
        SystemTask(args)()
        return True

class Install(Command):
    def __init__(self, prefix=None):
        self.taskargs = []
        self.prefix = prefix
    def file(self, file, dir, executable=False, mode=None):
        assert not executable or mode is None
        args = (file, dir, {})
        if executable: args[2]["mode"] = 755
        elif mode: args[2]["mode"] = mode
        self.taskargs.append(args)
    def prereqs(self):
        return [x[0] for x in self.taskargs]
    def __call__(self, prefix=None):
        for task in self.taskargs:
            dir = os.path.join(prefix or self.prefix, task[1])
            if not os.path.isdir(dir):
                functions.install([dir], make_dirs=True)
            functions.install([task[0], dir], **task[2])

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
    #def get_inputs(self, targets):
    #    raise NotImplementedError

class ExplicitRule(Rule):
    phony = False
    # command must be a buildstep
    def __init__(self, outputs, inputs, command):
        assert isinstance(command, Command)
        for a in outputs:
            #if globals.explicit_rules.has_key(a):
               # raise RuleTargetError(a)
            globals.explicit_rules[a] = self
        self.outputs = outputs
        self.inputs = inputs
        self.command = command
    def update(self, targets=None):
        update(self.outputs, self.inputs, self.command, targets=targets)
    #@staticmethod
    #def update_all():
        #"""Update all the registered relationships"""
        #update([], globals.explicit_rules.keys(), None)
    def get_inputs(self, target):
        return self.inputs

class ImplicitRule(Rule):
    # command must be a buildstep
    def __init__(self, pattern, command, depgen):
        assert isinstance(command, Command)
        self.pattern = pattern
        self.command = command
        self.depgen = depgen
        globals.implicit_rules.append(self)
    # return True if this rule can build the target
    def match(self, target):
        return re.match(self.pattern, target)
    def update(self, targets):
        assert len(targets) == 1
        outputs, inputs = self.depgen(targets[0])
        update(outputs, inputs, self.command, targets=targets)
    def get_inputs(self, target):
        #assert len(target) == 1
        return self.depgen(target)[1]

class PhonyRule(ExplicitRule):
    phony = True
    def __init__(self, target, action, prereqs=None):
        globals.explicit_rules[target] = self
        self.target = target
        self.action = action
        self.prereqs = prereqs
    def update(self, targets):
        assert targets == [self.target]
        if self.prereqs is not None: update([], self.prereqs, None)
        return self.action()
