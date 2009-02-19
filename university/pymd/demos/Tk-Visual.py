# example using Tk, visual and an animation
# David Andersen, Carnegie Mellon

from visual import *
from Tkinter import *
import time,sys,thread

class ProgClass:
    def __init__(self,parent):
        self.parent = parent
        self.run = "run" # run animation

#       position and title Tk window

        parent.wm_geometry(newGeometry="+0+0")   
        parent.wm_title("Control Lighting")

#       set up visual objects

        scene.x = 250
        self.sphere3 = sphere(pos=(1.5,0,0),radius=0.03,color=crayola.blue)
        self.rr = 1
        self.gg = 0
        self.bb = 0
        self.sphere1 = sphere(pos=(0,0,0),radius=.25,
                              color=(self.rr,self.gg,self.bb))
        self.angle = 0
        self.sphere2 = sphere(pos=(sin(self.angle),cos(self.angle),0),
                              radius=0.03,color=crayola.cyan)
        scene.autoscale = 0

#       start animation thread

	thread.start_new_thread(self.box_anim,())

    def set_red(self,rstr): # set red component of color
        self.rr = string.atoi(rstr)/100.0
        self.sphere1.color = (self.rr,self.gg,self.bb)
        
    def set_green(self,gstr): # set green component of color
        self.gg = string.atoi(gstr)/100.0
        self.sphere1.color = (self.rr,self.gg,self.bb)
        
    def set_blue(self,bstr): # set blue component of color
        self.bb = string.atoi(bstr)/100.0
        self.sphere1.color = (self.rr,self.gg,self.bb)
        
    def box_anim(self):
        while (self.run == "run"):
            self.angle = self.angle+pi/32.0
            self.sphere2.pos = (sin(self.angle),cos(self.angle),0)
            rate(30)
        pp.run = "stopped" # indicate annimation has stopped

tkr = Tk() 
pp = ProgClass(tkr) 

# set up Tk widgets

scalerr = Scale(tkr,orient=VERTICAL,from_=100,to=0,label="R",command=lambda str: pp.set_red(str))
scalerr.pack(side=LEFT)
scalegg = Scale(tkr,orient=VERTICAL,from_=100,to=0,label="G",command=lambda str: pp.set_green(str))
scalegg.pack(side=LEFT)
scalebb = Scale(tkr,orient=VERTICAL,from_=100,to=0,label="B",command=lambda str: pp.set_blue(str))

scalerr.set(pp.rr*100.0)
scalegg.set(pp.gg*100.0)
scalebb.set(pp.bb*100.0)

scalebb.pack(side=LEFT)

tkr.mainloop() # Tk event loop

pp.run = "stop" # stop annimation
while pp.run == "stop":
    time.sleep(0.1) # give annimation thread time to respond "stopped"

scene.hide() # close visual






