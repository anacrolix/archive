#!/usr/bin/env python

import threading
import tibiacom

stamp, online = tibiacom.online_list('Dolera')
online.sort(reverse=True, key=lambda x: int(x.level))

sem = threading.Semaphore(10)
outl = threading.Lock()

def print_recent_deaths(char):
    with sem:
        info = tibiacom.char_info(char.name)
    with outl:
        print char.name, char.level, char.vocation
        for dth in info["deaths"]:
            if tibiacom.tibia_time_to_unix(dth[0]) >= stamp - 1800:
                tibiacom.pp_death(dth)

for char in online:
    if char.level >= 45:
        thrd = threading.Thread(target=print_recent_deaths, args=(char,))
        thrd.start()
