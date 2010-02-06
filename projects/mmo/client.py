#!/usr/bin/env python

import logging
import operator
import pdb
import pygame
import socket
import time

from common import *

logging.basicConfig(level=logging.DEBUG)

GRIDDIM = (64, 64)

logging.info("Pygame version: %s" % pygame.version.ver)

def create_player_surface(color):
    surface = pygame.Surface(GRIDDIM)
    surface.set_colorkey((0, 0, 0))
    rect = surface.get_rect()
    rect.width *= 0.8
    rect.center = surface.get_rect().center
    #color = (0xd0, 0xa0, 0xa0) # pink?
    pygame.draw.ellipse(surface, color, rect, 0)
    return surface

class Player(object):
    def __init__(self, coords, color):
        self.surface = create_player_surface(color)
        self.coords = Coords(*coords)
        self.moveDir = None
        self.moveWait = False
    def move_direction(self, dir):
        if self.moveDir == None:
            self.moveDir = dir
            self.moveWait = False
    def moved(self, newpos):
        self.coords = Coords(*newpos)
        self.moveWait = False
        self.moveDir = None

class Client(object):
    MOVE_KEYS = {
            pygame.K_LEFT: 'west',
            pygame.K_RIGHT: 'east',
            pygame.K_UP: 'north',
            pygame.K_DOWN: 'south',}
    def redraw(self):
        def draw_entity(entity):
            dest = entity.surface.get_rect()
            #pdb.set_trace()
            shiftedEntityCoords = map(lambda x: x + 0.5, entity.coords)
            dest.center = map(operator.mul, GRIDDIM, shiftedEntityCoords)
            self.screen.blit(entity.surface, dest)
        self.screen.fill((0, 0xa0, 0))
        draw_entity(self.player)
        pygame.display.flip()
    def events(self):
        while True:
            event = pygame.event.poll()
            if event.type == pygame.NOEVENT:
                return
            logging.debug("Pygame event: %s" % event)
            if event.type == pygame.QUIT:
                self.running = False
                return
            elif event.type == pygame.KEYDOWN:
                try:
                    direction = self.MOVE_KEYS[event.key]
                except KeyError:
                    continue
                self.player.move_direction(direction)
    def checkkeys(self):
        keystate = pygame.key.get_pressed()
        # prevent direction conflicts
        finaldir = None
        for key, dir in self.MOVE_KEYS.iteritems():
            if keystate[key]:
                if finaldir == None:
                    finaldir = dir
                else:
                    # more than one direction requested, do none
                    finaldir = None
                    break
        self.player.move_direction(finaldir)
    def display_login(self, text):
        logintext = pygame.font.SysFont(None, 36, bold=True).render(text, True, (255, 255, 255))
        dest = logintext.get_rect()
        dest.center = self.screen.get_rect().center
        self.screen.fill((0, 0, 0))
        self.screen.blit(logintext, dest)
        pygame.display.flip()
    def login(self):
        self.display_login("Connecting...")
        self.buffer = ""
        try:
            s = socket.create_connection(('localhost', 7172))
        except socket.error:
            raise Disconnected()
        self.msgbuf = SocketMessageBuffer(s)
        self.display_login("Logging in...")
        while True:
            self.msgbuf.recv()
            message = self.msgbuf.get_message()
            if message:
                break
        assert message.title == 'loggedin', message.title
        self.player = Player(**message.data)
        self.display_login("Starting...")
        self.run()
    def init(self):
        pygame.display.init()
        pygame.font.init()
        pygame.event.set_blocked(pygame.MOUSEMOTION)
        self.screen = pygame.display.set_mode(map(operator.mul, GRIDDIM, (15, 11)))
        logging.info("Display driver: %s" % pygame.display.get_driver())
        #self.player = Player()
        self.running = True
    def quit(self):
        self.running = False
    def uninit(self):
        pygame.display.quit()
    def run(self):
        while True:
            self.events()
            if not self.running:
                return
            self.checkkeys()
            self.network()
            self.redraw()
    def disconnected(self):
        self.display_login("Disconnected!")
    def process_messages(self):
        while True:
            msg = self.msgbuf.get_message()
            if not msg:
                break
            logging.debug("Received message: %s" % str(msg))
            if msg.title == 'moved':
                self.player.moved(msg.data['coords'])
    def network(self):
        if not self.player.moveWait and self.player.moveDir != None:
            self.msgbuf.post_message("move", direction=self.player.moveDir)
            self.player.moveWait = True
        #pdb.set_trace()
        self.msgbuf.flush()
        self.process_messages()

    def start(self):
        self.init()
        while True:
            try:
                self.login()
            except Disconnected:
                self.disconnected()
                time.sleep(3.0)
                break
            else:
                break
        self.uninit()

if __name__ == "__main__":
    Client().start()
