#!/usr/bin/env python

from __future__ import absolute_import

import calendar, datetime, logging, os.path, pdb, pprint, sqlite3, sys, time

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
    if isinstance(value, int):
        return value
    try:
        return int(value)
    except ValueError:
        pass
    try:
        return tibia_time_to_unix(value)
    except ValueError:
        pass
    try:
        return calendar.timegm(time.strptime(value, "%a, %d %b %Y %H:%M:%S %Z"))
    except ValueError:
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

def update_char(name, ifnotset=False, **extra):
    cursor = dbConn.execute("INSERT OR IGNORE INTO player (name) VALUES (?)", (name,))
    assert (cursor.rowcount & ~1) == 0 # either it's added, or it isn't.
    # if online is passed, then put the char's name and stamp into the online list
    if extra.pop("online", False):
        cursor = dbConn.execute("insert into online (name, stamp) values (?, ?)", (name, extra["stamp"]))
    for death in extra.pop("deaths", ()):
        #pdb.set_trace()
        logging.debug(pprint.pformat(death))
        for killer in death.killers:
            dbConn.execute(
                    """INSERT OR IGNORE INTO death
                        (stamp, victim, killer, lasthit, isplayer, level)
                        VALUES (?, ?, ?, ?, ?, ?)""",
                    (death.time, name, killer.name, killer is death.killers[-1], killer.isplayer, death.level))
            if killer.isplayer:
                update_char(killer.name, ifnotset=True, world=extra["world"])
    extra.pop("stamp", None)
    for col in extra.keys():
        sql = "UPDATE player SET {0}=? WHERE name=?"
        if ifnotset:
            sql += " AND {0} IS NULL"
        cursor = dbConn.execute(sql.format(col), (extra.pop(col), name))
        assert (cursor.rowcount & ~1) == 0
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
        assert False # probably now minus 5 mins is best
    # MUST BE STRING TO TRIGGER COLLATION
    sql = """
            SELECT player.name, level, vocation, guild, world
            FROM
                (SELECT DISTINCT name FROM online WHERE stamp > ? COLLATE stamp_collation) AS onnow
                INNER JOIN player ON (onnow.name=player.name)"""
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

def get_last_deaths(limits=None, world=None):
    sql = "SELECT death.*, world FROM death JOIN player ON (death.victim=player.name)"
    params = []
    if world:
        sql += " WHERE world=?"
        params.append(world)
    sql += " ORDER BY stamp COLLATE stamp_collation DESC LIMIT ?, ?"
    params.extend(limits)
    return dbConn.execute(sql, params)

def pz_end(deathRow):
    return tibia_time_to_unix(deathRow["stamp"]) + (900 if deathRow["lasthit"] else 60)

def get_last_pzlocks(world, limits):
    sql = """
            SELECT stamp, killer, victim, lasthit, killer.level
            FROM death JOIN player AS killer ON (death.killer=killer.name)
            WHERE death.isplayer
        """
    params = []
    if world:
        sql += " AND world=?"
        params.append(world)
    sql += " ORDER BY stamp COLLATE stamp_collation DESC"
    cursor = dbConn.execute(sql, params)
    mostRecent = []
    # as the deaths are handled in reverse chrono order, each victim can be added to a list of deceased, and no pz locks attached by kills from that point onwards can count.
    deceased = set()
    for row in cursor:
        if row["killer"] in deceased:
            print >>sys.stderr, "%s died after this kill %s" % (row["killer"], row)
        for a in mostRecent:
            if row["killer"] == a["killer"]:
                # the killer is already in our list
                if pz_end(row) > pz_end(a):
                    # this kill has a pz that ends after the existing entry
                    #print >>sys.stderr, "%s more recent than %s" % (tuple(row), tuple(a))
                    mostRecent.remove(a)
                    mostRecent.append(row)
                # since the killer has been found, we've either replaced the entry, or we're done looking for clashes
                break
        else:
            # the killer is not in our list yet, so add him
            mostRecent.append(row)
        if len(mostRecent) == int(limits[1]):
            break
        deceased.add(row["victim"])
    del cursor
    return sorted(mostRecent[limits[0]:], key=lambda x: pz_end(x), reverse=True)

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
