from __future__ import division

import os
import os.path
import pdb
import sys

bytes = 0
count = 0
def on_walk_error(exc):
    #raise exc
    pass
onlydev = os.stat(sys.argv[1]).st_dev
for dirpath, dirnames, filenames in os.walk(sys.argv[1], onerror=on_walk_error):
    #pdb.set_trace()
    for dn in dirnames[:]:
        st = os.lstat(os.path.join(dirpath, dn))
        if st.st_dev != onlydev:
            dirnames.remove(dn)
        count += 1
        bytes += st.st_size
    for fn in filenames:
        count += 1
        bytes += os.lstat(os.path.join(dirpath, fn)).st_size
        #bytes += os.path.getsize(os.path.join(dirpath, fn))
    print "\r" + dirpath
    print bytes, count, bytes / count,
    sys.stdout.flush()
