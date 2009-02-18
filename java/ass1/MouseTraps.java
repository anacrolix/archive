import java.util.Vector;
import java.awt.Graphics;

/**
 * @author Matthew Joiner, Olivia Micalos, Paul O'Brien
 *
 * Copyright 2005
 * 
 */

public class MouseTraps extends Vector<MouseTrap> {
    public void draw (Graphics g) {
        for (MouseTrap mt : this) {
            mt.draw (g);
        }
    }
    public void step () {
        for (MouseTrap mt : this) {
            mt.step ();
        }
    }
}