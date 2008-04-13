from visual import *

# Double pendulum

# The analysis is in terms of Lagrangian mechanics.
# The Lagrangian variables are angle of upper bar, angle of lower bar,
# measured from the vertical.

scene.title = 'Double Pendulum'
scene.height = scene.width = 800

g = 9.8
M1 = 2.0
M2 = 1.0
d = 0.05 # thickness of each bar
gap = 2.*d # distance between two parts of upper, U-shaped assembly
L1 = 0.5 # physical length of upper assembly; distance between axles
L1display = L1+d # show upper assembly a bit longer than physical, to overlap axle
L2 = 1.0 # physical length of lower bar
L2display = L2+d/2. # show lower bar a bit longer than physical, to overlap axle
# Coefficients used in Lagrangian calculation
A = (1./4.)*M1*L1**2+(1./12.)*M1*L1**2+M2*L1**2
B = (1./2.)*M2*L1*L2
C = g*L1*(M1/2.+M2)
D = M2*L1*L2/2.
E = (1./12.)*M2*L2**2+(1./4.)*M2*L2**2
F = g*L2*M2/2.

hpedestal = 1.3*(L1+L2) # height of pedestal
wpedestal = 0.1 # width of pedestal
tbase = 0.05 # thickness of base
wbase = 8.*gap # width of base
offset = 2.*gap # from center of pedestal to center of U-shaped upper assembly
top = vector(0,0,0) # top of inner bar of U-shaped upper assembly
scene.center = top-vector(0,(L1+L2)/2.,0)

theta1 = 1.3*pi/2. # initial upper angle (from vertical)
theta1dot = 0 # initial rate of change of theta1
theta2 = 0 # initial lower angle (from vertical)
theta2dot = 0 # initial rate of change of theta2

pedestal = box(pos=top-vector(0,hpedestal/2.,offset),
                 height=1.1*hpedestal, length=wpedestal, width=wpedestal,
                 color=(0.4,0.4,0.5))
base = box(pos=top-vector(0,hpedestal+tbase/2.,offset),
                 height=tbase, length=wbase, width=wbase,
                 color=pedestal.color)
axle = cylinder(pos=top-vector(0,0,gap/2.-d/4.), axis=(0,0,-offset), radius=d/4., color=color.yellow)

frame1 = frame(pos=top)
bar1 = box(frame=frame1, pos=(L1display/2.-d/2.,0,-(gap+d)/2.), size=(L1display,d,d), color=color.red)
bar1b = box(frame=frame1, pos=(L1display/2.-d/2.,0,(gap+d)/2.), size=(L1display,d,d), color=color.red)
axle1 = cylinder(frame=frame1, pos=(L1,0,-(gap+d)/2.), axis=(0,0,gap+d),
                 radius=axle.radius, color=axle.color)
frame1.axis = (0,-1,0)
frame2 = frame(pos=frame1.axis*L1)
bar2 = box(frame=frame2, pos=(L2display/2.-d/2.,0,0), size=(L2display,d,d), color=color.green)
frame2.axis = (0,-1,0)
frame1.rotate(axis=(0,0,1), angle=theta1)
frame2.rotate(axis=(0,0,1), angle=theta2)

scene.autoscale = 0

dt = 0.001
t = 0.

while 1:
    rate(1./dt)
    # Calculate accelerations of the Lagrangian coordinates:
    atheta1 = ((E*C/B)*sin(theta1)-F*sin(theta2))/(D-E*A/B)
    atheta2 = -(A*atheta1+C*sin(theta1))/B
    # Update velocities of the Lagrangian coordinates:
    theta1dot = theta1dot+atheta1*dt
    theta2dot = theta2dot+atheta2*dt
    # Update Lagrangian coordinates:
    dtheta1 = theta1dot*dt
    dtheta2 = theta2dot*dt
    theta1 = theta1+dtheta1
    theta2 = theta2+dtheta2

    frame1.rotate(axis=(0,0,1), angle=dtheta1)
    frame2.pos = top+frame1.axis*L1
    frame2.rotate(axis=(0,0,1), angle=dtheta2)
    t = t+dt

