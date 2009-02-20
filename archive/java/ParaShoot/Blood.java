import java.awt.Color;
import java.util.ArrayList;
import java.awt.Graphics;
import java.util.Iterator;

public class Blood extends Ordinance
{
	private final int LIFESPAN = 4000;


	public boolean onGround = false;
	private boolean settled = false;
	private int age;
	private double size;
	private Color color;

	/**Inserts num Blood objects into eList, randomly spawned upto radius
	*distance from corpse current position at random speed upto vel
	*@see Ordinance#draw(Graphics,int)
	*@since 0.20*/
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
		)
	{
		for (int i = 0; i < p_num; i++)
		{
			p_list.add (new Blood (
				p_color,
				p_corpse.x + p_dX + 2 * Math.random() * p_spawnR - p_spawnR,
				p_corpse.y + p_dY + 2 * Math.random() * p_spawnR - p_spawnR,
				2 * Math.random() * Math.PI, p_baseVel + Math.random () * p_randVel,
				p_particleR
				));
		}

	}


	public Blood (Color p_color, double p_x, double p_y, double p_angle, double p_vel, double p_particleR)
	{
		super (p_x, p_y, p_vel * Math.cos (p_angle), p_vel * Math.sin (p_angle));
		color = p_color;
		size = p_particleR;
		coeffG = 2;
		coeffWind = 7;
		solid = false;
		age = 0;
	}

	/*public static void checkImpact(Ordinance a, Ordinance b)
	{
		//doesn't impact
	}*/

	public void doTick (ArrayList list)
	{
		age++;
		if (age > LIFESPAN * Math.random()) hp = 0;
		if (y <= 1 && x > 0 && x < ParaShoot.PANEL_WIDTH && onGround == false)
		{
			velX = 0;
			velY = 0;
			y = 1;
			hp = 1;
			coeffG = 0;
			coeffWind = 0;
			onGround = true;
			isActive = false;
		}
		if (onGround == true && settled == false)
		{
			settled = true;
			Iterator i = list.iterator();
			while (i.hasNext())
			{
				Ordinance o = (Ordinance)i.next();
				if (o.getClass().getName().equals ("Blood") && //same class
					(o == this) == false && //not same object
					(int)(y-o.y) >= 0 && (int)(y-o.y) <= 1 && //same height
					(int)(x) == (int)(o.x) && //same place
					((Blood)o).onGround == true && //settled blood
					o.isActive == false)
				{
					settled = false;
					y++;
				}
			}
		}
	}
	/**{@inheritDoc}*/
	public void draw (Graphics g, int h)
	{
		g.setColor (color);
		g.fillOval (
			(int)(x - size / 2),
			(int)(h - (y + size / 2)),
			(int)size,
			(int)size
			);
	}
}

