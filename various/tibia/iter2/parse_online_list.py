#!/usr/bin/env python

import constants
import tibiacom
import sqlite3
import db_interface

connection = sqlite3.connect(constants.DB_PATH)
cursor = connection.cursor()
timestamp, players = tibiacom.online_list("Dolera")
db_interface.add_online_list(cursor, players, timestamp)
connection.commit()
