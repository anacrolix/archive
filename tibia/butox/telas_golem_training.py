#!/usr/bin/env python

import os, random, sys, time

import botutil, pytibia
from eruanno import SAFE_LIST
from defcon.level import *

class TelasGolemTraining(botutil.TibiaBot):
	def __init__(self, afk):
		botutil.TibiaBot.__init__(self, silent=afk)
		self.afk = afk
	def start_up(self):
		self.startpos = self.client.player_coords()
		self.lstacttk = time.time() - pytibia.IDLE_TIMEOUT_SECS
		self.nextface = random.randint(0, 3)
		self.lasthp = self.client.player_current_hitpoints()
	def do_stuff(self):
		curhp = self.client.player_current_hitpoints()
		maxhp = self.client.player_maximum_hitpoints()
		if curhp < self.lasthp:
			self.notify(CRITICAL, "Player hitpoints %d/%d", curhp, maxhp)
		for entity in self.client.iter_entities():
			if 		entity.onscreen \
					and entity.is_player() \
					and entity.id != self.client.player_entity_id() \
					and entity.name not in SAFE_LIST:
				self.notify(
						DANGER,
						"Intruder: %s",
						entity.human_readable(self.client.player_coords()))
		if not self.afk:
			curmana = self.client.player_current_mana()
			maxmana = self.client.player_maximum_mana()
			# 2.5 mins for a knight
			if curmana >= maxmana - 20 * 2.5:
				self.notify(ATTEND, "Player mana %d/%d", curmana, maxmana, persist=False)
		if not self.client.player_target_entity_id():
			self.notify(ATTEND, "No target")
		if not self.client.player_coords() == self.startpos:
			self.notify(DANGER, "Player has moved", persist=False)

		# don't try to stay online if we're in danger, better to be dropped
		if self.afk and self.defcon_level >= ATTEND:
			self.client.terminate()
			#raise SystemExit()

		if self.defcon_level < DANGER:
			nxtacttk = self.lstacttk + pytibia.IDLE_TIMEOUT_SECS + random.randint(5, 45)
			if time.time() >= nxtacttk:
				self.client.send_key_press("Control+" + ["Up", "Right", "Down", "Left"][self.nextface])
				self.nextface = (self.nextface + 1) % 4
				self.lstacttk = time.time()
		if curhp < maxhp - 800 and (self.defcon_level >= DANGER or curhp < self.lasthp):
			self.client.send_key_press("F1")

		# update persistent values

		self.lasthp = curhp

if __name__ == "__main__":
	from optparse import OptionParser
	parser = OptionParser()
	parser.add_option("--afk", action="store_true", default=False)
	options, args = parser.parse_args()
	#print options, args
	TelasGolemTraining(afk=options.afk)()
