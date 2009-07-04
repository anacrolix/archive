#!/usr/bin/env python

import math
import os
import pygame
import random
import unittest

sounds = {}
images = {}

def load_sounds():
    for k, f in (
                ("mg6", "Machine_Gun3.wav"),
                ("boom-whistle", "explosion6.wav"),
                ("bomb", "bomb.wav"),
                ("bomb-reverb", "boom.aiff"),
            ):
        sounds[k] = pygame.mixer.Sound(os.path.join("sounds", f))

def load_images():
    for k, f, ck in (
                ("bunker", "Bunker.png", (0, 0, 0)),
                ("barrels", "barrel.png", None),
            ):
        surface = pygame.image.load(os.path.join("images", f)).convert()
        if not ck is None: surface.set_colorkey(ck)
        images[k] = surface

class Vector:
    __slots__ = ('x', 'y')
    def __init__(self, cartesian=None, polar=None):
        assert bool(cartesian) ^ bool(polar)
        if cartesian:
            self.x, self.y = cartesian
        elif polar:
            self.x, self.y = tuple([polar[0] * f(polar[1]) for f in (math.cos, math.sin)])
    def __rmul__(self, other):
        return self.__class__((self.x * other, self.y * other))
    __mul__ = __rmul__
    def __add__(self, other):
        return self.__class__((self.x + other.x, self.y + other.y))
    def __iter__(self):
        yield self.x
        yield self.y
    def __repr__(self):
        return repr((self.x, self.y))

FRAMERATE = 30
GRAVITY = (0.0, 200.0)
DT = 1.0 / FRAMERATE

class Particle:
    def __init__(self, x, v, a=None):
        if a is None: a = Vector(GRAVITY)
        for l in ('x', 'v', 'a'):
            vec = locals()[l]
            setattr(self, l, vec if isinstance(vec, Vector) else Vector(vec))
    def step(self):
        vdt = DT * self.v
        hadt2 = 0.5 * self.a * (DT ** 2)
        self.x += vdt + hadt2
        self.v += self.a * DT
    def pixel_pos(self):
        return tuple([int(round(a, 0)) for a in self.x])
    def __repr__(self):
        return "<%s x=%s, v=%s, a=%s>" % (self.__class__.__name__, self.x, self.v, self.a)

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
    def __init__(self, particle):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((2, 2))
        self.image.fill((150, 150, 150))
        self.rect = self.image.get_rect()
        self.particle = particle
    def update(self):
        self.particle.step()
        print self.particle
        print self.particle.pixel_pos()
        self.rect.center = self.particle.pixel_pos()
        # simple cull
        if self.rect.top >= pygame.display.get_surface().get_size()[1]:
            self.kill()

class Bunker(pygame.sprite.Sprite):
    def __init__(self, framerate):
        pygame.sprite.Sprite.__init__(self)
        self.framerate = framerate
        self.image = images["bunker"]
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
            self.groups()[0].add(Bullet(Particle(self.rect.midtop, Vector(polar=(500.0, angle)))))
            self.fire_nexttick += 1000 * self.fire_sound.get_length() / 6
        #if self.firing:


def main(debug):
    try:
        os.environ['SDL_VIDEO_CENTERED'] = '1'
        print "pygame version:", pygame.version.ver
        pygame.display.init()
        pygame.font.init()
        pygame.mixer.init()
        pygame.display.set_caption("Parashoot 2")
        screen = pygame.display.set_mode((1024, 768))
        load_sounds()
        load_images()
        background = pygame.Surface(screen.get_size())
        background.fill((0, 0, 200))
        screen.blit(background, (0, 0))
        pygame.display.flip()

        clock = pygame.time.Clock()
        playergun = Bunker(20)
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
