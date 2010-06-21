#!/usr/bin/env python

from __future__ import division
import itertools, logging, pdb, select, socket
from enum import enum
from common import *

class ServerEntity(Entity):
	__slots__ = "curhp", "maxhp"
	@property
	def health(self):
		return self.curhp / self.maxhp

class Player(ServerEntity):
	State = enum("LOGGING_IN", "ACTIVE")
	def __init__(self, opensock):
		ServerEntity.__init__(self)
		self.__somsgbuf = SocketMessageBuffer(opensock)
		self.state = self.State.LOGGING_IN
	def socket_fileno(self):
		return self.__somsgbuf.fileno()
	def needs_writing(self):
		return self.__somsgbuf.pending_out()
	def read_incoming(self):
		return self.__somsgbuf.receive_more()
	def write_outgoing(self):
		return self.__somsgbuf.send_pending()
	def get_message(self):
		return self.__somsgbuf.get_message()
	def post_message(self, title, *pargs, **kwargs):
		return self.__somsgbuf.post_message(title, *pargs, **kwargs)
	def setattr(self, key, value):
		print key, value
		assert False
	def get_remote_address(self):
		return self.__somsgbuf.get_socket().getpeername()

class Monster(ServerEntity):
	def __init__(self):
		ServerEntity.__init__(self)
		self.speed = 500
		self.maxhp = 50
		self.curhp = 50
		self.coords=Coords(x=9, y=1)
		self.name="Goblin"
		self.id = entidgen.next()
		self.color = (random.randint(0, 0xff), 0, 0x40)

def create_server_socket():
	servsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	servsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	servsock.bind(('', 7172))
	servsock.listen(socket.SOMAXCONN)
	logging.info("Listening on %s", servsock.getsockname())
	return servsock

def receive_player_data(player):
	try:
		player.read_incoming()
	except SocketClosed:
		logging.info("Disconnected %s", player.get_remote_address())
		players.remove(player)
		for plyr in players:
			plyr.somsgbuf.post_message("remove_entity", id=player.id)
		return
	message = player.get_message()
	if message is None:
		return
	logging.debug("Received message: %s", message)
	if message.title == "move":
		newpos = player.coords
		newpos += DIRECTIONS[message.kwdata["direction"]]
		if position_walkable(newpos):
			player.coords = newpos
			for plyr in players:
				plyr.post_message("entity", entity=player)
	elif message.title == "say":
		fullmsg = "{0}: {1}".format(player.name or player.id, message.pdata[0])
		for player in players:
			player.post_message("chat", fullmsg)
	elif message.title == "login":
		assert player.state == Player.State.LOGGING_IN
		# decide where to place the new guy
		while True:
			y, xdata = random.choice(world.get_data().items())
			x = random.choice(xdata.keys())
			if position_walkable((x, y)):
				break
		player.coords = Coords(x, y)
		player.name = message.kwdata["name"]
		player.id = entidgen.next()
		player.curhp = 60
		player.maxhp = 100
		#player.health = 0.6
		player.color = (0x40, 0, random.randint(0, 0xff))
		player.post_message("loggedin", id=player.id, startmap=world)
		player.state = player.State.ACTIVE
		for plyr in players:
			player.post_message("entity", entity=plyr)
			if plyr != player:
				plyr.post_message("entity", entity=player)
		for mons in monsters:
			player.post_message("entity", entity=mons)
	else:
		logging.warning("Unknown message: %s", message)

def closest_player(coords):
	closest = None
	for player in players:
		if player.state != player.State.ACTIVE:
			continue
		distance = sum((a - b) ** 2 for a, b in zip(coords, player.coords))
		if closest is None or distance < mindist:
			closest = [player]
			mindist = distance
		elif distance == mindist:
			closest.append(player)
		else:
			assert distance > mindist
	if closest is None:
		return None
	else:
		return random.choice(closest)

def active_players():
	return filter(lambda a: a.state == a.State.ACTIVE, players)

def position_walkable(coords):
	if not world[coords].walkable():
		return False
	for entity in itertools.chain(active_players(), monsters):
		if entity.coords == coords:
			return False
	return True

def do_monster_actions():
	for monster in monsters:
		target = closest_player(monster.coords)
		if target is None:
			continue
		relcoord = target.coords - monster.coords
		if abs(relcoord.y) > abs(relcoord.x):
			relcoord.x = 0
			relcoord.y //= abs(relcoord.y)
		else:
			relcoord.y = 0
			relcoord.x //= abs(relcoord.x)
		newcoord = monster.coords + relcoord
		if position_walkable(newcoord):
			monster.coords = newcoord
			for player in players:
				player.post_message("entity", entity=monster)

def accept_new_player():
	logging.debug("Incoming connection")
	newsock, remaddr = servsock.accept()
	logging.info("Accepted connection from %s", remaddr)
	newplyr = Player(newsock)
	players.append(newplyr)

def initialize_server():
	logging.basicConfig(level=logging.DEBUG)
	global players, monsters, entidgen, world, servsock
	servsock = create_server_socket()
	players = []
	entidgen = itertools.count(1)
	monsters = [Monster()]
	world = World()
	world.from_file()

def main():
	initialize_server()
	while True:
		socksout = []
		socksin = [servsock]
		fno2plyr = NoDupDict()
		for player in players:
			plyrfnum = player.socket_fileno()
			fno2plyr[plyrfnum] = player
			if player.needs_writing():
				socksout.append(plyrfnum)
			socksin.append(plyrfnum)
		readyfds = select.select(socksin, socksout, [], 0.1)
		for readrdy in readyfds[0]:
			if readrdy == servsock:
				accept_new_player()
			else:
				receive_player_data(fno2plyr[readrdy])
		for writerdy in readyfds[1]:
			fno2plyr[writerdy].write_outgoing()
		do_monster_actions()

if __name__ == "__main__":
	main()
