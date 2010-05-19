#!/usr/bin/env python

import pytibia

client = pytibia.Client()

for entity in client.iter_entities():
	print entity
