import java.awt.Color;
import java.util.ArrayList;
import java.awt.Graphics;

public abstract class Ordinance
{
	public boolean isActive = true;
	public double x=0, y=0, velX=0, velY=0;
	public int hp = 1, score = 0, damage = 0;

	protected CompositeZone impactZones = new CompositeZone();
	protected double coeffG = 1, coeffWind = 1;
	protected boolean solid = true;

	public Ordinance (double p_x, double p_y, double p_velX, double p_velY)
	{
		x = p_x;
		y = p_y;
		velX = p_velX;
		velY = p_velY;
	}

	public Ordinance () {}


	public final static void checkImpact(Ordinance a, Ordinance b)
	{
		//check that both objects have solid turned on
		//catch bullet vs. bullet, bullet vs. explosion
		String 	aClass = a.getClass().getName(),
				bClass = a.getClass().getName();
		if
		(
			a.isSolid() == false || b.solid == false
			||
			(
				(aClass.equals("Bullet") || aClass.equals("Explosion"))
				&&
				(aClass.equals("Bullet") || bClass.equals("Explosion"))
			)
			||
			(
				a.isDead() || b.isDead()
			)
		)
		{
			return;
		}
		//pass the CompositeZones of each object to the static collision check
		String aZoneHit = CompositeZone.checkProximity (
			a.impactZones, a.x, a.y, b.impactZones, b.x, b.y);
		String bZoneHit = CompositeZone.checkProximity (
			b.impactZones, b.x, b.y, a.impactZones, a.x, a.y);
		if (aZoneHit != null && bZoneHit != null)
		{
			while (a.registerHit(aZoneHit) == false &&
				b.registerHit(bZoneHit) == false && b.hp > 0 && a.hp > 0);
		}
		//if death results, notify respective objects
	}

	public void doTick (ArrayList list) {}
	public final boolean isDead () {return (hp <= 0);}
	public final boolean isSolid () {return solid;}
	public final double coeffG () {return coeffG;}
	public final double coeffWind () {return coeffWind;}
	public final CompositeZone getZones () {return impactZones;}
	/**draw objects as defined in overriden method*/
	public void draw (Graphics g, int h) {}
	public void doDeath (ArrayList al) {}
	public boolean registerHit (String hitLoc)
	{
		if (hitLoc == "main")
		{
			hp--;
			return false;
		}
		return true;
	}
	public final int getScore () {return score;}
}

