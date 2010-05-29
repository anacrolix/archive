#!/usr/bin/env python

import random, time
import botutil, pytibia

SAFE_LIST = ("Plashz", "Orelius", "Royal Makia", "Cuppydo", \
		"Kataztros", "Blackarcher", "Zaus Tibard")

class TelasGolemTraining(pytibia.Bot):
	def start_up(self):
		self.startpos = self.client.player_coords()
		self.lastact = 0
		self.lastface = random.randint(0, 3)
	def do_stuff(self):
		client = self.client
		startpos = self.startpos
		notifier = self.notifier

		curhp = client.player_current_hitpoints()
		maxhp = client.player_maximum_hitpoints()
		if curhp != maxhp:
			notifier.critical("Player hitpoints %d/%d", curhp, maxhp)
		curmana = client.player_current_mana()
		maxmana = client.player_maximum_mana()
		if curmana >= maxmana - 50:
			notifier.attend("Player mana %d/%d", curmana, maxmana)
		for entity in client.iter_entities():
			if 		entity.onscreen \
					and entity.is_player() \
					and entity.id != client.player_entity_id() \
					and entity.name not in SAFE_LIST:
				notifier.danger(
						"Intruder: %s",
						entity.human_readable(client.player_coords()),
						persist=True)
		if not client.player_target_entity_id():
			notifier.attend("No target")
		if not client.player_coords() == startpos:
			notifier.danger("Player has moved", persist=False)

		if curhp < maxhp - 750:
			self.client.send_key_press("F1")
		if self.notifier.level is None and \
				self.curtick >= self.lastact + 15*60+random.randint(1, 30):
			self.client.send_key_press("Control+" + ["Up", "Right", "Down", "Left"][self.lastface])
			self.lastface = (self.lastface + 1) % 4
			self.lastact = self.curtick

TelasGolemTraining()()
