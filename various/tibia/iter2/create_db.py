#!/usr/bin/env python

import sqlite3
from constants import *


conn = sqlite3.connect(DB_PATH)
curs = conn.cursor()
curs.executescript(
"""
create table death(
	pronounced text,
	victim text,
	level integer,
	killer text,
	assist integer,
	monster integer,
	unique (pronounced, victim, assist) on conflict ignore
);
create table player(
	name text,
	timestamp text,
	level integer,
	vocation text,
	sex text,
	residence text,
	guild text,
	last_login text,
	account_status text,
	unique (name, timestamp) on conflict ignore
);
""")
