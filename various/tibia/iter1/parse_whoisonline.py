#!/usr/bin/env python3.0

import tibiacom
import dbiface

players, update_time = tibiacom.who_is_online("Dolera")
db = dbiface.TibiaDB()
for p in players:
	db.update_player(p, online=True, ontime=update_time)
