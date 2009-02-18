import java.awt.Graphics;
import java.util.Random;
import java.awt.Color;

/**
 * @author Matthew Joiner, Olivia Micalos, Paul O'Brien
 *
 * Copyright 2005
 * 
 */

public class World {
    final static double 
        SEPARATION_MULTIPLIER = 1.001,
        COEFF_FRICTION = 0.03;
    
    double WIDTH, HEIGHT;
    Balls balls = new Balls();
    MouseTraps mouseTraps = new MouseTraps();
    
    static Random rand = new Random();
    
    public World (int w, int h) {
        WIDTH = w;
        HEIGHT = h;
    }
    
    public void step() {
        //update world
        balls.step();
        mouseTraps.step();
        //check ball collisions with other balls, walls
        checkCollide(balls);
        checkWalls(balls, WIDTH, HEIGHT);
        //check for triggered mousetraps
        checkTrigger(balls, mouseTraps);
    }
    
    public void draw(Graphics g) {
        mouseTraps.draw(g);
        balls.draw(g);
    }
    
    public static void checkCollide (Balls bs) {
        Ball b1, b2;
        double ax, ay, bx, by, cx, cy, vel, dot, c2, magC;
        
        for (int i = 0; i < bs.size() - 1; i++) {
            for (int j = i + 1; j < bs.size(); j++) {
                
                b1 = bs.get(i);
                b2 = bs.get(j);
                
                if (b1.active && b2.active) {  
                    
                    cx = b2.xPos - b1.xPos;
                    cy = b2.yPos - b1.yPos;
                    
                    if (distance(cx, cy) <= b1.radius + b2.radius) {
                        // |C|^2
                        c2 = Math.pow(cx, 2) + Math.pow(cy, 2);
                        
                        //component of velocity of b1 in the direction of b2
                        // A.C
                        dot = b1.xVel * cx + b1.yVel * cy;
                        // proj_C A = C * A.C / |C|^2
                        ax = cx * dot / c2;
                        ay = cy * dot / c2;
                        
                        //component of velocity of b2 in the direction of b1
                        // B.C
                        dot = b2.xVel * cx + b2.yVel * cy;
                        // proj_C B = C * B.C / |C|^2
                        bx = cx * dot / c2;
                        by = cy * dot / c2;
                        
                        
                        b1.xVel +=  bx * (b2.mass/b1.mass) - ax;
                        b1.yVel +=  by * (b2.mass/b1.mass) - ay;
                        b2.xVel +=  ax * (b1.mass/b2.mass) - bx;
                        b2.yVel +=  ay * (b1.mass/b2.mass) - by;
                        
                        
                        //enforce separation
                        // |C|
                        magC = distance(cx, cy);
                        
                        // r1 / (r1 + r2) * C - k * r1
                        b1.xPos += b1.radius/(b1.radius + b2.radius) * cx - SEPARATION_MULTIPLIER * b1.radius * cx / magC;
                        b1.yPos += b1.radius/(b1.radius + b2.radius) * cy - SEPARATION_MULTIPLIER * b1.radius * cy / magC;
                        // r2 / (r1 + r2) * C - k * r2
                        b2.xPos -= b2.radius/(b1.radius + b2.radius) * cx - SEPARATION_MULTIPLIER * b2.radius * cx / magC;
                        b2.yPos -= b2.radius/(b1.radius + b2.radius) * cy - SEPARATION_MULTIPLIER * b2.radius * cy / magC;
                        
                        //friction
                        vel = distance(b1.xVel, b1.yVel);
                        b1.xVel *= 1 - COEFF_FRICTION * Math.cos(b1.xVel/vel);
                        b1.yVel *= 1 - COEFF_FRICTION * Math.sin(b1.yVel/vel);
                        
                        vel = distance(b2.xVel, b2.yVel);
                        b2.xVel *= 1 - COEFF_FRICTION * Math.cos(b2.xVel/vel);
                        b2.yVel *= 1 - COEFF_FRICTION * Math.sin(b2.yVel/vel);
                    }
                }
            }
        }
    }
    
    public static void checkWalls (Balls bs, double w, double h) {
        for (Ball b : bs) {
            if (b.xPos-b.radius < 0 || b.xPos+b.radius > w) {
                b.xVel = (1 - COEFF_FRICTION) * -b.xVel;
                if (b.xPos-b.radius < 0) {b.xPos = b.radius;}
                if (b.xPos+b.radius > w) {b.xPos = w-b.radius;}
            }
            if (b.yPos-b.radius < 0 || b.yPos+b.radius > h) {
                b.yVel = (1 - COEFF_FRICTION) * -b.yVel;
                if (b.yPos-b.radius < 0) {b.yPos = b.radius;}
                if (b.yPos+b.radius > h) {b.yPos = h-b.radius;}
            }
        }        
    }
    
    public static void checkTrigger (Balls bs, MouseTraps mts) {        
        for (MouseTrap mt : mts) {
            for (Ball b : bs) {
                if ( //ball is not in a mousetrap, and the mousetrap hasn't been triggered
                    b.active == true && mt.fired == false && 
                    between (b.xPos, mt.xPos - mt.width/2 - b.radius, mt.xPos + b.radius) && 
                    between (b.yPos, mt.yPos - mt.height/2 - b.radius, mt.yPos + mt.height/2 + b.radius) )
                {
                    mt.fired = true; //consider mousetrap spent
                    mt.ball.yVel = -7;
                    mt.ball.xVel = (rand.nextDouble() - 0.5) * 3.0;
                    mt.ball.active = true;
                    mt.ball = null;
                }
            }
        }
    }
    
    private static boolean between (double v, double l, double r) {
        return (v >= l && v <= r);
    }        
    
    
    private static double distance(double a, double b) {
        return Math.sqrt(Math.pow(a,2) + Math.pow(b,2));
    }   
}