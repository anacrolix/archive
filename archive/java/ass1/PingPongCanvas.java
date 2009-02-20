import java.awt.Canvas;
import java.awt.image.BufferedImage;
import java.awt.Graphics;
import java.awt.Color;

/**
 * @author Matthew Joiner, Olivia Micalos, Paul O'Brien
 *
 * Copyright 2005
 * 
 */

public class PingPongCanvas extends Canvas {
    
    private int width, height;
    private BufferedImage background, buffer;
    
    public PingPongCanvas(int w, int h) {
        //initialize canvas
        width = w;
        height = h;
        setSize(width, height);
        //instantiate image buffers
        background = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
        buffer = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
        //set background
        Graphics g = background.getGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0,0,w,h);
    }
    
    public void clearBuffer() {
        Graphics g = buffer.getGraphics();
        g.drawImage(background,0,0,null);
    }
    
    public Graphics getBuffer() {
        return buffer.getGraphics();
    }
    
    public void flip() {
        getGraphics().drawImage(buffer,0,0,null);
    }   
}