import java.util.Vector;
import java.awt.Graphics;

public abstract class Entities extends Vector<Entity> {
    public void draw (Graphics g) {
        for (Entity e : this) {
            e.draw(g);
        }
    }
    public void step () {
        for (Entity e : this) {
            e.step();
        }
    }
}