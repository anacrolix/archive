def pprint_online_list(ol, stamp):
    for a in ol:
        print("%-32s%5s %s" % (a.name, a.level, a.vocation))
    print(len(ol), "players online as of", time.ctime(stamp))

def pprint_death(death, victim):
    b = death
    print b.time + ":",
    print "%r died at Level %d to %s" % (victim, b.level, ", ".join(map(lambda x: x.name, b.killers)))

def pprint_char_info(info):
    # force name to be printed first, and deaths treated specially later
    simple = list(info.keys())
    for a in ("deaths", "name"): simple.remove(a)
    for k in ["name"] + simple:
        print k + ":", info[k],
        if k in ["created", "last login"] and info[k] is not None:
            print("(" + str(int(time.time()) - tibia_time_to_unix(info[k])) + "s ago)")
        elif k is "timestamp":
            print("(%s CET)" % time.asctime(time.gmtime(info[k] + 3600)))
        else:
            print()
    a = info["deaths"]
    if a != None:
        for b in a:
            pp_death(b)
