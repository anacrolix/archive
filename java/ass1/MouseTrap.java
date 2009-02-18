import java.lang.Math;
import java.awt.Graphics;
import java.awt.Color;

/**
 * @author Matthew Joiner, Olivia Micalos, Paul O'Brien
 *
 * Copyright 2005
 * 
 */

public class MouseTrap extends Entity {
    
    Boolean fired = false;
    Ball ball;
    double angle = 0.0;
    double width, height, length;
    
    public MouseTrap (double x, double y, double w, double h, double l, Ball b) {
        super(x, y);
        ball = b;
        width = w;
        height = h;
        length = l;
    }
    
    private int width() {
        return (int)width;
    }
    
    private int height() {
        return (int)height;
    }
    
    public void draw(Graphics g) {
        g.setColor (Color.green);
        g.fillRect (mapX()-width()/2, mapY()-height()/2, width(), height());
        g.setColor (Color.yellow);
        g.drawLine (mapX(), mapY(), 
                    (int)(mapX() + length * Math.cos(angle)), 
                    (int)(mapY() + length * Math.sin(angle)));        
    }
    
    public void step() {
        if (fired && angle > -Math.PI) {
            angle -= Math.PI/32;
        }
    }
}
    