#!/usr/bin/env python

import contextlib, logging, os, sqlite3, sys, time

a = sqlite3.connect("testrace.db", timeout=60)
@contextlib.contextmanager
def write_lock():
    while True:
        try:
            a.execute("BEGIN IMMEDIATE")
        except sqlite3.OperationalError as e:
            assert e.args[0] == "database is locked"
            logging.debug(e)
            #time.sleep(0.01)
        else:
            break
    yield a
    a.commit()
    time.sleep(0.01)
    #a.close()
    logging.debug("wrote entry")

logging.basicConfig(
        stream=sys.stderr,
        level=logging.DEBUG,
        format="%(levelname)s:%(process)d:%(created)f:%(message)s")

with write_lock():
    a.execute("delete from blah")

while True:
    with write_lock():
        a.execute("INSERT INTO blah VALUES (?)", (os.getpid(),))
    time.sleep(0)
