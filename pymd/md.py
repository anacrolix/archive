#!/usr/bin/env python

from visual import sphere, vector, rate
from random import random
import md

radius = 0.25
max_steps = 10
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

def total_ke(molecules):
	ke = 0.0
	for mol in molecules:
		ke += abs(mol.vel) ** 2
	return ke / 2

def total_pe():
	pe = 0.0
	for m1 in range(len(molecules)):
		mol1 = molecules[m1]
		for m2 in range(m1 + 1, len(molecules)):
			mol2 = molecules[m2]
			r12 = abs(mol1.pos - mol2.pos)
			assert abs(mol2.pos - mol1.pos) == r12
			pe += r12 ** -6 * (r12 ** -6 - 2)
	return pe 

def get_accels():
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

for step in range(max_steps):
	pe = total_pe()
	ke = md.total_ke(molecules)
	print "%15f%15e%15e%15e" % (step * dt, pe + ke, pe, ke)
	rate(10000)
	# get a(t)
	accels = get_accels()
	for a in range(len(accels)):
		molecules[a].accel = accels[a]
	# get r(t+dt)
	for m in range(len(molecules)):
		mol = molecules[m]
		mol.pos += dt * (mol.vel + dt * accels[m] / 2)
	# get v(t+dt)
	acceldts = get_accels()
	for m in range(len(molecules)):
		molecules[m].vel += dt * (molecules[m].accel + acceldts[m]) / 2
	
