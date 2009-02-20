import java.awt.Color;
import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Polygon;

public class Explosion extends Ordinance
{
	private Color innerColor, outerColor;
	private double radius;
	private int age, lifespan, spikes;
	private Polygon inPoly, outPoly;


	public Explosion (double p_x, double p_y, Color p_InnerClr, Color p_OuterClr, int p_spikes, double p_radius, int p_lifespan, int p_hp)
	{
		super (p_x, p_y, 0, 0);
		coeffG = 0;
		coeffWind = 0;
		innerColor = p_InnerClr;
		outerColor = p_OuterClr;
		radius = p_radius;
		lifespan = p_lifespan;
		impactZones.addZone ("main",0, 0, radius);
		hp = p_hp;
		spikes = p_spikes;
	}

	public void doTick (ArrayList list)
	{
		age++;
		if (age >= lifespan) hp = 0;
	}
	/**draw objects as defined in overriden method*/
	public void draw (Graphics g, int h)
	{
		if (inPoly == null && outPoly == null)
		{
			//array of x and y points for inner and outer polygons with number of points
			//equal to spikes
			int[] 	inX = new int[spikes], 	inY = new int[spikes],
					outX = new int[spikes], outY = new int[spikes];
			for (int i = 0; i < spikes; i++)
			{
				double angle = i * 2 * Math.PI / spikes;
				inX[i] = (int)(((i % 2 == 0) ? 1 : 0.5) * radius / 2 * Math.random() * Math.cos (angle));
					//(Math.cos (angle) * radius / 2);
				inY[i] = (int)(((i % 2 == 0) ? 1 : 0.5) * radius / 2 * Math.random() * Math.sin (angle));
					//(Math.sin (angle) * radius / 2);
				outX[i] = (int)(((i % 2 == 0) ? 1 : 0.5) * (inX[i] + Math.cos (angle) * radius / 2));
					//(Math.cos (angle) * radius);
				outY[i] = (int)(((i % 2 == 0) ? 1 : 0.5) * (inY[i] + Math.sin (angle) * radius / 2));
					//(Math.sin (angle) * radius);
			}
			//translate point arrays to correct mapping on screen

			inPoly = new Polygon (inX, inY, spikes);
			inPoly.translate ((int)x, (int)(h-y));
			outPoly = new Polygon (outX, outY, spikes);
			outPoly.translate ((int)x, (int)(h-y));
		}

		//draw outer polygon
		if (age > 1)
		{
			g.setColor (outerColor);
			g.fillPolygon (outPoly);
		}
		//inner polygon
		g.setColor (innerColor);
		g.fillPolygon (inPoly);
	}
	public void doDeath (ArrayList al) {}
	public boolean registerHit (String hitLoc)
	{
		if (hitLoc == "main") hp--;
		return false;
	}
}

