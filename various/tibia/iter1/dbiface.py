import sqlite3
import time

TIBIADB_SCHEME = \
"""
create table vocation (
	id integer primary key,
	str text unique
);

insert or ignore into vocation (str) values ('None');
insert or ignore into vocation (str) values ('Knight');
insert or ignore into vocation (str) values ('Elite Knight');
insert or ignore into vocation (str) values ('Paladin');
insert or ignore into vocation (str) values ('Royal Paladin');
insert or ignore into vocation (str) values ('Druid');
insert or ignore into vocation (str) values ('Elder Druid');
insert or ignore into vocation (str) values ('Sorcerer');
insert or ignore into vocation (str) values ('Master Sorcerer');

create table player (
	id integer primary key,
	name text unique,
	monster integer,
);
create table online (
	plyr_id integer,
	level integer,
	voc_id integer,
	ontime text
);
create table death (
	victim_id integer primary key,
	time text primary key,
	level integer,
	slayer_id integer primary key,
	assist integer primary key
);
"""

class TibiaDB():
	def __init__(self, dbpath="tibiadb"):
		self.conn = sqlite3.connect(dbpath)
		self.curs = self.conn.cursor()
		# it's okay if the schema is already created
		try:
			self.curs.executescript(TIBIADB_SCHEME)
		except sqlite3.OperationalError:
			pass

	def __del__(self):
		self.conn.commit()

	def __get_player_id(self, name, insert=True):
		self.curs.execute("select id from player where name=?", [name])
		r = self.curs.fetchone()
		if r is None:
			assert insert is True
			self.curs.execute("insert into player (name) values (?)", [name])
			id = self.__get_player_id(name, False)
		else:
			id = r[0]
		return id

	def __get_vocation_id(self, vocation):
		self.curs.execute("select id from vocation where str=?", [vocation])
		# this can't fail or the vocation doesn't exist
		return self.curs.fetchone()[0]

	def update_player(self, infos, **excess):
		# merge infos and excess, don't allow duplicate keys
		if infos is None: infos = {}
		for k in excess:
			assert not k in infos.keys()
			infos[k] = excess[k]

		# get the actual key values
		plyr_id = self.__get_player_id(infos["name"])
		voc_id = self.__get_vocation_id(infos["vocation"])

		# update online presence
		if infos["online"] is True:
			self.curs.execute("insert into online (plyr_id, level, voc_id, ontime) values (?,?,?,datetime(?, 'unixepoch'))", (plyr_id, infos["level"], voc_id, infos["ontime"]))

		# update player details
		cols_to_update = {"voc_id": voc_id}
		for k in infos.keys():
			if k in ["level"]:
				cols_to_update[k] = infos[k]
		for k, v in cols_to_update.items():
			self.curs.execute(r"update player set %s=? where id=?" % (k,), (v, plyr_id))

	def get_recent_online_players(self, seconds):
		self.curs.execute("select distinct player.name from player,online where player.id=online.plyr_id and online.ontime > datetime(?, 'unixepoch')", (time.time() - seconds,))
		return self.curs.fetchall()
