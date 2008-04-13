#!/usr/bin/env python

from visual import sphere, vector, rate
from random import random
import md

radius = 0.25
max_steps = 10000000
max_substeps = 100
dt = 0.001

side_len = float(raw_input("Enter cube side length: "))
mols_per_side = int(raw_input("Enter molecules to a side: "))
molecules = []

for x in range(mols_per_side):
	xpos = side_len * x / (mols_per_side - 1) - side_len / 2
	for y in range(mols_per_side):
		ypos = side_len * y / (mols_per_side - 1) - side_len / 2
		for z in range(mols_per_side):
			zpos = side_len * z / (mols_per_side - 1) - side_len / 2
			new_mol = sphere()
			new_mol.pos = vector(xpos, ypos, zpos)
			new_mol.color = ((x)/float(mols_per_side-1), float(y)/float(mols_per_side-1), (z)/float(mols_per_side-1))
			new_mol.radius = radius
			new_mol.vel = vector()
			new_mol.accel = vector()
			molecules.append(new_mol)

def get_accels(molecules):
	accels = []
	for mol1 in molecules:
		accel = vector()
		for mol2 in molecules:
			if mol1 == mol2: continue
			r12 = abs(mol1.pos - mol2.pos)
			assert abs(mol2.pos - mol1.pos) == r12
			fcom = (12 * r12 ** -8) * (r12 ** -6 - 1)
			force = fcom * (mol1.pos - mol2.pos)
			accel += force
		accels.append(accel)
	return accels

print "%15s%15s%15s%15s" % ("time", "total", "pe", "ke")

step = 0
while step < range(max_steps):
	rate(60)
	pe = md.total_pe(molecules)
	ke = md.total_ke(molecules)
	print "%15f%15e%15e%15e" % (step * max_substeps * dt, pe + ke, pe, ke)
	substep = 0
	while substep < max_substeps:
		# get a(t)
		accels = get_accels(molecules)
		for a in range(len(accels)):
			molecules[a].accel = accels[a]
		# get r(t+dt)
		for m in range(len(molecules)):
			mol = molecules[m]
			mol.pos += dt * (mol.vel + dt * accels[m] / 2)
		# get v(t+dt)
		acceldts = get_accels(molecules)
		for m in range(len(molecules)):
			molecules[m].vel += dt * (molecules[m].accel + acceldts[m]) / 2
		substep += 1
	step += 1
	
