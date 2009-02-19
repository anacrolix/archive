from visual import *
# Example of use of faces object for building arbitrary shapes (here, a cone)
# David Scherer July 2001

f = frame()

box( size=(0.5,0.5,0.5) )

# Make a cone (smooth shading, no bottom, normals are not quite physical)

N = 20

model = faces( pos = zeros( (N*3,3), Float ), frame = f )

t = arange(0,2*pi+2*pi/N,2*pi/N)

# Vertex 0 of triangles
model.pos[0::3, 0] = sin(t[:-1])
model.pos[0::3, 2] = cos(t[:-1])

# Vertex 1 of triangles
model.pos[1::3, 0] = sin(t[1:])
model.pos[1::3, 2] = cos(t[1:])

# Vertex 2 of triangles (point of cone)
model.pos[2::3, 1] = 2

# All normals point outward in XZ... not quite right, but there is already a cone primitive :)
model.normal = model.pos
model.normal[2::3,0] = sin((t[:-1]+t[1:])/2)
model.normal[2::3,1] = 0
model.normal[2::3,2] = cos((t[:-1]+t[1:])/2)

model.color = model.pos/2 + (0.5,0,0.5)

##model.color[0::3] = (1,1,1)   # show where the triangles are

while 1:
    rate(100)
    f.rotate(angle=0.01)
