#!/usr/bin/env python

import tibiacom
import db_interface
import sqlite3
import constants
import time

conn = sqlite3.connect(constants.DB_PATH)
cursor = conn.cursor()

online = tibiacom.online_list("Dolera")
for a in online:
	db_interface.add_char_info(tibiacom.char_info(a["name"]), cursor)
	conn.commit()

print db_interface.query_recent_deaths(cursor, time.mktime(time.gmtime()) - 1800)
