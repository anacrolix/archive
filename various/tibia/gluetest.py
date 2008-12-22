#!/usr/bin/env python3.0

import tibiacom
import dbiface

db = dbiface.TibiaDB()
if True:
	players, update_time = tibiacom.who_is_online("Dolera")

	for p in players:
		db.update_player(p, online=True, time=update_time)

print(db.get_recent_online_players(900), len(db.get_recent_online_players(900)))
