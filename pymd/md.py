#!/usr/bin/env python

from visual import rate, sphere, vector
from random import random
from math import sqrt

def init_mols():
	global side_len, mols_per_side, mols
	side_len      = float(raw_input("Enter cube side length: "))
	mols_per_side = int  (raw_input("Enter atoms to a side : "))
	mols = []
	for x in range(mols_per_side):
		xpos = side_len * x / (mols_per_side - 1) - side_len / 2
		for y in range(mols_per_side):
			ypos = side_len * y / (mols_per_side - 1) - side_len / 2
			for z in range(mols_per_side):
				zpos = side_len * z / (mols_per_side - 1) - side_len / 2
				newmol = sphere(pos=(xpos, ypos, zpos), radius=0.25, color=(random(), random(), random()))
				newmol.velocity = vector(0, 0, 0)
				mols.append(newmol)
	print "Created", len(mols), "molecules"

def total_pe():
	total_pe = 0.0
	for a in range(len(mols)):
		mola = mols[a]
		for b in range(a + 1, len(mols)):
			molb = mols[b]
			sep = abs(mola.pos - molb.pos)
			total_pe += 1/(sep**12) - 2/(sep**6)
	return total_pe

def total_ke():
	total_ke = 0.0
	for mol in mols:
		total_ke += abs(mol.velocity)**2
	return total_ke / 2

def get_force(pos1, pos2):
	sep = abs(pos1 - pos2)
	f = 12 * (1 / (sep ** 14) - 1 / (sep ** 8)) * (pos2 - pos1)
	return f

def calc_forces(mol_poss):
	forces = []
	f = vector()
	for p1 in mol_poss:
		f.clear()
		for p2 in mol_poss:
			if p1 == p2: continue
			f += get_force(p1, p2)
		forces.append(f)
	return forces

init_mols()

print "%15s%15s%15s%15s" % ("Time", "Total Energy", "PE", "KE")

dt = 0.001
max_steps = 1000
for step in range(max_steps):
	print "%15f%15f%15f%15f" % (step * dt, total_ke() + total_pe(), total_pe(), total_ke())
	rate(1000)
	oldpos = []
	for mol in mols:
		oldpos.append(mol.pos)
	forces = calc_forces(oldpos)
	for i in range(len(mols)):
		mols[i].pos += mols[i].velocity * dt + forces[i] * (dt ** 2) / 2
		halfvel = mols[i].velocity + dt * forces[i] / 2
		nextforce = get_force(
