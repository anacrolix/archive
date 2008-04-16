#!/usr/bin/env python

from visual import sphere, vector, rate
from random import random
import md
from time import clock

radius = 0.25

print "Simulation parameters (enter for default)"
try: side_len = float(raw_input("Cube side length (4): "))
except ValueError: side_len = 4.0
try: mols_per_side = int(raw_input("Molecules to a side (4): "))
except ValueError: mols_per_side = 4
try: max_substeps = int(raw_input("Steps per frame (10): "))
except ValueError: max_substeps = 10
try: max_steps = int(raw_input("Total steps (-1):"))
except ValueError: max_steps = -1
try: dt = float(raw_input("Time step (0.001): "))
except ValueError: dt = 0.001

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
start_time = clock()
while 1:
	print_energy_data(molecules)
	step += md.update_mols(molecules, max_substeps, dt)
	if step < max_steps and max_steps >= 0: break
end_time = clock()

print_energy_data(molecules)
print "Performed", step, "steps in", end_time - start_time, "s"
