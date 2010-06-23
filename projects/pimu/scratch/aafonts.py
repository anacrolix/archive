#!/usr/bin/env python

import pygame

screen = pygame.display.set_mode((400, 300))
screen.fill((0xff, 0xff, 0))
#screen.set_colorkey((0xff, 0, 0xff))
pygame.font.init()
font = pygame.font.SysFont("Arial", 24, bold=True)
surface = font.render("Hello world!", False, (0, 0xff, 0))
dest = surface.get_rect()
dest.center = screen.get_rect().center
screen.blit(surface, dest)
pygame.display.flip()
while True:
	event = pygame.event.wait()
	if event.type == pygame.QUIT:
		break
