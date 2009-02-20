import java.util.ArrayList;
import java.util.Iterator;

public class CompositeZone
{
	private ArrayList zones;

	public CompositeZone ()
	{
		zones = new ArrayList ();
	}

	public void addZone (String p_name, double p_x, double p_y, double p_r)
	{
		zones.add (new Zone (p_name, p_x, p_y, p_r));
	}

	public void removeZone (String remStr)
	{
		Iterator i = zones.iterator();
		while (i.hasNext())
		{
			Zone z = (Zone) i.next();
			if (z.name().equals (remStr)) i.remove();
		}
	}

	public void clearZones ()
	{
		zones.clear();
	}

	public ArrayList getZones ()
	{
		return zones;
	}

	public static String checkProximity (
		CompositeZone aCZ, double aX, double aY,
		CompositeZone bCZ, double bX, double bY)
	{
		//add initial test to forget anything gr8er than a set maximum for radii
		Iterator i = aCZ.getZones().iterator();
		while (i.hasNext())
		{
			Zone aZ = (Zone)(i.next());
			Iterator j = bCZ.getZones().iterator();
			while (j.hasNext())
			{
				Zone bZ = (Zone)(j.next());
				if (Math.sqrt (Math.pow (aX + aZ.x() - bX - bZ.x(), 2) +
					Math.pow (aY + aZ.y() - bY - bZ.y(), 2)) < aZ.r() + bZ.r())
				{
					return aZ.name();
				}
			}
		}
		return null;
	}

	private class Zone
	{
		private double x, y, r;
		private String name;

		public Zone (String p_name, double p_x, double p_y, double p_r)
		{
			name = p_name;
			x = p_x;
			y = p_y;
			r = p_r;
		}

		public String name() {return name;}
		public double x() {return x;}
		public double y() {return y;}
		public double r() {return r;}
	}
}