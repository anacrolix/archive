import java.awt.Color;
import java.util.ArrayList;
import java.awt.Graphics;
import java.util.Iterator;

public class Smoke extends Ordinance
{
	private final int LIFESPAN = 1500;

	private int age;
	private Color color;

	public Smoke (double p_x, double p_y)
	{
		super ();
		int shade = (int)(Math.random() * 255);
		color = new Color (shade, shade, shade);
		x = p_x;
		y = p_y;
		velX += Math.random() * 2 - 1;
		velY += Math.random() * 2 - 1;
		coeffG = -2;
		coeffWind = 7;
		solid = false;
		age = 0;
	}

	public void doTick (ArrayList list)
	{
		age++;
		if (age > LIFESPAN * Math.random()) hp = 0;
	}

	public void draw (Graphics g, int h)
	{
		g.setColor (color);
		g.drawOval ((int)x, h-(int)y, 1, 1);
	}
}

