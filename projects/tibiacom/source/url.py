import urllib, urlparse

def _make_url(path, query):
    return urlparse.urlunsplit((
            "http",
            "www.tibia.com",
            path,
            urllib.urlencode(query),
            None),)

def char_page(name):
    return _make_url("/community/", {"subtopic": "characters", "name": name})

def world_guilds(world):
    return _make_url("/community/", {"subtopic": "guilds", "world": world})

def guild_members(guild):
    return _make_url("/community/", {"subtopic": "guilds", "page": "view", "GuildName": guild})

def world_online(world):
    return _make_url("/community/", {"subtopic": "whoisonline", "world": world})
