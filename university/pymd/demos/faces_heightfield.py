## Demonstrates some techniques for working with "faces", and
## shows how to build a height field (a common feature request)
## with it.
## David Scherer July 2001

from visual import *

class Model:
    def __init__(self):
        self.frame = frame()
        self.model = faces(frame=self.frame)
        self.twoSided = true  # add every face twice with opposite normals

    def FacetedTriangle(self, v1, v2, v3, color=None):
        """Add a triangle to the model, apply faceted shading automatically"""
        try:
            normal = norm( cross(v2-v1, v3-v1) )
        except:
            normal = vector(0,0,0)
        for v in (v1,v2,v3):
            self.model.append( pos=v, color=color, normal=normal )
        if self.twoSided:
            for v in (v1,v3,v2):
                self.model.append( pos=v, color=color, normal=-normal )

    def FacetedPolygon(self, *v):
        """Appends a planar polygon of any number of vertices to the model,
           applying faceted shading automatically."""
        for t in range(len(v)-2):
            self.FacetedTriangle( v[0], v[t+1], v[t+2] )

    def DoSmoothShading(self):
        """Change a faceted model to smooth shaded, by averaging normals at
        coinciding vertices.
        
        This is a very slow and simple smooth shading
        implementation which has to figure out the connectivity of the
        model and does not attempt to detect sharp edges.

        It attempts to work even in two-sided mode where there are two
        opposite normals at each vertex.  It may fail somehow in pathological
        cases. """

        pos = self.model.pos
        normal = self.model.normal

        vertex_map = {}  # vertex position -> vertex normal
        vertex_map_backface = {}
        for i in range( len(pos) ):
            tp = tuple(pos[i])
            old_normal = vertex_map.get( tp, (0,0,0) )
            if dot(old_normal, normal[i]) >= 0:
                vertex_map[tp] = normal[i] + old_normal
            else:
                vertex_map_backface[tp] = normal[i] + vertex_map_backface.get(tp, (0,0,0))

        for i in range( len(pos) ):
            tp = tuple(pos[i])
            if dot(vertex_map[tp], normal[i]) >= 0:
                normal[i] = vertex_map[tp] and norm( vertex_map[ tp ] )
            else:
                normal[i] = vertex_map_backface[tp] and norm(vertex_map_backface[tp] )

    def DrawNormal(self, scale):
        pos = self.model.pos
        normal = self.model.normal
        for i in range(len(pos)):
            arrow(pos=pos[i], axis=normal[i]*scale)

class Mesh (Model):
    def __init__(self, xvalues, yvalues, zvalues):
        Model.__init__(self)

        points = zeros( xvalues.shape + (3,), Float )
        points[...,0] = xvalues
        points[...,1] = yvalues
        points[...,2] = zvalues

        for i in range(zvalues.shape[0]-1):
            for j in range(zvalues.shape[1]-1):
                self.FacetedPolygon( points[i,j], points[i,j+1],
                                     points[i+1,j+1], points[i+1,j] )

## Graph a function of two variables (a height field)
x = arange(-1,1,2./20)
y = arange(-1,1,2./20)

z = zeros( (len(x),len(y)), Float )
x,y = x[:,NewAxis]+z, y+z

m = Mesh( x, (sin(x*pi)+sin(y*pi))*0.2, y )
m.DoSmoothShading()
##m.DrawNormal(0.05)

