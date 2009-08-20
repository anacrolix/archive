#!/usr/bin/env python

import ftplib

a = ftplib.FTP("ftp.kernel.org")
a.login()
a.cwd("pub/linux/kernel/v2.6")
PREFIX = "ChangeLog-"
b = [c[len(PREFIX):] for c in a.nlst() if c.startswith(PREFIX)]
b = [tuple(map(int, d.split("."))) for d in b]
f = {}
for e in b:
    if e[:3] not in f or e > f[e[:3]]:
        f[e[:3]] = e
for g in [".".join(map(str, h)) for h in sorted(f.values())]:
    print g
