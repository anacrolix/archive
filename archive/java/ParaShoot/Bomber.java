import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Color;
import java.awt.Polygon;

public class Bomber extends Ordinance
{
	private int age;
	private int[]
		polyX = {-40,-30,30, 35, 40, 40, 35,-30},
		polyY = {0,  5,  5,	 15, 15, -2,  -5,-5};
	private boolean goingRight, alive;
	private Color color = Color.blue;

	public Bomber (double p_y, double p_vel)
	{
		super ();
		alive = true;
		y = p_y;
		velY = 0;
		if (Math.random() < 0.5)
		{
			x = -39;
			velX = p_vel;
			goingRight = true;
		}
		else
		{
			x = ParaShoot.PANEL_WIDTH + 39;
			velX = -p_vel;
			goingRight = false;
		}
		impactZones.addZone ("main", -25, 0, 15);
		impactZones.addZone ("main", -10, 0, 15);
		impactZones.addZone ("main", 0, 0, 15);
		impactZones.addZone ("main", 10, 0, 15);
		impactZones.addZone ("main", 25, 0, 15);
		coeffWind = 0;
		coeffG = 0;
		hp = 10;
		//translate drawing coordinantes as necessary
		if (goingRight)
		{
			System.out.println ("switching coords");
			for (int i = 0; i < polyX.length / 2; i++)
			{
				//switch x positions
				int tX = polyX[i];
				polyX[i] = polyX[polyX.length - 1 - i];
				polyX[polyX.length - 1 - i] = tX;
				//switch y positions
				int tY = polyY[i];
				polyY[i] = polyY[polyY.length - 1 - i];
				polyY[polyY.length - 1 - i] = tY;
			}
		}
		for (int i = 0; i < polyY.length; i++)
		{
			polyY[i] = -polyY[i];
		}
	}

	public void draw (Graphics g, int h)
	{
		Polygon poly = new Polygon (polyX, polyY, polyX.length);
		poly.translate ((int)x, (int)(h-y));
		g.setColor(color);
		g.fillPolygon(poly);
	}

	public void doTick (ArrayList list)
	{
		age++;
		//check for corpse effect
		if (hp <= 0 && ParaShoot.inBounds(this) && y > 5 && alive)
		{
			hp = 70;
			solid = true;
			coeffG = 1;
			coeffWind = 1;
			color = new Color(100,100,100);
			list.add (new Explosion (
				x-30, y, Color.yellow, Color.red, 12, 50, 10, 20));
			list.add (new Explosion (
				x+30, y, Color.yellow, Color.red, 12, 50, 10, 20));
			score = 50;
			alive = false;
		}
		if (hp <= 0 && alive == false)
		{
			score = 100;
		}
		//check for hitting ground
		if (y < 5)
		{
			list.add (new Explosion (
				x, y, Color.white, Color.yellow, 24, 100, 15, 200
				));
			hp = 0;
			damage = 15;
			score = 0;
		}
		//check for bombing

		if (age % 40 == 0 && alive)
		{
			list.add (new Bomb (
				x, y-30,
				((velX > 0) ? 7 * Math.PI / 4 : 5 * Math.PI / 4),
				Math.abs(2 * velX)
			));
		}

		if (!alive)
		{
			list.add (new Smoke (x+40, y+15));
		}
	}

	public void doDeath (ArrayList list)
	{
		/*
		public static void showerBlood (
				ArrayList p_list,
				Ordinance p_corpse,
				int p_dX,
				int p_dY,
				int p_num,
				Color p_color,
				double p_baseVel,
				double p_randVel,
				double p_spawnR,
				double p_particleR
		) */
		Blood.showerBlood (list, this, -30, 0, 20, Color.gray, 2, 2, 20, 5);
		Blood.showerBlood (list, this, 30, 0, 20, Color.gray, 2, 2, 20, 5);
	}

	public boolean registerHit (String hitLoc)
		{
			if (hitLoc == "main") hp--;
			return false;
	}
}
