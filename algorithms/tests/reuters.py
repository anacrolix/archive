from urllib import urlretrieve
import hashlib
import os.path
import tarfile

REUTERS_FOLDER = "reuters21578"

def get_reuters():
    REUTERS_ARCHIVE = "reuters21578.tar.gz"
    REUTERS_ARCHIVE_URL = "http://www.daviddlewis.com/resources/testcollections/reuters21578/reuters21578.tar.gz"

    if not os.path.exists(REUTERS_ARCHIVE):
        raw_input("Press enter to download Reuters-21578 collection")
        print "Downloading", REUTERS_ARCHIVE
        urlretrieve(REUTERS_ARCHIVE_URL, REUTERS_ARCHIVE)
    reuters_file = open(REUTERS_ARCHIVE, "rb")
    assert hashlib.md5(reuters_file.read()).hexdigest() == "a22faadd7dde0dfdd784e60087209aa6"
    reuters_file.seek(0)
    reuters_tar = tarfile.open(fileobj=reuters_file)
    print "Extracting", REUTERS_ARCHIVE
    reuters_tar.extractall(REUTERS_FOLDER)

def get_keywords():
    r = []
    for a in ("exchanges", "orgs", "people", "places", "topics"):
        for kw in open(os.path.join(REUTERS_FOLDER, "all-" + a + "-strings.lc.txt")):
            if len(kw):
                assert kw[-1] == "\n" and kw[-2] != "\r"
                kw = kw[:-1]
                assert kw not in r
                r.append(kw)
    assert len(r) == 672
    return r

def get_data_files():
    return [open(os.path.join(REUTERS_FOLDER, "reut2-%03d.sgm" % (a,))) for a in xrange(22)]
