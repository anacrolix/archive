from visual import *
from random import random
from time import clock

N = 3
Ntotal = N*N*N
scolor = (1,1,0)
springs = []
atoms = []

def getn(N, nx, ny, nz): # find nth atom given nx, ny, nz
    return (ny)*(N**2)+(nx)*N+(nz)

def makespring(natom1, natom2, radius): # make spring from nnth atom to iith atom
    if natom1 > natom2:
        springs.append(cylinder(pos=atoms[natom1].pos,
            axis=atoms[natom2].pos-atoms[natom1].pos,
            radius = radius, color=scolor))
        springs[-1].natom1 = natom1
        springs[-1].natom2 = natom2
    
def crystal(N=3, delta=1.0, R=None, sradius=None):
    if R == None:
        R = 0.2*delta
    if sradius == None:
        sradius = R/5.
    xmin = -(N-1.0)/2.
    ymin = xmin
    zmin = xmin
    sradius = R/5.
    natom = 0
    for ny in range(N):
        y = ymin+ny*delta
        hue = (ny)/(N+1.0)
        c = color.hsv_to_rgb((hue,1.0,1.0))
        for nx in range(N):
            x = xmin+nx*delta
            for nz in range(N):
                z = zmin+nz*delta
                atoms.append(sphere(pos=(x,y,z), radius=R, color=c))
                atoms[-1].p = vector()
                atoms[-1].near = range(6)
                atoms[-1].wallpos = range(6)
                atoms[-1].natom = natom
                atoms[-1].indices = (nx,ny,nz)
                natom = natom+1
    for a in atoms:
                    natom1 = a.natom
                    nx, ny, nz = a.indices
                    if nx == 0: # left
                        # if this neighbor is the wall, save location:
                        a.near[0] = None
                        a.wallpos[0] = a.pos-vector(L,0,0)
                    else:
                        natom2 = getn(N,nx-1,ny,nz)
                        a.near[0] = natom2
                        makespring(natom1, natom2, sradius)
                    if nx == N-1: # right
                        a.near[1] = None
                        a.wallpos[1] = a.pos+vector(L,0,0)
                    else:
                        natom2 = getn(N,nx+1,ny,nz)
                        a.near[1] = natom2
                        makespring(natom1, natom2, sradius)
                        
                    if ny == 0: # down
                        a.near[2] = None
                        a.wallpos[2] = a.pos-vector(0,L,0)
                    else:
                        natom2 = getn(N,nx,ny-1,nz)
                        a.near[2] = natom2
                        makespring(natom1, natom2, sradius)
                    if ny == N-1: # up
                        a.near[3] = None
                        a.wallpos[3] = a.pos+vector(0,L,0)
                    else:
                        natom2 = getn(N,nx,ny+1,nz)
                        a.near[3] = natom2
                        makespring(natom1, natom2, sradius)
                    
                    if nz == 0: # back
                        a.near[4] = None
                        a.wallpos[4] = a.pos-vector(0,0,L)
                    else:
                        natom2 = getn(N,nx,ny,nz-1)
                        a.near[4] = natom2
                        makespring(natom1, natom2, sradius)
                    if nz == N-1: # front
                        a.near[5] = None
                        a.wallpos[5] = a.pos+vector(0,0,L)
                    else:
                        natom2 = getn(N,nx,ny,nz+1)
                        a.near[5] = natom2
                        makespring(natom1, natom2, sradius)
    return atoms

m = 1.
k = 1.
L = 1.
R = 0.4*L
sradius = R/3.
vrange = 0.1*L*sqrt(k/m)
dt = 2.*pi*sqrt(m/k)/50.
#dt = 2.*pi*sqrt(m/k)/10.
atoms = crystal(N=N, delta=L, R=R, sradius=sradius)
scene.autoscale = 0

ptotal = vector()
for a in atoms:
    px = m*(-vrange/2+vrange*random())
    py = m*(-vrange/2+vrange*random())
    pz = m*(-vrange/2+vrange*random())
    a.p = vector(px,py,pz)
    ptotal = ptotal+a.p

for a in atoms:
    a.p = a.p-ptotal/(N**2)

tt = clock()
Nsteps = 0
while 1:
    for a in atoms:
        F = vector()
        pos = a.pos
        near = a.near
        wallpos = a.wallpos
        for nn in range(6):
            natom = near[nn]
            if natom == None: # if this nearest neighbor is the wall
                r = wallpos[nn]-pos
            else:
                r = atoms[natom].pos-pos
            F = F+norm(r)*(mag(r)-L)
        a.p = a.p + k*F*dt

    for a in atoms:
        a.pos = a.pos+(a.p/m)*dt

    for s in springs:
        s.pos = atoms[s.natom1].pos
        s.axis = atoms[s.natom2].pos-s.pos
        s.radius = sradius*sqrt((L-2*R)/(mag(s.axis)-2*R))

    if Nsteps == 100:
        tt = clock()-tt
        print '%0.1f' % tt, 'sec for', Nsteps, 'steps with', N, 'on a side'
    Nsteps = Nsteps+1
