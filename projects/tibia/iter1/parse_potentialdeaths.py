#!/usr/bin/env python3.0

import tibiacom
import dbiface

db = dbiface.TibiaDB()

def active_players():
	return dbiface.get_recent_online_players(15*60)

