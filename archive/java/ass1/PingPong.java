import javax.swing.JFrame;
import java.awt.Color;
import java.util.Random;

/**
 * @author Matthew Joiner, Olivia Micalos, Paul O'Brien
 *
 * Copyright 2005
 * 
 */

public class PingPong extends JFrame {
    //constants
    public static final int 
        //world
        WIDTH = 1200, 
        HEIGHT = 800,
        STEPS = 5000,
        NUM_MOUSETRAPS = 20,
        STEPS_PER_REDRAW = 1,
        REDRAWS_PER_STEP = 1;    
    
    public static final double
        //balls in the mousetraps
        BAIT_RADIUS = 10,
        BAIT_MASS = 100.0,
        //initial ball
        FIRST_BALL_RADIUS = 10,
        FIRST_BALL_MASS = 100.0,
        //mousetraps
        MT_WIDTH = 40,
        MT_HEIGHT = 15,
        MT_LENGTH = 30;
    
    
    private PingPongCanvas canvas;
    private World world;
    
    public PingPong() {        
        super("Ping Pong Simulation");
        canvas = new PingPongCanvas(WIDTH, HEIGHT);
        (this.getContentPane()).add(canvas);
    }
    
    public static void main (String[] args) {
        PingPong sim;
        
        System.out.print("Initializing Ping Pong Simulation");
        sim = new PingPong();
        System.out.print(".");
        sim.pack();
        System.out.print(".");
        sim.setVisible(true);
        System.out.println(".");
        sim.run();
        
        System.out.println("End.");
        System.exit(0);
    }   
    
    public void run () {
        world = new World(WIDTH, HEIGHT);
        Random rand = new Random();        
        Ball b; //pointer to constructed ball
        MouseTrap mt; //pointer to constructed mousetrap
        
        //create mousetrap/ball pairs
        for (int i = 1; i <= NUM_MOUSETRAPS; i++) {
            b = new Ball(
                         (double)(i * WIDTH / (NUM_MOUSETRAPS + 1)) + MT_LENGTH - BAIT_RADIUS, //x
                         HEIGHT - MT_HEIGHT / 2 - BAIT_RADIUS, //y
                         0.0, //x vel
                         0.0, //y vel
                         new Color(rand.nextInt(255),rand.nextInt(255),rand.nextInt(255)), //color
                         BAIT_RADIUS, //radius
                         BAIT_MASS); //mass
            mt = new MouseTrap(
                               i * WIDTH / (NUM_MOUSETRAPS + 1), //x
                               HEIGHT - MT_HEIGHT / 2, //y
                               MT_WIDTH, //width
                               MT_HEIGHT, //height
                               MT_LENGTH, //arm length
                               b); //attached ball
            world.balls.add(b);
            world.mouseTraps.add(mt);
        }
        
        //initial active ball
        b = new Ball(
                     WIDTH/2, //x
                     HEIGHT/2, //y
                     (rand.nextDouble() - 0.5) * 2.0, //x vel
                     (rand.nextDouble() - 0.5) * 2.0, //y vel
                     Color.black, //color
                     FIRST_BALL_RADIUS, //radius
                     FIRST_BALL_MASS); //mass
        b.active = true;
        world.balls.add(b);
        
        //cycle throo drawing/stepping the world
        for (int s = 0; s < STEPS; s=s) {
            //repeat multiple steps between each redraw
            for (int i = 0; i < STEPS_PER_REDRAW; i++) {
                System.out.println("Step : " + s);
                world.step();
                s++;
            }
            
            for (int i = 0; i < REDRAWS_PER_STEP; i++)
            {
            canvas.clearBuffer(); //clear buffer image
            world.draw(canvas.getBuffer()); //draw on buffer image 
            canvas.flip(); //display buffer image
            }
        }
    }
}