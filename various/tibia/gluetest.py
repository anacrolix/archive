#!/usr/bin/env python3.0

from parsers.tibiacom import *

dolera = ServerStatus('Dolera')
print("Players online on Dolera:")
print("Total players:", dolera.player_count())
