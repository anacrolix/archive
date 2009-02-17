import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Color;

public class Plane extends Ordinance
{
	private int age;

	public Plane (double p_y, double p_vel, Color p_clr, int p_hp)
	{
		super ();
		y = p_y;
		velY = 0;
		if (Math.random() < 0.5)
		{
			x = -20;
			velX = p_vel;
		}
		else
		{
			x = ParaShoot.PANEL_WIDTH + 20;
			velX = -p_vel;
		}
		impactZones.addZone ("main", -25, 0, 15);
		impactZones.addZone ("main", -10, 0, 15);
		impactZones.addZone ("main", 0, 0, 15);
		impactZones.addZone ("main", 10, 0, 15);
		impactZones.addZone ("main", 25, 0, 15);
		coeffWind = 0;
		coeffG = 0;
		hp = 15;
	}

	public void draw (Graphics g, int h)
	{
		g.setColor(Color.blue);
		g.fillRect((int)(x-40), (int)(h-(y+15)), 80, 30);
	}

	public void doTick (ArrayList eList)
	{
		//fill in l8r (boming runs);
	}

	public void doDeath (ArrayList list)
	{
		Blood.showerBlood (list, this, 20, Color.gray, 3, 3, 15);
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

