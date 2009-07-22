#!/usr/bin/env python

reuters_file = open("reuters21578.tar.gz", "rb")
import hashlib
assert hashlib.md5(reuters_file.read()).hexdigest() == "a22faadd7dde0dfdd784e60087209aa6"
reuters_file.seek(0)
import tarfile
reuters_tar = tarfile.open(fileobj=reuters_file)
reuters_tar.extractall("reuters21578")
