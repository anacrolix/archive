import shutil, os, stat, subprocess

relationships = {}

class Relationship:
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
                self.relationships()[dep].update()
            except KeyError:
                # no relationship is defined, do nothing
                # (eg the file is created by moi)
                pass
        for targ in self.targets:
            for dep in self.dependencies:
                g = False
                d = os.stat(dep)[stat.ST_MTIME]
                try:
                    e = os.stat(targ)[stat.ST_MTIME]
                except OSError as f:
                    assert f.errno == 2
                    g = True
                if g != True and d > e: g = True
                if g == True:
                    # might have to use list2cmd or w/e here on windows?
                    print self.command(self.targets, self.dependencies)
                    status = subprocess.check_call(self.command(self.targets, self.dependencies), shell=True)
                    print "execute command:", targ, "<-", dep
            print dep, "uptodate"

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
