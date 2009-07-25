#!/usr/bin/env python

from urllib import urlretrieve
import hashlib
import os.path
import tarfile

REUTERS_ARCHIVE = "reuters21578.tar.gz"
REUTERS_ARCHIVE_URL = "http://www.daviddlewis.com/resources/testcollections/reuters21578/reuters21578.tar.gz"

if not os.path.exists(REUTERS_ARCHIVE):
    print "Downloading", REUTERS_ARCHIVE
    urlretrieve(REUTERS_ARCHIVE_URL, REUTERS_ARCHIVE)
reuters_file = open(REUTERS_ARCHIVE, "rb")
assert hashlib.md5(reuters_file.read()).hexdigest() == "a22faadd7dde0dfdd784e60087209aa6"
reuters_file.seek(0)
reuters_tar = tarfile.open(fileobj=reuters_file)
print "Extracting", REUTERS_ARCHIVE
reuters_tar.extractall("reuters21578")
