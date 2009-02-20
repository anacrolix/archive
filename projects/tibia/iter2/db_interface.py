import constants
import tibiacom_util

def add_death(cursor, pronounced, victim, level, killer, assist, monster):
	params = (
			int(tibiacom_util.tibia_time_to_unix(pronounced)),
			victim, int(level), killer, assist, monster)
	cursor.execute(
			"insert into death values(datetime(?, 'unixepoch'), ?, ?, ?, ?, ?)",
			params)

def add_char_info(cur, ci):
	print ci
	if ci.has_key("deaths"):
		victim = ci["name"]
		for a in ci["deaths"]:
			add_death(cur, a[0], victim, a[1], a[2][1], False, a[2][0])
			if a[3] != None:
				add_death(cur, a[0], victim, a[1], a[3][1], True, a[3][0])
	cur.execute(
			r"insert into player values(?,datetime(?, 'unixepoch'),?,?,?,?,?,?,?)",
			(ci["name"], int(ci["timestamp"]), int(ci["level"]), ci["vocation"],
			ci["sex"], ci["residence"], ci["guild"], ci["last login"],
			ci["account status"]))

def add_online_list(cursor, online, timestamp):
	print timestamp
	for a in online:
		cursor.execute(
				r"insert into player (name, timestamp, level, vocation) values(?, datetime(?, 'unixepoch'), ?, ?)",
				(a["name"], timestamp, a["level"], a["vocation"]))

def query_recent_deaths(cursor, epoch):
	sql = r"select pronounced, victim from death where pronounced > datetime(?, 'unixepoch')"
	cursor.execute(sql, (epoch,))
	return cursor.fetchall()
