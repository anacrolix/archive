#!/usr/bin/env python

# this is an example only

import collections, hashlib, os, os.path, pprint, sys

# returns a list of lists of duplicates
def find_duplicate_files(dirpath):
    file_hashes = collections.defaultdict(list)
    for root, dirs, files in os.walk(dirpath):
        for f in files:
            path = os.path.join(root, f)
            print path
            # note this may be inefficient for large files
            hash = hashlib.md5(open(path, "rb").read()).hexdigest()
            print hash
            file_hashes[hash].append(path)
    return filter(lambda x: len(x) > 1, file_hashes.itervalues())

pprint.pprint(find_duplicate_files(sys.argv[1]))
