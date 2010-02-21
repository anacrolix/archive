#!/usr/bin/env python

import dbiface

print dbiface.get_char("Edkeys")["guild"]
print tuple(dbiface.list_guilds())
