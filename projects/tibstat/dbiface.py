#!/usr/bin/env python

from __future__ import absolute_import

import calendar, datetime, os.path, pdb, pprint, sqlite3, sys, time

from tibiacom import tibia_time_to_unix

dbPath = "tibia.db"
assert os.path.exists(dbPath)
dbConn = sqlite3.connect(dbPath)
# don't need unicode for now
dbConn.text_factory = str
# prefer key lookups to indexing tuples
class MyRow(sqlite3.Row):
    def __repr__(self):
        return str(tuple(self))
dbConn.row_factory = MyRow

# player is used for the table name because char/character has programmatic meaning

def to_unixepoch(value):
    #pdb.set_trace()
    try:
        return tibia_time_to_unix(value)
    except ValueError:
        pass
    try:
        return calendar.timegm(time.strptime(value, "%a, %d %b %Y %H:%M:%S %Z"))
    except ValueError:
        pass
    try:
        return int(value)
    finally:
        pass

def collate_stamp(left, right):
    #print left,
    left = to_unixepoch(left)
    #print left
    #print right,
    right = to_unixepoch(right)
    #print right
    return cmp(left, right)

dbConn.create_collation("stamp_collation", collate_stamp)

#dbConn.execute("DROP INDEX idx_death_stamp")
#dbConn.execute("CREATE INDEX idx_unique_death ON death (stamp COLLATE stamp_collation DESC, victim)")
#dbConn.execute("CREATE INDEX idx_death_stamp ON death (stamp COLLATE stamp_collation DESC)")
#dbConn.execute("create index idx_online_stamp on online (stamp collate stamp_collation);")

def create_tables():
    dbConn.executescript(
"""create table death (stamp text not null, victim not null, killer not null, lasthit not null, isplayer not null, level integer not null, unique(stamp, victim, killer));""")

def update_char(name, **extra):
    cursor = dbConn.execute("insert or ignore into player (name) values (?);", (name,))
    assert (cursor.rowcount & ~1) == 0
    if extra.pop("online", False):
        cursor = dbConn.execute("insert into online (name, stamp) values (?, ?)", (name, extra["stamp"]))
    for death in extra.pop("deaths", ()):
        #pdb.set_trace()
        pprint.pprint(death)
        for killer in death.killers:
            cursor = dbConn.execute(
                    "insert or ignore into death (stamp, victim, killer, lasthit, isplayer, level) values (?, ?, ?, ?, ?, ?)",
                    (death.time, name, killer.name, killer is death.killers[-1], killer.isplayer, death.level))
    extra.pop("stamp", None)
    for col in extra.keys():
        cursor = dbConn.execute("update player set {0}=? where name=?;".format(col), (extra.pop(col), name))
        assert cursor.rowcount == 1
    assert len(extra) == 0, extra
    dbConn.commit()

def get_char(name):
    curs = dbConn.execute("select * from player where name=?", (name,))
    row = curs.fetchone()
    assert curs.fetchone() == None
    if row is None:
        row = dict((x[0], None) for x in curs.description)
        row["name"] = name
    assert row["name"] == name
    return row

def get_online_chars(after=None, world=None):
    if after is None:
        after = 0
    # MUST BE STRING TO TRIGGER COLLATION
    sql = "SELECT player.name, level, vocation, guild, world FROM (SELECT DISTINCT name FROM online WHERE stamp > ? COLLATE stamp_collation) AS onnow INNER JOIN player ON (onnow.name=player.name)"
    params = [str(after)]
    if world is not None:
        sql += " WHERE world=?"
        params.append(world)
    #ORDER BY level DESC"
    #pdb.set_trace()
    return list(dbConn.execute(sql, params))

def list_guilds():
    for row in dbConn.execute("select distinct guild, world from player where world not null and guild not null order by world").fetchall():
        if row["guild"]:
            yield row

def get_deaths(after):
    cursor = dbConn.execute("select * from death where time > ? collate stamp_collation", (str(after),))
    return cursor.fetchall()

def get_last_deaths(limits=None):
    return dbConn.execute("""
            SELECT * FROM death ORDER BY stamp COLLATE stamp_collation DESC LIMIT ?, ?""",
            (limits))

def pz_end(deathRow):
    return tibia_time_to_unix(deathRow["stamp"]) + (900 if deathRow["lasthit"] else 60)

def get_pzlocks(curtime=None, margin=300):
    if curtime is None:
        curtime = int(time.time())
    #curtime = 1267263300
    cursor = dbConn.execute("select * from death where isplayer and ((stamp > ? collate stamp_collation and lasthit) or (stamp > ? collate stamp_collation and not lasthit))", (curtime - 900 - margin, curtime - 60 - margin))
    mostRecent = []
    for row in cursor:
        for a in mostRecent:
            if row["killer"] == a["killer"]:
                #pdb.set_trace()
                if pz_end(row) > pz_end(a):
                    print >>sys.stderr, "%s more recent than %s" % (tuple(row), tuple(a))
                    mostRecent.remove(a)
                    mostRecent.append(row)
                break
        else:
            mostRecent.append(row)
    return sorted(mostRecent, key=lambda x: pz_end(x), reverse=True)

def set_worlds(worlds):
    dbConn.execute("delete from world")
    dbConn.executemany("insert into world (name) values (?)", ((a,) for a in worlds))
    dbConn.commit()

def get_worlds():
    return dbConn.execute("select * from world")

# most deaths
#select count(*), victim from (select distinct time, victim from death) group by victim order by count(*);

def main():
    pprint.pprint(globals()[sys.argv[1]](*sys.argv[2:]))

if __name__ == "__main__":
    main()
