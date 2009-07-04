#!/usr/bin/env python

import math
import os
import pygame
import random
import unittest

sounds = {}

#class Screen:
    #def __init__(self, height):
        #self.height

#class Coord():
    #def __init__(self, screen, position=(0, 0)):
        #self.screen = screen
        #self.x = position[0]
        #self.y = position[1]
    #def screen_pos(self):
        #return (self.x, self.screen.height - self.y)

class FpsText(pygame.sprite.Sprite):
    def __init__(self, get_fps):
        super(FpsText, self).__init__()
        self.font = pygame.font.SysFont(None, 36)
        self.get_fps = get_fps
    def update(self):
        self.image = self.font.render("{0:.2f} fps".format(self.get_fps()), True, (255, 255, 255))
        self.rect = (0, 0)

class TestExplosion(unittest.TestCase):
    def test_rand_spikes(self):
        min = Explosion.MIN_SPIKES
        max = Explosion.MAX_SPIKES
        mode = Explosion.SPIKES_MODE
        counts = dict([(i, 0) for i in xrange(min, max + 1)])
        try:
            while True:
                r = Explosion.rand_spikes()
                assert r in xrange(min, max + 1)
                counts[r] += 1
                for i in xrange(min, max + 1):
                    if not counts[i] > 0: break
                else:
                    break
        finally:
            print counts

class Explosion(pygame.sprite.Sprite):
    MIN_SPIKES = 5
    MAX_SPIKES = 12
    SPIKES_MODE = 6
    @classmethod
    def rand_spikes(cls):
        return int(random.triangular(cls.MIN_SPIKES, cls.MAX_SPIKES + 1, cls.SPIKES_MODE))
    def __init__(self, pos, radius=80, spikes=None):
        if spikes is None: spikes = self.rand_spikes()
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

class Bullet(pygame.sprite.Sprite):
    def __init__(self, pos, vel):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((2, 2))
        self.image.fill((150, 150, 150))
        self.rect = self.image.get_rect()
        self.pos = list(pos)
        self.vel = list(vel)
    def update(self):
        self.pos = tuple([self.pos[i] + self.vel[i] for i in range(2)])
        print self.pos
        self.vel[1] += 0.1
        self.rect.center = (round(self.pos[0], 0), round(self.pos[1], 0))

class PlayerGun(pygame.sprite.Sprite):
    def __init__(self, framerate):
        pygame.sprite.Sprite.__init__(self)
        self.framerate = framerate
        self.image = pygame.Surface((60, 60))
        self.rect = self.image.get_rect()
        size = pygame.display.get_surface().get_size()
        self.rect.centerx = size[0] / 2
        self.rect.bottom = size[1]
        self.firing = False
    def fire(self):
        if self.firing: return
        self.firing = True
        self.fire_sound = sounds["mg6"]
        self.fire_channel = self.fire_sound.play()
        self.fire_nexttick = pygame.time.get_ticks() #+ 1000 * self.fire_sound.get_length() / 6
    def update(self):
        if self.firing and not self.fire_channel.get_busy(): self.firing = False
        if self.firing and pygame.time.get_ticks() >= self.fire_nexttick:
            print "fire shell"

            angle = math.atan2(
                    pygame.mouse.get_pos()[1] - self.rect.top,
                    pygame.mouse.get_pos()[0] - self.rect.centerx)
            self.groups()[0].add(Bullet(self.rect.midtop, (10 * math.cos(angle), 10 * math.sin(angle))))
            self.fire_nexttick += 1000 * self.fire_sound.get_length() / 6
        #if self.firing:


def load_sounds():
    for k, f in (
                ("mg6", "Machine_Gun3.wav"),
                ("boom-whistle", "explosion6.wav"),
                ("bomb", "bomb.wav"),
                ("bomb-reverb", "boom.aiff"),
            ):
        sounds[k] = pygame.mixer.Sound(os.path.join("sounds", f))

def main(debug):
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
        playergun = PlayerGun(20)
        sprites = pygame.sprite.Group(playergun)
        if debug: sprites.add(FpsText(clock.get_fps))
        while True:
            print "last frame took:", clock.tick(30), "ms"
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    return
                elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 3:
                    sprites.add(Explosion(event.pos))
            sprites.update()
            if pygame.mouse.get_pressed()[0]:
                playergun.fire()
            screen.blit(background, (0, 0))
            sprites.draw(screen)
            pygame.display.flip()
    finally:
        pygame.quit()

def test(args):
    import sys
    unittest.main(argv=[sys.argv[0]] + args)

if __name__ == "__main__":
    from optparse import OptionParser
    parser = OptionParser(
            prog="ParaShoot2",
            description="Python/SDL rewrite of ParaShoot which was in Java.",
        )
    parser.set_defaults(test=False, debug=False)
    parser.add_option("-t", "--test", action="store_true", dest="test")
    parser.add_option("-d", "--debug", action="store_true", dest="debug")
    options, args = parser.parse_args()
    if options.test:
        test(args)
    else:
        if len(args) != 0:
            parser.print_help()
            parser.exit(2)
        main(options.debug)
