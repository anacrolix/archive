import os.path, sqlite3

dbPath = "test.db"
assert os.path.exists(dbPath)
dbConn = sqlite3.connect(dbPath)
# don't need unicode for now
dbConn.text_factory = str
# prefer key lookups to indexing tuples
dbConn.row_factory = sqlite3.Row

# player is used for the table name because char/character has programmatic meaning

def update_char(timeval, name, level=None, vocation=None, guild=None, online=None):
    dbConn.execute("insert into player (name, level, guild, vocation) values (?, ?, ?, ?);", (name, level, guild, vocation))
    if online != None:

    dbConn.commit()

def get_char(name):
    curs = dbConn.execute("select * from player where name=?;", (name,))
    row = curs.fetchone()
    assert curs.fetchone() == None
    return row

def list_guilds():
    for row in dbConn.execute("select guild from player group by guild;").fetchall():
        yield row["guild"]
