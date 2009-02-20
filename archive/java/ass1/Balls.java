import java.util.Vector;
import java.awt.Graphics;

/**
 * @author Matthew Joiner
 *
 * Copyright 2005
 * 
 */

public class Balls extends Vector<Ball> {
    public void draw (Graphics g) {
        for (Ball b : this) {
            b.draw (g);
        }
    }    
    public void step () {
        for (Ball b : this) {
            b.step ();
        }
    }
}