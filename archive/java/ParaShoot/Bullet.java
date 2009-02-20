import java.util.ArrayList;
import java.awt.Graphics;
import java.awt.Color;

public class Bullet extends Ordinance
{
	private double radius = 3;
	private Color color;

	public Bullet (double p_x, double p_y, double iAngle, double vel, Color p_color, double p_radius, double p_coeffG, int p_hp)
	{
		super (p_x, p_y, vel * Math.cos (iAngle), vel * Math.sin (iAngle));
		impactZones.addZone ("main", 0, 0, p_radius);
		color = p_color;
		coeffG = p_coeffG;
		radius = p_radius;
		hp = p_hp;
	}

	public void draw (Graphics g, int h)
	{
		g.setColor (color);
		g.fillOval (
			(int) (x - radius / 2),
			(int) (h - y - radius / 2),
			(int)radius , (int)radius);
	}

	public void doTick (ArrayList eList) {}

	public void doDeath (ArrayList list) {}
}

