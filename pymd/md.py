#!/usr/bin/env python

from visual import sphere, vector, rate
from random import random
import md

radius = 0.25
max_steps = 1
max_substeps = 9
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

def print_energy_data(molecules):
	pe = md.total_pe(molecules)
	ke = md.total_ke(molecules)
	print "%15f%15e%15e%15e" % (step * dt, pe + ke, pe, ke)	

print "%15s%15s%15s%15s" % ("time", "total", "pe", "ke")

step = 0
while step < max_steps:
	rate(60)
	print_energy_data(molecules)
	step += md.update_mols(molecules, max_substeps, dt)

print_energy_data(molecules)
