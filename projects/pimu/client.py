#!/usr/bin/env python

import logging, operator, pdb, socket, string, sys
import pygame
from common import *

GRIDDIM = (48, 48)
framerate = 30

def entity_surface(entity):
	# base entity surface is 3x3 tiles
	# source alpha for font anti-aliasing
	surface = pygame.Surface(tuple(3 * a for a in GRIDDIM), pygame.SRCALPHA)
	# draw the player
	rect = pygame.Rect((0, 0), GRIDDIM)
	rect.width *= 0.8
	rect.center = surface.get_rect().center
	pygame.draw.ellipse(surface, entity.color, rect, 0)
	# draw the id on his shirt for now
	idsurf = viewfont.render(str(entity.id), True, [0xff - a for a in entity.color])
	rect = idsurf.get_rect()
	rect.center = surface.get_rect().center
	surface.blit(idsurf, rect)
	# draw the health bar, 3 pixels height
	rect.width = GRIDDIM[0] * 0.6 * entity.health # hp level tbd
	rect.height = 3
	rect.midbottom = (GRIDDIM[0] * 1.5, GRIDDIM[1])
	for cutoff, color in [
			(0.7, (0, 0xff, 0)),
			(0.3, (0xff, 0xff, 0)),
			(0, (0xff, 0, 0))]:
		if entity.health >= cutoff:
			break
	pygame.draw.line(surface, color, rect.midleft, rect.midright, 2)
	# draw the name
	namesurf = viewfont.render(entity.name, True, color)
	rect = namesurf.get_rect()
	rect.midbottom = (GRIDDIM[0] * 1.5, GRIDDIM[1])
	surface.blit(namesurf, rect)
	return surface

def get_option(optstr, default=None):
	try:
		index = sys.argv.index(optstr)
	except ValueError:
		return default
	else:
		return sys.argv[index + 1]

def main():
	logging.basicConfig(level=logging.DEBUG)
	logging.info("Pygame version: %s" % pygame.version.ver)
	pygame.display.init()
	logging.info("Display driver: {0}".format(pygame.display.get_driver()))
	pygame.font.init()
	global viewfont
	viewfont = pygame.font.SysFont("Arial", 12, bold=True)
	pygame.event.set_blocked([pygame.MOUSEMOTION, pygame.ACTIVEEVENT])
	logging.info("Connecting")
	gamehost = get_option("servhost", "localhost")
	somsgbuf = SocketMessageBuffer(socket.create_connection((gamehost, 7172)))
	logging.info("Logging in")
	somsgbuf.post_message("login", name=get_option("charname"))
	while somsgbuf.pending_out():
		somsgbuf.send_pending()
	while somsgbuf.receive_more():
		message = somsgbuf.get_message()
		if message is not None:
			break
	logging.debug("First message: %s", message)
	assert message.title == "loggedin"
	#plyrent = message.kwdata["entity"]
	playerid = message.kwdata["id"]
	mapdata = message.kwdata["startmap"]
	entities = {}
	chathist = []
	curchat = u""
	chatfont = pygame.font.SysFont("Arial", 12, bold=True)
	screen = pygame.display.set_mode((
			VIEWPORT_DIMENSIONS[0] * GRIDDIM[0],
			VIEWPORT_DIMENSIONS[1] * GRIDDIM[1] + 11 * chatfont.get_linesize()))
	screen.set_colorkey((0xff, 0, 0xff))
	logging.info("Session started")
	clock = pygame.time.Clock()
	MOVE_KEYS = {
			pygame.K_LEFT: 'west',
			pygame.K_RIGHT: 'east',
			pygame.K_UP: 'north',
			pygame.K_DOWN: 'south',}
	while True:
		while True:
			event = pygame.event.poll()
			if event.type == pygame.NOEVENT:
				break
			logging.debug("Pygame event: %s" % event)
			if event.type == pygame.QUIT:
				raise SystemExit()
			elif event.type == pygame.KEYDOWN:
				try:
					direction = MOVE_KEYS[event.key]
				except KeyError:
					if event.key in [pygame.K_RETURN]:
						if len(curchat) > 0:
							somsgbuf.post_message("say", curchat)
						curchat = u""
					elif event.key is pygame.K_BACKSPACE:
						curchat = curchat[:-1]
					elif event.unicode in string.printable:
						curchat += event.unicode
				else:
					somsgbuf.post_message("move", direction=direction)
		somsgbuf.flush()
		while True:
			message = somsgbuf.get_message()
			if message is None:
				break
			logging.debug("Received message: %s", message)
			if message.title == 'entity':
				entity = message.kwdata["entity"]
				entities[entity.id] = entity
			elif message.title == "chat":
				chathist.append(message.pdata[0])
			elif message.title == "remove_entity":
				del entities[message.kwdata["id"]]
			else:
				logging.warning("Unknown message: %s", message)
		#pdb.set_trace()
		screen.fill((0x30, 0x30, 0x30))
		#pygame.draw.rect(screen, (0, 0xa0, 0), pygame.Rect((0, 0), map(operator.mul, GRIDDIM, VIEWPORT_DIMENSIONS)))
		plyrpos = entities[playerid].coords
		#pdb.set_trace()
		viewtop = plyrpos.y - (VIEWPORT_DIMENSIONS[1] - 1) / 2
		viewleft = plyrpos.x - (VIEWPORT_DIMENSIONS[0] - 1) / 2
		for y in xrange(viewtop, viewtop + VIEWPORT_DIMENSIONS[1]):
			for x in xrange(viewleft, viewleft + VIEWPORT_DIMENSIONS[0]):
				pygame.draw.rect(screen, mapdata[x, y].get_color(), pygame.Rect(map(operator.mul, (x - viewleft, y - viewtop), GRIDDIM), GRIDDIM))
		for ent in entities.values():
			entsurf = entity_surface(ent)
			dest = entsurf.get_rect()
			viewpos = ent.coords - (viewleft, viewtop)
			dest.center = tuple(a * (b + 0.5) for a, b in zip(GRIDDIM, viewpos))
			screen.blit(entsurf, dest)
		rect = pygame.Rect(
				(0, screen.get_height() - 2 * chatfont.get_linesize()),
				(screen.get_width(), chatfont.get_linesize()))
		for chatmsg in reversed(chathist):
			if rect.top < VIEWPORT_DIMENSIONS[1] * GRIDDIM[1]:
				break
			msgsurf = chatfont.render(chatmsg, True, (0xff, 0xff, 0x0))
			screen.blit(msgsurf, rect)
			rect.top -= chatfont.get_linesize()
		chatsurf = chatfont.render(curchat, True, (0xff, 0xff, 0))
		screen.blit(chatsurf, (0, screen.get_height() - chatsurf.get_height()))
		pygame.display.flip()
		frametime = clock.tick(framerate)
		if frametime <= 20:
			logging.debug("Milliseconds since last frame: %i", frametime)

if __name__ == "__main__":
	main()


	#def login(self):
		#self.display_login("Connecting...")
		#try:
			#s = socket.create_connection(('localhost', 7172))
		#except socket.error:
			#raise Disconnected()
		#self.msgbuf = SocketMessageBuffer(s)
		#self.display_login("Logging in...")
		#while True:
			#self.msgbuf.recv()
			#message = self.msgbuf.get_message()
			#if message:
				#break
		#assert message.title == 'loggedin', message.title
		#self.player = Player(**message.data)
		#self.display_login("Starting...")
		#MainGame(self, Player(**message.data))()

#def create_player_surface(color):
	#surface = pygame.Surface(GRIDDIM)
	#surface.set_colorkey((0, 0, 0))
	#rect = surface.get_rect()
	#rect.width *= 0.8
	#rect.center = surface.get_rect().center
	##color = (0xd0, 0xa0, 0xa0) # pink?
	#pygame.draw.ellipse(surface, color, rect, 0)
	#return surface

#class Player(object):
	#def __init__(self, coords, color):
		#self.surface = create_player_surface(color)
		#self.coords = Coords(*coords)
		#self.moveDir = None
		#self.moveWait = False
	#def move_direction(self, dir):
		#if self.moveDir == None:
			#self.moveDir = dir
			#self.moveWait = False
	#def moved(self, newpos):
		#self.coords = Coords(*newpos)
		#self.moveWait = False
		#self.moveDir = None

#class MainGame(object):

	#MOVE_KEYS = {
			#pygame.K_LEFT: 'west',
			#pygame.K_RIGHT: 'east',
			#pygame.K_UP: 'north',
			#pygame.K_DOWN: 'south',}

	#def __init__(self, client, player):
		#self.client = client
		#self.player = player

	#def __call__(self):
		#entities = {}
		#while True:
			#self.events()
			#self.checkkeys()
			#self.network()
			#self.redraw()

	#def events(self):
		#while True:
			#event = pygame.event.poll()
			#if event.type == pygame.NOEVENT:
				#break
			#logging.debug("Pygame event: %s" % event)
			#if event.type == pygame.QUIT:
				#raise SystemExit()
			#elif event.type == pygame.KEYDOWN:
				#try:
					#direction = self.MOVE_KEYS[event.key]
				#except KeyError:
					#continue
				#self.player.move_direction(direction)

	#def redraw(self):
		#def draw_entity(entity):
			#dest = entity.surface.get_rect()
			##pdb.set_trace()
			#shiftedEntityCoords = map(lambda x: x + 0.5, entity.coords)
			#dest.center = map(operator.mul, GRIDDIM, shiftedEntityCoords)
			#self.screen.blit(entity.surface, dest)
		#self.screen.fill((0, 0xa0, 0))
		#draw_entity(self.player)
		#pygame.display.flip()

	#def network(self):
		#if not self.player.moveWait and self.player.moveDir != None:
			#self.msgbuf.post_message("move", direction=self.player.moveDir)
			#self.player.moveWait = True
		##pdb.set_trace()
		#self.msgbuf.flush()
		#self.process_messages()

	#def checkkeys(self):
		#keystate = pygame.key.get_pressed()
		## prevent direction conflicts
		#finaldir = None
		#for key, dir in self.MOVE_KEYS.iteritems():
			#if keystate[key]:
				#if finaldir == None:
					#finaldir = dir
				#else:
					## more than one direction requested, do none
					#finaldir = None
					#break
		#self.player.move_direction(finaldir)

#class Client(object):

	#def display_login(self, text):
		#logintext = pygame.font.SysFont(None, 36, bold=True).render(text, True, (255, 255, 255))
		#dest = logintext.get_rect()
		#dest.center = self.screen.get_rect().center
		#self.screen.fill((0, 0, 0))
		#self.screen.blit(logintext, dest)
		#pygame.display.flip()


	#def __init__(self):
		#pygame.display.init()
		#pygame.font.init()
		#pygame.event.set_blocked(pygame.MOUSEMOTION)
		#logging.info("Display driver: {0}".format(pygame.display.get_driver()))
		#self.screen = pygame.display.set_mode(map(operator.mul, GRIDDIM, (15, 11)))

	#def quit(self):
		#self.running = False

	#def uninit(self):
		#pygame.display.quit()

	#def disconnected(self):
		#self.display_login("Disconnected!")

	#def process_messages(self):
		#while True:
			#msg = self.msgbuf.get_message()
			#if msg is None:
				#break
			#logging.debug("Received message: %s" % str(msg))
			#if msg.title == 'moved':
				#self.player.moved(msg.data['coords'])
			#elif msg.title == 'entity':
				#entity = eval(msg.data["eval"])
				#self.entities[entity.get_entity_id()] = entity


	#def __call__(self):
		#while True:
			#try:
				#self.login()
			#except Disconnected:
				#self.disconnected()
				#time.sleep(3.0)
				#break
			#else:
				#break
		#self.uninit()

#def main():
	#logging.basicConfig(level=logging.DEBUG)
	#logging.info("Pygame version: %s" % pygame.version.ver)
	#Client()()

#if __name__ == "__main__":
	#main()
