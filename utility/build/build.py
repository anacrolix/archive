import shutil, os, re, stat, subprocess

relationships = {}
pattern_rules = []
verbose = True

class BuildVariable:
    # perhaps we don't need shell?
    def __init__(self, args, shell=False):
        self.args = args
        self.shell = shell
    def __call__(self):
        # args could be mapped to strings here if necessary
        child = subprocess.Popen(self.args, shell=self.shell, stdout=subprocess.PIPE)
        return child.communicate()[0].strip("\n ")
    def __str__(self):
        return self()

class BuildStep:
    # command is a callable that takes ([targets], [dependents]), eg lambda ts, ds
    def __init__(self, command, shell=True):
        self.command = command
        self.shell = shell
    def __call__(self, targets, dependents):
        args = map(lambda x: str(x), self.command(targets, dependents))
        if self.shell: args = [" ".join(args)]
        if verbose: print args[0] if self.shell else args
        # find a way to print the shell input
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

def update(maintarg, targets, depends, buildstep):
    assert maintarg in targets
    if is_target_outdated(maintarg, *depends):
        print "Regenerating:",
        # windows having a mad gay about this?
        #SEP = "\n" + 8 * " "
        #print SEP.join(targets)
        if len(targets) > 1:
            print
            for a in targets:
                print "\t%s" % (a, )
        else:
            assert targets[0] == maintarg
            print targets[0]
        assert buildstep(targets, depends) == True
        if is_target_outdated(maintarg, *depends):
            raise Exception("Target file not produced", maintarg)
        else:
            print "Updated:", maintarg
    else:
        print "Current:", maintarg

class Relationship:
    # command must be a buildstep
    def __init__(self, targets, dependencies, command):
        for a in targets:
            self.relationships()[a] = self
        self.targets = targets
        self.dependencies = dependencies
        self.command = command
    def relationships(self):
        return relationships
    def update(self):
        # recursively update, this propagates modifications up the tree
        for dep in self.dependencies:
            try:
                # try to update via explicit relationships
                self.relationships()[dep].update()
            except KeyError:
                # look for a pattern rule
                for rule in pattern_rules:
                    if rule.update(dep):
                        break
                else:
                    # no relationship is defined, the file should exist
                    # (eg the file is created by moi)
                    if not os.path.exists(dep):
                        raise Exception("No rule to generate file", dep)
        # now that immediate deps have been updated as required
        # we can determine if _this_ target needs updating
        for targ in self.targets:
            update(targ, self.targets, self.dependencies, self.command)

class PatternRule:
    # command must be a buildstep
    def __init__(self, pattern, repl, command):
        self.pattern = pattern
        self.repl = repl
        self.command = command
        pattern_rules.append(self)
    # return True if this rule can build the target
    def update(self, target):
        dep = re.subn(self.pattern, self.repl, target, 1)
        # dep is (new_string, number_of_subs_made)
        if dep[1] == 1:
            update(target, [target], [dep[0]], self.command)                
            return True
        else:
            return False

def clean():
    print "Cleaning all targets"
    for target in relationships.iterkeys():
        print "Archiving", target
        shutil.move(target, "." + target + "~")

if __name__ == "__main__":
    print "I R HOOK U"

def main():
    # parse args here...
    pass
