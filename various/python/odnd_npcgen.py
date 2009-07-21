#!/usr/bin/env python

import collections
import random

def roll(dice, sides, drop=0):
    values = []
    for a in xrange(dice):
        values.append(random.randint(1, sides))
    return sum(sorted(values)[drop:])

class AbilityScore(object):
    @property
    def value(self):
        return self._value
    @value.setter
    def value(self, value):
        self._value = value
    @property
    def modifier(self):
        assert self._value >= 3 and self._value <= 18
        retval = -3
        starts = [4, 6, 9, 13, 16, 18]
        for s in starts:
            if self._value >= s:
                retval += 1
            else:
                return retval

AbilityScores = collections.namedtuple('AbilityScores', ['str', 'int', 'wis', 'dex', 'con', 'cha'])

class AbilityScores:
    ABILITIES = ('str', 'int', 'wis', 'dex', 'con', 'cha')
    def __init__(self):
        for a in self.ABILITIES:
            setattr(self, a, AbilityScore())
    def roll(self, dice=3, drop=0):
        for a in self.ABILITIES:
            import pdb
            #pdb.set_trace()
            getattr(self, a).value = roll(dice, 6, drop)
    def __repr__(self):
        return ', '.join([a + '=' + str(getattr(self, a).value) for a in self.ABILITIES])
    def __str__(self):
        rv = []
        for a in self.ABILITIES:
            fmt = "%s: %2d"
            vals = [a.capitalize(), getattr(self, a).value]
            modifier = getattr(self, a).modifier
            if modifier:
                fmt += " (%+d)"
                vals.append(modifier)
            rv.append(fmt % tuple(vals))
        return "\n".join(rv)

class Character:
    def __init__(self):
        self.abilities = AbilityScores()
        #self.class_ =
    def __repr__(self):
        return repr(self.abilities)
    def roll_ability_scores(self, dice=3, drop=0):
        self.abilities.roll(dice, drop)
    def __str__(self):
        return str(self.abilities)

npc = Character()
npc.roll_ability_scores(4, 1)

#print npc

Dice = collections.namedtuple("Dice", ["count", "sides"])

class Roll(object):
    def __init__(self, dice, bonus=0):
        self.dice = dice
        self.bonus = bonus
    def __call__(self):
        retval = self.bonus
        for d in self.dice:
            retval += roll(d.count, d.sides)
        if retval < 1: retval = 1
        return retval

class Fighter(object):
    def __init__(self, name, thac0, maxhp, armor, attacks):
        self.name = name
        self.thac0 = thac0
        self.maxhp = maxhp
        self.curhp = maxhp
        self.armor = armor
        self.attacks = attacks
    def deal_damage(self, damage):
        self.curhp -= damage
    def is_alive(self):
        return self.curhp > 0
    def __str__(self):
        return "%s: HP %d (%d)" % (self.name, self.curhp, self.maxhp)
    def full_heal(self):
        self.curhp = self.maxhp

def all_attacks(attacker, defender):
    for a in attacker.attacks:
        print attacker.name + ":",
        attack_roll = random.randint(1, 20)
        hit_required = min(attacker.thac0 - defender.armor, 20)
        print attack_roll, "(needs", str(attacker.thac0 - defender.armor) + ")",
        if attack_roll >= hit_required:
            damage = a()
            print "deals", damage
            defender.deal_damage(damage)
            print defender
        else:
            print "misses"

def duel(f1, f2):
    f1.full_heal()
    f2.full_heal()
    while True:
        if not f1.is_alive() or not f2.is_alive(): break
        all_attacks(f1, f2)
        if not f1.is_alive() or not f2.is_alive(): break
        all_attacks(f2, f1)
    if f1.is_alive() and not f2.is_alive(): return f1.name
    elif f2.is_alive() and not f1.is_alive(): return f2.name
    else: assert False

hero = Fighter("hero", 17, 10, 1, [Roll([Dice(1, 8)], 2)])
ogre = Fighter("ogre", 16, 19, 4, [Roll([Dice(1, 10)])])
orc = Fighter("orc", 19, 5, 6, [Roll([Dice(1, 8)])])

win_count = {}
for i in xrange(1000):
    winner = duel(*((hero, ogre), (ogre, hero))[i % 2])
    win_count[winner] = win_count.get(winner, 0) + 1

print win_count
