#!/usr/bin/env python

import logging, time, traceback
import botutil, pytibia

def situation_normal():
	normal = [True] # nonlocal workaround
	def report_problem(fmtstr, *args):
		normal[0] = False
		logging.warning(fmtstr, *args)
	curhp = client.player_current_hitpoints()
	maxhp = client.player_maximum_hitpoints()
	if curhp * 2 < maxhp:
		report_problem("Player hitpoints %d/%d", curhp, maxhp)
	curmana = client.player_current_mana()
	maxmana = client.player_maximum_mana()
	if curmana >= maxmana - 100:
		report_problem("Player mana %d/%d", curmana, maxmana)
	for entity in client.iter_entities():
		if 		entity.onscreen \
				and entity.is_player() \
				and entity.id != client.player_entity_id():
			report_problem("Intruder: %s", entity.human_readable(client.player_coords()))
	if not client.player_target_entity_id():
		report_problem("Target lost")
	return normal[0]

client = pytibia.Client()
try:
	while True:
		if not situation_normal():
			botutil.beep()
		time.sleep(2.0)
except Exception as e:
	traceback.print_exc()
	while True:
		botutil.beep()
		time.sleep(2.0)
finally:
	pass

