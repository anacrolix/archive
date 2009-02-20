import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Color;

public class Bomb extends Ordinance
{
	private final int FLAME_X = 3, FLAME_Y = 3;

	private final int SIZE = 20;
	private int age;
	private boolean wickFacing;

	public Bomb (double p_x, double p_y, double iAngle, double vel)
	{
		super (p_x, p_y, vel * Math.cos (iAngle), vel * Math.sin (iAngle));
		impactZones.addZone ("main", 0, 0, 10);
		coeffWind = 0.7;
		wickFacing = (Math.random() < 0.5) ? true : false;
		hp = 4;
	}

	public void draw (Graphics g, int h)
	{
		g.setColor (Color.gray);
		g.fillOval ((int) (x - SIZE / 2),(int) (h - y - SIZE / 2),SIZE ,SIZE);
		g.setColor (Color.white);
		int flameX, flameY;
		if (wickFacing)
		{
			g.drawArc ((int)x,(int)(h-y)-(int)(SIZE/1.3),
				(int)(SIZE/2),(int)(SIZE/2),90,90);
			flameX = (int)(x+SIZE/4);
			flameY = (int)(h-y-SIZE/1.3);
		}
		else
		{
			g.drawArc ((int)(x-SIZE/2),(int)(h-y)-(int)(SIZE/1.3),
				(int)SIZE/2,(int)SIZE/2,0,90);
			flameX = (int)(x-SIZE/4);
			flameY = (int)(h-y-SIZE/1.3);
		}
		g.setColor (Color.red);
		switch (age % 3)
		{
			case 0:
				g.setColor (Color.red);
				break;
			case 1:
				g.setColor (Color.orange);
				break;
			case 2:
				g.setColor (Color.yellow);
				break;
		}
		if (age % 2 == 0)
		{
			g.drawLine (flameX-FLAME_X, flameY-FLAME_Y,flameX+FLAME_X,flameY+FLAME_Y);
			g.drawLine (flameX-FLAME_X, flameY+FLAME_Y,flameX+FLAME_X,flameY-FLAME_Y);
		}
		else
		{
			g.drawLine (flameX-FLAME_X, flameY, flameX+FLAME_X, flameY);
			g.drawLine (flameX, flameY-FLAME_Y, flameX, flameY+FLAME_Y);
		}
	}

	public void doTick (ArrayList eList)
	{
		age++;
		if (y <= 5)
		{
			damage = 5;
			hp = 0;
		}
	}

	public void doDeath (ArrayList list)
	{
		Blood.showerBlood (list, this, 0, 0, 20, Color.gray, 2, 2, SIZE/2, 1);
		list.add (new Explosion (
			x, y, Color.yellow, Color.red, 20, 70, 5, 100));

		if (hp <= 0 && y > 0) score = 25;
	}

	public boolean registerHit (String hitLoc)
		{
			if (hitLoc == "main") hp--;
			return false;
	}
}

