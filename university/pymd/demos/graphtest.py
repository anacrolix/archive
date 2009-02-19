from visual.graph import *

# Using a graph-plotting module

# If xmax, xmin, ymax, or ymin specified, the related axis is not autoscaled
# Can turn off autoscaling with
#    oscillation.autoscale[0]=0 for x or oscillation.autoscale[1]=0 for y
oscillation = gdisplay(xtitle='t', ytitle='Response')
funct1 = gcurve(color=color.cyan)
funct2 = gvbars(delta=0.5, color=color.red)
funct3 = gdots(color=color.yellow)

for t in arange(-30, 70, 1):
    funct1.plot( pos=(t, 5.0+5.0*cos(-0.2*t)*exp(0.015*t)) )
    funct2.plot( pos=(t, 2.0+5.0*cos(-0.1*t)*exp(0.015*t)) )
    funct3.plot( pos=(t, 5.0*cos(-0.03*t)*exp(0.015*t)) )
