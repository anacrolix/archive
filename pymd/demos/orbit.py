from visual import *

giant = sphere()
giant.pos = vector(-1e11,0,0)
giant.radius = 2e10
giant.color = color.red
giant.mass = 2e30
giant.p = vector(0, 0, -1e4) * giant.mass

dwarf = sphere()
dwarf.pos = vector(1.5e11,0,0)
dwarf.radius = 1e10
dwarf.color = color.yellow
dwarf.mass = 1e30
dwarf.p = -giant.p

for a in [giant, dwarf]:
  a.orbit = curve(color=a.color, radius = 2e9)

dt = 86400

while 1:
  rate(100)

  dist = dwarf.pos - giant.pos
  force = 6.7e-11 * giant.mass * dwarf.mass * dist / mag(dist)**3
  giant.p = giant.p + force*dt
  dwarf.p = dwarf.p - force*dt

  for a in [giant, dwarf]:
    a.pos = a.pos + a.p/a.mass * dt
    a.orbit.append(pos=a.pos)

