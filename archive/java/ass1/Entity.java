import java.awt.Graphics;

/**
 * @author Matthew Joiner
 *
 * Copyright 2005
 * 
 */

public abstract class Entity {
    
    double xPos, yPos;
    
    public Entity (Double x, Double y) {
        xPos = x;
        yPos = y;
    }
    
    public abstract void draw(Graphics g);
    public abstract void step();
    
    public final int mapX() {
        return (int)xPos;
    }
    public final int mapY() {
        return (int)yPos;
    }
}