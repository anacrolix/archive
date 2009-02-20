import java.lang.Math;
import java.awt.Graphics;
import java.awt.Color;

/**
 * @author Matthew Joiner, Olivia Micalos, Paul O'Brien
 *
 * Copyright 2005
 * 
 */

public class Ball extends Entity {
    double radius, mass;
    double xVel, yVel;
    Color color;
    boolean active = false; 
    
    final static double GRAVITY = 0.05;
    
    public Ball(double x, double y, double dx, double dy, Color clr, double r, double m) {
        super(x, y); 
        xVel = dx;
        yVel = dy;
        color = clr;
        radius = r;
        mass = m;
    } 
    
    public void draw(Graphics g) {
        g.setColor (color);
        g.fillOval(mapX()-(int)radius, mapY()-(int)radius, (int)(2*radius), (int)(2*radius));
    }
    
    public void step() {
        if (active) {
            yVel += GRAVITY;
            xPos += xVel;
            yPos += yVel;
        }
    }
}     
