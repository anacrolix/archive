#!/usr/bin/env python

import sys, time
sys.path.append("../tibdb")
import dbiface, tibiacom

world = "Dolera"

def update_guilds():
    guildList = tibiacom.guild_list(world)
    for guild in guildList:
        memberList = tibiacom.guild_info(guild)
        for member in memberList:
            dbiface.update_char(member, guild=guild)

def update_world_online():
