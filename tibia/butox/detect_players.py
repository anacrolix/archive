#!/usr/bin/env python

import time
import pytibia, botutil

client = pytibia.Client()
oldonscr = set()
while True:
	newonscr = set()
	for entity in client.iter_entities():
		if entity.onscreen and entity.is_player() and entity.id != client.player_entity_id():
			if entity.name not in oldonscr:
				print entity.human_readable(reltopos=client.player_coords())
				botutil.beep()
			newonscr.add(entity.name)
	oldonscr = newonscr
	time.sleep(1.0)
