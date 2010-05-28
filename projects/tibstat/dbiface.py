#!/usr/bin/env python

import calendar, contextlib, datetime, logging, os.path, pdb, pprint, sqlite3, sys, threading, time

import tibiacom
from tibiacom import tibia_time_to_unix, next_whoisonline_update

# player is used for the table name because char/character has programmatic meaning
# use string params wherever collations are in effect, or the collation is not used

def to_unixepoch(value):
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
    assert False, value # uh oh...

def collate_stamp(left, right):
    assert isinstance(left, str)
    assert isinstance(right, str)
    left = to_unixepoch(left)
    right = to_unixepoch(right)
    return cmp(left, right)

def pz_end(deathRow):
    return tibia_time_to_unix(deathRow["stamp"]) + ((16 * 60) if deathRow["lasthit"] else 60)

# prefer key lookups to indexing tuples
class MyRow(sqlite3.Row):
    # try to provide a better representation for pprinting
    def __repr__(self):
        return str(tuple(self))

class TibstatDatabase(object):

    _dbpath = "tibia.db"
    _writeLock = threading.Lock()

    def __init__(self):
        assert os.path.exists(self._dbpath) # sqlite3 will create if it doesn't exist
        self._dbconn = sqlite3.connect(self._dbpath, timeout=.01)#, isolation_level='DEFERRED')
        self._dbconn.text_factory = str
        self._dbconn.row_factory = MyRow
        self._dbconn.create_collation("stamp_collation", collate_stamp)

    def _update_char(self, name, ifnotset=False, **extra):
        dbConn = self._dbconn
        formerNames = extra.pop("former_names", None)
        if formerNames:
            for fn in formerNames:
                cursor = dbConn.execute("DELETE FROM player WHERE name=?", (fn,))
                if cursor.rowcount == 1:
                    logging.warning("Replacing former player %r with %r", fn, name)
                else:
                    assert cursor.rowcount == 0
        cursor = dbConn.execute("INSERT OR IGNORE INTO player (name) VALUES (?)", (name,))
        assert (cursor.rowcount & ~1) == 0 # either it's added, or it isn't.
        # if online is passed, then put the char's name and stamp into the online list
        if extra.pop("online", False):
            cursor = dbConn.execute("insert into online (name, stamp) values (?, ?)", (name, str(extra["stamp"])))
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
                    self._update_char(killer.name, ifnotset=True, world=extra["world"])
        extra.pop("stamp", None)
        for col in extra.keys():
            sql = "UPDATE player SET {0}=? WHERE name=?"
            if ifnotset:
                sql += " AND {0} IS NULL"
            cursor = dbConn.execute(sql.format(col), (extra.pop(col), name))
            assert (cursor.rowcount & ~1) == 0
        assert len(extra) == 0, extra

    def get_all_chars(self, world=None):
        sql = "SELECT * FROM player"
        params = []
        if world:
            sql += " WHERE world=?"
            params.append(world)
        sql += " ORDER BY name"
        return self._dbconn.execute(sql, params)

    def get_char(self, name):
        dbConn = self._dbconn
        curs = dbConn.execute("select * from player where name=?", (name,))
        row = curs.fetchone()
        assert curs.fetchone() == None
        if row is None:
            row = dict((x[0], None) for x in curs.description)
            row["name"] = name
        assert row["name"] == name
        return row

    def get_online_chars(self, after=None, world=None):
        #pdb.set_trace()
        if after is None:
            after = next_whoisonline_update() - (5 * 60 + 30)
        assert after <= int(time.time()), (after, int(time.time()))
        """Iterate over the players online after the given time."""
        sql = """
                SELECT  player.name, player.level, player.vocation, player.level,
                        player.guild, player.world
                FROM online JOIN player ON (online.name = player.name)
                WHERE vocation != 'None' AND online.stamp > ? COLLATE stamp_collation
            """
        # MUST BE STRING TO TRIGGER COLLATION
        params = [str(after)]
        if world is not None:
            sql += " AND world = ?"
            params.append(world)
        returned = {}
        for row in self._dbconn.execute(sql, params):
            if row["name"] in returned:
                assert returned[row["name"]] == row
            else:
                yield row
                returned[row["name"]] = row

    def list_guilds(self, world):
        dbConn = self._dbconn
        return self._dbconn.execute("""
                    SELECT guild, COUNT(*)
                    FROM player
                    WHERE world = ? AND guild NOT NULL
                    GROUP BY guild""",
                (world,))

    def get_deaths(self, after):
        dbConn = self._dbconn
        cursor = dbConn.execute("select * from death where time > ? collate stamp_collation", (str(after),))
        return cursor.fetchall()

    def get_last_deaths(self, limits=None, world=None, minlevel=None):
        dbConn = self._dbconn
        sql = """
                SELECT death.*, world, guild
                FROM death JOIN player ON (death.victim=player.name)
            """
        params = []
        whereops = []
        if world:
            whereops.append("world = ?")
            params.append(world)
        if minlevel:
            whereops.append("death.level >= ?")
            params.append(minlevel)
        if whereops:
            sql += " WHERE " + " AND ".join(whereops)
        sql += " ORDER BY stamp COLLATE stamp_collation DESC LIMIT ?, ?"
        params.extend(limits)
        return dbConn.execute(sql, params)

    def get_last_pzlocks(self, world, limits):
        dbConn = self._dbconn
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
                logging.debug("%s died after this kill %s", row["killer"], row)
            else:
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

    def set_worlds(self, worlds):
        dbConn = self._dbconn
        dbConn.execute("delete from world")
        dbConn.executemany("insert into world (name) values (?)", ((a,) for a in worlds))
        #dbConn.commit()

    def get_worlds(self):
        dbConn = self._dbconn
        return dbConn.execute("SELECT name FROM world")

    def best_player_killers(self, world=None):
        sql = """
                SELECT count(*), player.world, player.name, player.level, player.vocation, player.guild
                FROM death JOIN player ON (death.killer = player.name)
                WHERE isplayer AND lasthit
            """
        params = []
        if world:
            sql += " AND world = ?"
            params.append(world)
        sql += """
                GROUP BY killer
                ORDER BY count(*) DESC
                LIMIT 0, 30
            """
        return self._dbconn.execute(sql, params)

    @contextlib.contextmanager
    def _write_lock(self):
        with self._writeLock:
            def until_succeeds(func, *args):
                while True:
                    try:
                        func(*args)
                    except sqlite3.OperationalError as e:
                        assert e.args[0] == "database is locked"
                        #logging.warning(e)
                    else:
                        break
            until_succeeds(self._dbconn.execute, "BEGIN IMMEDIATE")
            yield
            until_succeeds(self._dbconn.commit)

    def update_guilds(self, world):
        for guild in tibiacom.get_world_guilds(world):
            logging.info("Updating guild %r", guild)
            for member in tibiacom.get_guild_members(guild):
                dbiface.update_char(member, guild=guild, world=world)

    def update_world_online(self, world):
        localStamp = int(time.time())
        html, headers = tibiacom.http_get(tibiacom.world_online_url(world))
        players = tibiacom.parse_world_online(html)
        logging.info("Found %d players on %s", len(players), world)
        serverStamp = to_unixepoch(headers["Date"])
        if abs(localStamp - serverStamp) > 1:
            logging.warning("Page Date %d and localtime %s differ greatly", serverStamp, localStamp)
        #print to_unixepoch(headers["Date"]), int(time.time())
        with self._write_lock():
            for p in players:
                self._update_char(
                        p.name, level=p.level, vocation=p.vocation, online=True,
                        stamp=serverStamp, world=world)
        #self._commit()

    def update_char(self, name):
        info = tibiacom.get_char_page(name)
        charName = info.pop("name")
        with self._write_lock():
            self._update_char(charName, **info)
        return charName

    def update_recent_deaths(self, after):
        for row in dbiface.get_online_chars(after):
            update_char(row["name"])

_tsdb = TibstatDatabase()
for a in dir(_tsdb):
    if not a.startswith("_"):
        assert not hasattr(sys.modules[__name__], a)
        setattr(sys.modules[__name__], a, getattr(_tsdb, a))

# most deaths
#select count(*), victim from (select distinct time, victim from death) group by victim order by count(*);

def main():
    tsdb = TibstatDatabase()
    print getattr(tsdb, sys.argv[1])(*sys.argv[2:])
    #tsdb.commit()

if __name__ == "__main__":
    main()
