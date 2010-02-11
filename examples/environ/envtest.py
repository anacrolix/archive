import os
import sys

for e in sys.argv[1:]:
    print "%s=%r" % (e, os.environ[e])
