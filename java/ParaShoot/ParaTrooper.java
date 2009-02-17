import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Color;

public class ParaTrooper extends Ordinance
{
	private final int CHUTE_W = 20, CHUTE_H = 10;
	private int age;
	private boolean chuteOut, hasChuteLeft = true;

	public ParaTrooper (double p_x, double p_y, double iAngle, double vel)
	{
		super (p_x, p_y, vel * Math.cos (iAngle), vel * Math.sin (iAngle));
		//initialize man zones
		impactZones.addZone ("main", 0, -5, 5);
		impactZones.addZone ("main", 0, 3, 3);
		solid = true;
	}

	public void draw (Graphics g, int h)
	{
		int x = (int)this.x;
		int y = (int)this.y;
		//draw parachute if currently chuting
		if (chuteOut)
		{
			g.setColor (Color.white);
			//draw chute
			g.fillArc (x-20, h-(y+40), 40, 40, 0, 180);
			//draw connecting lines
			g.drawLine (x-20, h-(y+20), x-4, h-y);
			g.drawLine (x-8, h-(y+20), x-4, h-y);
			g.drawLine (x+8, h-(y+20), x+4, h-y);
			g.drawLine (x+20, h-(y+20), x+4, h-y);


		}
		//draw man
		g.setColor (Color.white);
		//head
		g.drawOval (x-3, h-(y+6), 6, 6);
		//body
		g.drawOval (x-4, h-y, 8, 10);
		//left arm
		g.drawLine (x-8, h-(y-3), x-4, h-(y-3));
		//right arm
		g.drawLine (x+4, h-(y-3), x+8, h-(y-3));
		//left leg
		g.drawLine (x-2, h-(y-10), x-4, h-(y-15));
		//right leg
		g.drawLine (x+2, h-(y-10), x+4, h-(y-15));
	}

	public void doTick (ArrayList list)
	{
		age++;
		//wait for a certain velocity or age then trigger the parachute
		if (velY < -3 && chuteOut == false && hasChuteLeft)
		{
			chuteOut = true;
			coeffG = 0;
			coeffWind = 2;
			velY += 2;
			impactZones.addZone ("chute", 0, 20, 18);
			hasChuteLeft = false;
		}
		if (y <= 15 && chuteOut)
		{
			chuteOut = false;
			solid = false;
			y = 15;
			isActive = false;
		}
		else if (y <= 10 && chuteOut == false)
		{
			hp = 0;
		}
	}

	public void doDeath (ArrayList list)
	{
		if (y <= 1 || (chuteOut == false && y <= 15))
		{
			for (int i = 0; i < 20; i++)
			{
				list.add (new Blood (
					Color.red,
					x, 0.1 + (int)(Math.random() * 17),
					3 * Math.PI/8 + Math.random() * Math.PI/4,
					2*Math.random(),
					1
					));
			}
		}
		else
		{
			Blood.showerBlood (list, this, 0, 0, 20, Color.red, 0.1, 0.1, 10, 1);
		}
		//shower some blood on the blood thirsty fans

		//determine current paratrooper status on death and delegate score
		if (hp <= 0 && x > 0 && x < ParaShoot.PANEL_WIDTH)
		{
			if (y <= 10 && chuteOut == false) score = 10;
			else if (y > 10 && chuteOut == false) score = 3;
			else if (y > 10 && chuteOut == true) score = 5;
		}
	}

	public boolean registerHit (String hitLoc)
	{
		if (hitLoc == "main")
		{
			hp--;
			return false;
		}
		else if (hitLoc == "chute")
		{
			chuteOut = false;
			coeffG = 1;
			coeffWind = 1;
			impactZones.removeZone ("chute");
			return true;
		}
		return true;
	}
}

