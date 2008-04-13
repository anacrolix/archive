#!/usr/bin/env python

from visual import *
from random import random
from math import sqrt

global printed_header

def init_mols():
	for x in range(mols_per_side):
		xpos = side_len * x / (mols_per_side - 1) - side_len / 2
		for y in range(mols_per_side):
			ypos = side_len * y / (mols_per_side - 1) - side_len / 2
			for z in range(mols_per_side):
				zpos = side_len * z / (mols_per_side - 1) - side_len / 2
				newmol = sphere(pos=(xpos,ypos,zpos), radius=0.25, color=(random(),random(),random()))
				newmol.vel = vector(0.0,0.0,0.0)
				molecules.append(newmol)
	assert len(molecules) == mols_per_side ** 3
	print "Created", len(molecules), "molecules"

def total_pe():
	pe = 0.0
	for m1 in range(len(molecules)):
		for m2 in range(m1 + 1, len(molecules)):
			r12 = abs(molecules[m1].pos - molecules[m2].pos)
			pe += 1 / (r12 ** 12) - 2 / (r12 ** 6)
	return pe

def total_ke():
	ke = 0.0
	for mol in molecules:
		ke += abs(mol.vel) ** 2
	return ke

def print_energy_data():
	ke = total_ke()
	pe = total_pe()
	print "%15f%15f%15f%15f" % (step * dt, ke + pe, pe, ke)

def print_energy_header():
	print "%15s%15s%15s%15s" % ("Time", "Total Energy", "PE", "KE")

def get_force(m1pos, m2pos):
	r12 = (m1pos - m2pos).mag
	return (m1pos - m2pos).norm * 12 * (1 / (r12 ** 14) - 1 / (r12 ** 8))

def get_cur_accel(mol):
	mol.accel = vector(0.0, 0.0, 0.0)
	for m in molecules:
		if m == mol: continue
		mol.accel += get_force(mol.pos, m.pos)

def get_next_accel(mol):
	mol.naccel = vector(0.0, 0.0, 0.0)
	for m in molecules:
		if m == mol: continue
		mol.naccel += get_force(mol.newpos, m.newpos)

def get_new_positions():
	for m in molecules:
		get_cur_accel(m)
		m.newpos = m.pos + m.vel * dt + m.accel * (dt ** 2) / 2

def get_new_vels():
	for m in molecules:
		get_next_accel(m)
		m.newvel = m.halfvel + m.naccel * dt / 2

def move_mols():
	for m in molecules:
		m.pos = m.newpos
		m.vel = m.newvel

def get_half_vels():
	for m in molecules:
		m.halfvel = m.vel + m.accel * dt / 2

molecules = []
side_len = float(raw_input("Enter cube side length: "))
mols_per_side = int(raw_input("Enter molecules to a side: "))
init_mols()
dt = 0.001
max_steps = 10
print_energy_header()
for step in range(max_steps):
	print_energy_data()
	rate(10000)
	for m in molecules:
		m.accel = 0.0
		for n in molecules:
			if m == n: continue
			m.accel += get_force(m.pos, n.pos)
		m.pos += m.vel * dt + m.accel * (dt ** 2)
		
