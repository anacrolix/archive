#!/usr/bin/env python

import math
import os
import pygame
import random

sounds = {}

class FpsText(pygame.sprite.Sprite):
    def __init__(self, get_fps):
        super(FpsText, self).__init__()
        self.font = pygame.font.SysFont(None, 36)
        self.get_fps = get_fps
    def update(self):
        self.image = self.font.render(str(self.get_fps()) + " fps", True, (255, 255, 255))
        self.rect = (0, 0)

class Explosion(pygame.sprite.Sprite):
    def __init__(self, pos, radius=80, spikes=None):
        if spikes is None: spikes = random.randint(5, 12)
        super(Explosion, self).__init__()
        self.image = pygame.Surface((radius * 2, radius * 2))
        self.image.set_colorkey((0, 0, 0))
        self.rect = self.image.get_rect()
        self.rect.center = pos
        outer_points = []
        inner_points = []
        for i in range(spikes * 2):
            angle = (float(i) / float(spikes * 2)) * (2 * math.pi)
            inny = bool(i % 2)
            subrad = radius * random.uniform(*((0.2, 0.5) if inny else (0.7, 1)))
            outer_points.append(tuple([f(angle) * subrad + radius for f in (math.cos, math.sin)]))
            inner_points.append(tuple([f(angle) * (subrad * random.gauss(0.5, 0.1)) + radius for f in (math.cos, math.sin)]))
        pygame.draw.polygon(self.image, (255, 0, 0), outer_points)
        pygame.draw.polygon(self.image, (255, 255, 0), inner_points)
        self.image.set_alpha(240)
        sounds[sounds.keys()[random.randint(0, len(sounds) - 1)]].play()
    def update(self):
        alpha = self.image.get_alpha() - 16
        if alpha <= 0: self.kill()
        self.image.set_alpha(alpha)

def load_sounds():
    for k, f in (
                ("boom-whistle", "explosion6.wav"),
                ("bomb", "bomb.wav"),
                ("bomb-reverb", "boom.aiff"),
            ):
        sounds[k] = pygame.mixer.Sound(os.path.join("sounds", f))

def main():
    try:
        os.environ['SDL_VIDEO_CENTERED'] = '1'
        print "pygame version:", pygame.version.ver
        pygame.display.init()
        pygame.font.init()
        pygame.mixer.init(44100, -16, 2, 512)
        load_sounds()
        pygame.display.set_caption("Parashoot 2")
        screen = pygame.display.set_mode((640,480))
        background = pygame.Surface(screen.get_size())
        background.fill((0, 0, 200))
        screen.blit(background, (0, 0))
        pygame.display.flip()

        clock = pygame.time.Clock()
        text = FpsText(clock.get_fps)
        sprites = pygame.sprite.Group(text)
        del text
        while True:
            print "last frame took:", clock.tick(20), "ms"
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return
                if event.type == pygame.MOUSEBUTTONDOWN:
                    sprites.add(Explosion(event.pos))
            sprites.update()
            screen.blit(background, (0, 0))
            sprites.draw(screen)
            pygame.display.flip()
    finally:
        pygame.quit()

if __name__ == "__main__": main()
