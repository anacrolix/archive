#!/usr/bin/env python

import tibiacom
import time
from tibiacom_util import tibia_time_to_unix as parse_tibia_time

def print_online_player_details(world):
	current = tibiacom.online_list(world)
	for a in current:
		tibiacom.pretty_print_char_info(tibiacom.char_info(a["name"]))
		print

def print_last_login_localtime(world):
	online = tibiacom.online_list(world)
	print time.ctime()
	for a in online:
		print time.ctime(parse_tibia_time(tibiacom.char_info(a["name"])["last login"])), a["name"]

#print_last_login_localtime("Dolera")

eru = tibiacom.char_info("Eruanno")
print time.mktime(time.gmtime()) - parse_tibia_time(eru["last login"])
#print eru
