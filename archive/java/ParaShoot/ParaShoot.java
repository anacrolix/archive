import javax.swing.*;
import java.awt.event.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.awt.image.BufferedImage;

/** Well whattaya know <b>eh!?</b> */
public class ParaShoot extends JApplet
{
	//*************************************************************************

	//CONSTANTS
	//*************************************************************************


	//GRAPHICAL

	private final Color
		PANEL_BG_CLR = Color.black,
		GUN_BASE_CLR = Color.gray,
		GUN_ROOF_CLR = Color.gray;


	public static final int
		//panel
		PANEL_WIDTH = 800,
		PANEL_HEIGHT = 800,
		//gun
		GUN_BASE_W = 70,
		GUN_BASE_H = 20,
		GUN_ROOF_W = 20,
		GUN_ROOF_H = 10,
		GUN_TURRET_TURN_X[] = {
			PANEL_WIDTH / 2 - 25,
			PANEL_WIDTH / 2,
			PANEL_WIDTH / 2 + 25},
		GUN_TURRET_TURN_Y = GUN_BASE_H + GUN_ROOF_H / 2,
		//hud
		HUD_WIND_W = 150,
		HUD_WIND_H = 15,
		HUD_HP_W = 100,
		HUD_HP_H = 15;

	//GAMEPLAY

	//guns

	private final Color[]
		GUN_BUL_CLRS = {
			new Color (200, 255, 255),
			new Color (255, 255, 200),
			new Color (150, 150, 150),
			new Color (200, 255, 200),
			new Color(150, 100, 100)},
		GUN_CLRS = {Color.gray, Color.gray, Color.white, Color.yellow, Color.green};
	private final String[]
		GUN_NAMES = {"Pop Gun", "Dacka Dacka", "Chain Gun", "Shrapper", "Flakker", "FULLY UPGRADED"};
	private final int[]
		GUN_COSTS = {25, 120, 300, 600, 2000, 99999},
		GUN_COOL_TIMES = {7, 4, 2, 8, 2},
		GUN_LENGTHS = {15, 20, 25, 15, 35},
		GUN_WIDTHS = {3, 4, 5, 9, 6},
		GUN_SHOTS = {1, 1, 1, 8, 2},
		GUN_BUL_HP = {1, 1, 1, 1, 2};
	private final double[]
		GUN_BUL_VEL = {8, 10, 10, 9, 15},
		GUN_RAND_ANGLE = {Math.PI/90, Math.PI/90, Math.PI/50, Math.PI/25, Math.PI/40},
		GUN_RAND_VEL = {1, 1, 1, 3, 1},
		GUN_BUL_R = {3, 3, 4, 3, 5},
		GUN_BUL_G = {0.7, 0.5, 0.7, 0.7, 0.5};

	//other

	private final double
		TURN_ANG_VEL = Math.PI/40,
		ACCEL_G = -0.04,
		WIND_MAX = 0.004,
		TURN_TUNE_MULT = 0.5;
	private final int
		WIND_TIME_MIN = 150,
		WIND_TIME_MAX = 900,
		HP_MAX = 100,
		MAX_GUNS = 3,
		FRAME_INTERVAL = 33;

	//*************************************************************************
	//VARIABLES
	//*************************************************************************

	//GRAPHICAL

	private ParaShootPanel panel = new ParaShootPanel();
	private Timer ticker;

	//GAME


	//general
	private ArrayList entities = new ArrayList();
	private int windChange = 0;
	private double wind = 0;
	private boolean justLoaded = true;

	//controls
	private boolean
		pause = false,
		shoot = false,
		ready = false,
		left = false,
		tuneTurn = false,
		right = false;

	//guns
	private Color[]
		gunBulClr = new Color[MAX_GUNS],
		gunClr = new Color[MAX_GUNS];
	private double[]
		gunRandVel = new double[MAX_GUNS],
		gunRandAngle = new double[MAX_GUNS],
		gunBulVel = new double[MAX_GUNS],
		gunBulR = new double [MAX_GUNS],
		gunBulG = new double [MAX_GUNS];
	private int[]
		gunTemp = new int[MAX_GUNS],
		gunCoolTimes = new int[MAX_GUNS],
		gunType = new int[MAX_GUNS],
		gunLength = new int [MAX_GUNS],
		gunWidth = new int [MAX_GUNS],
		gunShot = new int [MAX_GUNS],
		gunBulHP = new int [MAX_GUNS];

	//player

	private int
		score = 99999,
	 	assets = 0,
	 	health = HP_MAX;
	private double
		angle = Math.PI / 2;

	//*************************************************************************
	//METHODS
	//*************************************************************************

	public void init()
	{
		this.addKeyListener (new AppletKeyListener());
		this.getContentPane().add (panel);
		ticker = new Timer (FRAME_INTERVAL, new TickerListener());
		for (int i = 0; i < MAX_GUNS; i++)
		{
			gunType[i] = -1;
		}
		setGun (1, 0);
	}
	public void start()
	{
		if (!justLoaded) ticker.start();
		panel.repaint();
	}
	public void stop()
	{
		ticker.stop();
	}

	private void setGun (int index, int change)
	{
		gunBulClr[index] = GUN_BUL_CLRS[change];
		gunClr[index] = GUN_CLRS[change];
		gunRandVel[index] = GUN_RAND_VEL[change];
		gunRandAngle[index] = GUN_RAND_ANGLE[change];
		gunBulVel[index] = GUN_BUL_VEL[change];
		gunTemp[index] = 0;
		gunCoolTimes[index] = GUN_COOL_TIMES[change];
		gunType[index] = change;
		gunLength[index] = GUN_LENGTHS[change];
		gunWidth[index] = GUN_WIDTHS[change];
		gunShot[index] = GUN_SHOTS[change];
		gunBulR[index] = GUN_BUL_R[change];
		gunBulG[index] = GUN_BUL_G[change];
		gunBulHP[index] = GUN_BUL_HP[change];
	}

	private void buyItem (int slot)
	{
		if (slot <= MAX_GUNS)
		{
			if (score - assets >= GUN_COSTS[gunType[slot-1]+1])
			{
				assets += GUN_COSTS[gunType[slot-1]+1];
				setGun (slot-1, gunType[slot-1]+1);
			}
			else
			{
				JOptionPane.showMessageDialog(null,"You cannot afford this");
			}
		}
		else
		{
			System.out.println("There is no other choice atm");
		}
	}

	public static boolean inBounds (Ordinance o)
	{
		return (
			o.x > - 40 &&
			o.x < PANEL_WIDTH + 40 &&
			o.y < PANEL_HEIGHT + 40 &&
			o.y > - 40
			);
	}

	private void doImpacts ()
	{
		boolean atRem;
		Iterator i = entities.iterator();
		while (i.hasNext())
		{
			Ordinance o = (Ordinance) i.next();
			if (o.isActive && o.solid && inBounds(o))
			{
				atRem = false;
				Iterator j = entities.iterator();
				while (j.hasNext())
				{
					Ordinance p = (Ordinance)(j.next());
					//if (atRem == false && o == p) atRem = true;
					if (/*atRem == true && */
						p.solid && (o == p) == false && p.isActive && inBounds(p) &&
						!(o.getClass().getName().equals("Bullet") && p.getClass().getName().equals("Bullet"))
						)
					{
						Ordinance.checkImpact (o, p);
					}
				}
			}
		}
	}

	private void doPhysics (Ordinance e)
	{
		if (e.isActive)
		{
			e.velY += ACCEL_G * e.coeffG;
			e.velX += wind * e.coeffWind;
			e.x += e.velX;
			e.y += e.velY;
		}
		if (inBounds (e) == false)
		{
			e.hp = 0;
		}
	}

	private class ParaShootPanel extends JPanel
	{
		private Image dbImage;
		private Graphics dbg;

		public ParaShootPanel ()
		{
			//initialize panel
			setBackground (Color.black);
			setPreferredSize (new Dimension (PANEL_WIDTH, PANEL_HEIGHT));
		}
		public void paint (Graphics g)
		{
			// initialize buffer
			if (dbImage == null)
			{
				dbImage = createImage (this.getSize().width, this.getSize().height);
				dbg = dbImage.getGraphics ();
			}

			// clear screen in background
			dbg.setColor (getBackground ());
			dbg.fillRect (0, 0, PANEL_WIDTH, PANEL_HEIGHT);

			// draw elements in background
			//dbg.setColor (getForeground());
			if (justLoaded) paintIntro(dbg);
			if (!justLoaded) paintScene (dbg);
			if (pause && !justLoaded)
			{
				paintBuyMenu (dbg);
			}

			// draw image on the screen
			g.drawImage (dbImage, 0, 0, panel);
		}

		public void paintIntro (Graphics g)
		{
			g.setColor (Color.white);
			g.drawString ("press any key to begin", PANEL_WIDTH / 2 - 50, PANEL_HEIGHT / 2 + 12);
			g.drawString (
				"type 'p' to pause and buy stuff; " +
				"arrow keys to aim; " +
				"space to fire; " +
				"click here to activate the applet",
				PANEL_WIDTH / 2 - 200, PANEL_HEIGHT /2);
		}

		public void paintBuyMenu (Graphics g)
		{
			g.setColor (Color.white);
			g.drawString (
				"GAME PAUSED!",
				PANEL_WIDTH / 2 - 50,
				PANEL_HEIGHT / 2 - 50 + 12);
			g.drawString (
				"You have " + Integer.toString(score - assets) + " credits",
				PANEL_WIDTH / 2 - 50,
				PANEL_HEIGHT / 2 - 65 + 12);
			for (int i = 0; i < MAX_GUNS; i++)
			{
				g.drawString (
					i + 1 + ". " + GUN_NAMES[gunType[i] + 1],
					PANEL_WIDTH / 2 - 50,
					PANEL_HEIGHT / 2 - 65 + 12 + 30 * (i + 1));
				g.drawString (
					Integer.toString (GUN_COSTS[gunType[i] + 1]),
					PANEL_WIDTH / 2 + 40,
					PANEL_HEIGHT / 2 - 65 + 12 + 30 * (i + 1));
			}
		}
		public void paintScene (Graphics g)
		{
			//GUN(S)

			//turret

			for (int i = 0; i < MAX_GUNS; i++)
			{
				if (gunType[i] > -1)
				{
					//displacement due to widthwise displacement
					double t = gunWidth[i] / 2 * Math.sin (angle);
					//displacement due to lengthwise displacement of turret
					double l = gunLength[i] * Math.cos (angle);
					//bottom right, bottom left, top left, top right x components
					int tx[] = {(int)t,(int)-t,(int)(l-t),(int)(l+t)};
					t = gunWidth[i] / 2 * Math.cos (angle);
					l = - gunLength[i] * Math.sin (angle);
					//same as for tx[] but y components
					int ty[] = {(int)t,(int)-t,(int)(l-t),(int)(l+t)};
					Polygon tPoly = new Polygon (tx, ty, 4);
					tPoly.translate (GUN_TURRET_TURN_X[i], PANEL_HEIGHT - GUN_TURRET_TURN_Y);
					g.setColor (gunClr[i]);
					g.fillPolygon (tPoly);
					if (shoot && gunTemp[i] == gunCoolTimes[i])
					{
						g.setColor (Color.yellow);
						g.fillOval (
							(int)(GUN_TURRET_TURN_X[i] + Math.cos (angle) * (2 + gunLength[i])-gunWidth[i]/2),
							(int)(PANEL_HEIGHT - (GUN_TURRET_TURN_Y + Math.sin (angle) * (2 + gunLength[i]))-gunWidth[i]/2),
							gunWidth[i], gunWidth[i]);
					}
					/*
					g.setColor (Color.red);
					g.drawLine (GUN_TURRET_TURN_X[i], PANEL_HEIGHT-GUN_TURRET_TURN_Y,
						(int)(600 * Math.cos (angle) + GUN_TURRET_TURN_X[i]),
						(int)(PANEL_HEIGHT - (600 * Math.sin (angle) + GUN_TURRET_TURN_Y)));
					*/

				}
			}

			//base

			int x = (PANEL_WIDTH - GUN_BASE_W) / 2;
			int y = PANEL_HEIGHT - GUN_BASE_H;
			g.setColor (GUN_BASE_CLR);
			g.fillRect (x, y, GUN_BASE_W, GUN_BASE_H);

			//roof

			for (int i = 0; i < MAX_GUNS; i++)
			{
				x = (PANEL_WIDTH - GUN_BASE_W) / 2 + i * 25;
				y = PANEL_HEIGHT - (GUN_BASE_H + GUN_ROOF_H);
				g.setColor (GUN_ROOF_CLR);
				g.fillArc (x, y, GUN_ROOF_W, GUN_ROOF_H * 2, 0, 180);
			}

			//ENTITIES

			//entity list

			Iterator i = entities.iterator();
			while (i.hasNext())
			{
				Ordinance o = (Ordinance) i.next();
				if (inBounds (o))
					o.draw (g, PANEL_HEIGHT);
			}

			//HUD

			//wind meter

			//border
			g.setColor (Color.white);
			g.drawRect (PANEL_WIDTH/2 - HUD_WIND_W, 0, HUD_WIND_W * 2 + 1, HUD_WIND_H);
			//divider
			g.drawLine (PANEL_WIDTH/2, 1, PANEL_WIDTH/2, HUD_WIND_H - 1);
			//meter level
			g.setColor (Color.blue);
			x = (int)((wind < 0) ? PANEL_WIDTH / 2 - Math.abs (wind) / WIND_MAX * (HUD_WIND_W - 1) : PANEL_WIDTH / 2 + 1);
			y = 1;
			int width = (wind < 0) ? PANEL_WIDTH/2 - x : (int)(wind / WIND_MAX * HUD_WIND_W);
			int height = HUD_WIND_H - 1;
			g.fillRect (x, y, width, height);
			//text
			g.setColor (Color.white);
			g.drawString ("Wind", PANEL_WIDTH / 2 - 16, HUD_WIND_H + 12);

			//health meter

			//text
			g.setColor (Color.white);
			g.drawString ("Health", 1, PANEL_HEIGHT - 4);
			//border
			g.drawRect (50, PANEL_HEIGHT - (HUD_HP_H), HUD_HP_W, HUD_HP_H);
			//meter level
			g.setColor (Color.red);
			g.fillRect (51, PANEL_HEIGHT - (HUD_HP_H - 1),
				(HUD_HP_W - 2) * health / HP_MAX, HUD_HP_H - 2);

			//score
			g.setColor (Color.white);
			g.drawString ("Score", 1, PANEL_HEIGHT - (HUD_HP_H + 4));
			g.drawString (Integer.toString (score), 50, PANEL_HEIGHT - (HUD_HP_H + 4));

			//DEBUGGING

			//entities
			g.setColor (Color.white);
			g.drawString (
				"Number of entities: " + Integer.toString (entities.size()),
				1, 12);
		}
	}


	private class AppletKeyListener implements KeyListener
	{
		public void keyPressed (KeyEvent e)
		{
			if (!justLoaded)
			{
				switch (e.getKeyCode())
				{
					case KeyEvent.VK_1:
						buyItem (1);
						break;
					case KeyEvent.VK_2:
						buyItem (2);
						break;
					case KeyEvent.VK_3:
						buyItem (3);
						break;
					case KeyEvent.VK_SPACE:
						shoot = true;
						break;
					case KeyEvent.VK_LEFT:
						left = true;
						break;
					case KeyEvent.VK_RIGHT:
						right = true;
						break;
					case KeyEvent.VK_SHIFT:
						tuneTurn = true;
						break;
					case KeyEvent.VK_P:
						pause = !pause;
						break;
				}
				if (pause)
				{
					ticker.stop();
					panel.repaint();
				}
				else ticker.start();
			}
			else
			{
				justLoaded = false;
				ticker.start();
			}
		}
		public void keyReleased (KeyEvent e)
		{
			switch (e.getKeyCode())
			{
				case KeyEvent.VK_SPACE:
					shoot = false;
					break;
				case KeyEvent.VK_LEFT:
					left = false;
					break;
				case KeyEvent.VK_RIGHT:
					right = false;
					break;
				case KeyEvent.VK_SHIFT:
					tuneTurn = false;
					break;
			}
			//cancel key events
		}
		public void keyTyped (KeyEvent e)
		{
			//catch key types
		}
	}

	private class TickerListener implements ActionListener
	{
		private double gunX, gunY;
		public void actionPerformed (ActionEvent e)
		{
			//check controls
			if (left == true) angle += TURN_ANG_VEL * ((tuneTurn) ? TURN_TUNE_MULT : 1);
			if (right == true) angle -= TURN_ANG_VEL * ((tuneTurn) ? TURN_TUNE_MULT : 1);
			//correct values
			if (angle > Math.PI) angle = Math.PI;
			if (angle < 0) angle = 0;
			//shooting
			for (int i = 0; i < MAX_GUNS; i++)
			{
				if (gunType[i] > -1)
				{
					if (gunTemp[i] > 0) gunTemp[i]--;
					if (shoot && gunTemp[i] <= 0)
					{
						for (int shot = 0; shot < gunShot[i]; shot++)
						{
							entities.add (new Bullet (
								GUN_TURRET_TURN_X[i] + gunLength[i] * Math.cos (angle),
								GUN_TURRET_TURN_Y + gunLength[i] * Math.sin (angle),
								angle + 2 * gunRandAngle[i] * Math.random() - gunRandAngle[i],
								gunBulVel[i] + gunRandVel[i] * Math.random(),
								gunBulClr[i],
								gunBulR[i],
								gunBulG[i],
								gunBulHP[i]));
						}
						gunTemp[i] = gunCoolTimes[i];
					}
					else if (shoot == false)
					{
						if (gunType[i] >= 3)
						{
							entities.add (new Smoke (
								GUN_TURRET_TURN_X[i] + (gunLength[i] + 3) * Math.cos (angle),
								GUN_TURRET_TURN_Y + (gunLength[i] + 3) * Math.sin (angle)
							));
						}
					}
				}
			}
			if (Math.random() < 0.00)
			{
				entities.add (new Bomb (
					Math.random() * PANEL_WIDTH,
					PANEL_HEIGHT,
					3 * Math.PI / 2,
					1));
			}
			if (Math.random() < 0.03)
			{
				entities.add (new ParaTrooper (
					Math.random() * PANEL_WIDTH,
					PANEL_HEIGHT,
					3 * Math.PI / 2,
					1));
			}
			if (Math.random() < 0.01)
			{
				entities.add (new Bomber (
					PANEL_HEIGHT / 2 + Math.random() * (PANEL_HEIGHT / 2 - 20),
					3));
			}

			//wind
			windChange--;
			if (windChange <= 0)
			{
				windChange = (int)(Math.random() * (WIND_TIME_MAX - WIND_TIME_MIN)
					+ WIND_TIME_MIN);
				wind = 2 * Math.random() * WIND_MAX - WIND_MAX;
				//wind = WIND_MAX;
			}


			//PHYSICS

			Iterator i = entities.iterator();
			ArrayList newEntities = new ArrayList();
			boolean doneImpacts = false;
			while (i.hasNext())
			{
				Ordinance o = (Ordinance) i.next();
				doPhysics (o);
				if (doneImpacts == false)
				{
					doImpacts ();
					doneImpacts = true;
				}
				o.doTick (newEntities);
				if (o.isDead())
				{
					o.doDeath (newEntities);
					score += o.getScore ();
					health -= o.damage;
					i.remove();
				}
			}
			entities.addAll (newEntities);
			panel.repaint();
		}
	}
}