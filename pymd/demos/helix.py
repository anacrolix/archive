from visual import *

class helix:
    def __init__(self, pos=vector(), axis=vector(1,0,0), radius=0.2, coils=5,
               thickness=None, color=None):
        self.frame = frame(pos=vector(pos), axis=norm(axis))
        self.pos = vector(pos)
        self.axis = vector(axis)
        self.length = mag(axis)
        self.radius = radius
        self.coils = coils
        if thickness == None:
            thickness = radius/20.
        k = self.coils*(2.*pi/self.length)
        dx = (self.length/self.coils)/12.
        xx=arange(0,self.length+dx,dx)
        self.helix = curve(frame = self.frame, radius=thickness/2.,
                           color=color, x=xx, y=radius*sin(k*xx),
                           z=radius*cos(k*xx))
##        self.helix = curve(frame=self.frame, radius=thickness/2., color=color)
##
##        for x in arange(0,self.length+dx,dx):
##            self.helix.append( pos=(x,radius*sin(k*x),radius*cos(k*x)) )
            
    def modify(self, pos=None, axis=None, length=None):
        oldlength = self.length
        if pos <> None:
            self.frame.pos = vector(pos)
            self.pos = vector(pos)
        if axis <> None:
            self.axis = vector(axis)
            self.frame.axis = vector(axis)
            self.length = mag(axis)
        if length <> None:
            self.length = length
        k = self.coils*(2.*pi/self.length)
        dx = (self.length/self.coils)/12.
        x = 0.
        lindex = len(self.helix.pos)
        for index in range(lindex):
            self.helix.pos[index][0] = self.helix.pos[index][0]*self.length/oldlength
            x = x+dx

if __name__ == '__main__':
    spring = helix(pos=(0,0,0), axis=(1,0,0),
                   radius=0.2, thickness=0.03, color=(1,.7,.2))
    sphere(radius=0.1)
    sphere(radius=0.1, pos=(1,0,0))
    scene.mouse.getclick() # pause for click
    spring.modify(pos=(0,1,0), axis=(0,1,0), length=2)
