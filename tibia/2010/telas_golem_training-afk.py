#!/usr/bin/env python

import os, random, signal, time
import botutil, pytibia

from eruanno import SAFE_LIST

class TelasGolemTraining(pytibia.Bot):
	def start_up(self):
		self.startpos = self.client.player_coords()
		self.lastact = 0
		self.lastface = random.randint(0, 3)
		self.lasthp = self.client.player_current_hitpoints()
		self.skilprog = [self.client.skill_progress(skillnam) for skillnam in pytibia.SKILL_NAMES]
		assert len(self.skilprog) == len(pytibia.SKILL_NAMES)
	def do_stuff(self):
		# compatibility with these once being globals
		client = self.client
		startpos = self.startpos
		notifier = self.notifier

		# get various values from the client, and elevate the notifier level

		curhp = client.player_current_hitpoints()
		maxhp = client.player_maximum_hitpoints()
		if curhp < self.lasthp:
			notifier.critical("Player hitpoints %d/%d", curhp, maxhp)
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
		# check for changes in skill progress
		for skillidx, skillnam in enumerate(pytibia.SKILL_NAMES):
			newprog = self.client.skill_progress(skillnam)
			oldprog = self.skilprog[skillidx]
			if newprog != oldprog:
				notifier.attend("Skill %s has %u%% remaining", skillnam.upper(), 100 - newprog, persist=False)
				self.skilprog[skillidx] = newprog

		# here we do stuff based on findings above

		if self.notifier.level is None and \
				self.curtick >= self.lastact + 15*60+random.randint(1, 45):
			self.client.send_key_press("Control+" + ["Up", "Right", "Down", "Left"][self.lastface])
			self.lastface = (self.lastface + 1) % 4
			self.lastact = self.curtick
		if self.notifier.level > notifier.ATTEND:
			notifier.critical("Closing client")
			os.kill(self.client.pid, signal.SIGKILL)
			raise SystemExit()

		self.lasthp = curhp

TelasGolemTraining()(catchexc=False)
