import javax.swing.*;
import javax.swing.border.*;
import java.awt.event.*;
//import java.awt.Color;
import java.awt.*;

public class Runer extends JApplet
{
	private static final String APP_TITLE = "Runer 0.31";
	public static void main (String[] args)
	{
		JMenuBar menuBar = new JMenuBar();
		JFrame frame = new JFrame(APP_TITLE);
                //frame.setDefaultCloseOperation();
		frame.addWindowListener(new Runer.CloseWindowListener());

		RunerGUI gui = new RunerGUI();

		frame.getContentPane().add (gui.getPanel());

		frame.pack();
		frame.show();
	}
	public void init ()
	{
		RunerGUI gui = new RunerGUI();
		Border b1 = BorderFactory.createLineBorder (Color.red, 3);
		Border b2 = BorderFactory.createEtchedBorder ();

		gui.getPanel().setBorder (BorderFactory.createCompoundBorder(b1, b2));

		getContentPane().add (gui.getPanel());
	}
        public static class CloseWindowListener extends WindowAdapter
        {
            public void windowClosing (WindowEvent event)
            {
                JOptionPane.showMessageDialog (null,
                	"Created by Matthew Joiner 2004\n" +
                	"webpage: http://stupidape.tripod.com/\n" +
                	"email:   stupidape@hotmail.com",
                	APP_TITLE, JOptionPane.INFORMATION_MESSAGE,
                	RunerGUI.createImageIcon("resources/icon.jpg","my idiot mugg"));
                System.exit(0);
            }
        }
}