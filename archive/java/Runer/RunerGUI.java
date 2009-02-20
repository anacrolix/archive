import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.ArrayList;

public class RunerGUI
{
	private final int GRID_HEIGHT = 5, GRID_WIDTH = 8;
	private final String[] RUNE_NAMES =
	{"AMN","BER","CHAM","DOL","EL","ELD","ETH","FAL","GUL","HEL","IO","IST","ITH","JAH","KO","LEM","LO","LUM","MAL",
	"NEF","OHM","ORT","PUL","RAL","SHAEL","SOL","SUR","TAL","TIR","THUL","UM","VEX","ZOD"};
	private final String[] DUMMY_ITEM_LIST =
	{"Any Item",
	"Armor","Helm",
	"Shield","Shield(Paladin)",
	"Any Weapon","Any Melee","Any Missile","Axe","Claws","Club","Hammer","Mace","Polearm","Scepter","Staff","Sword","Wand"
	};
	private final String[] DUMMY_GEM_LIST =
	{"Amethyst","Diamond","Emerald","Ruby","Sapphire","Topaz"};
	private final String[] DATA_FILE_NAMES = {"v110.rune"};
	private JFrame frame;
	private JPanel primary, runePanel, craftedTab, comboTab, selectPanel, slotPanel, gemPanel;
	private JTabbedPane tabbedPane;
	private JMenuBar menu;
	private JCheckBox[] runeCheckBox, gemCheckBox;
	private JCheckBox matchAllSlotsCheckBox;
	private JComboBox itemList;
	private JSlider slotSlider;
	private JButton findComboButton, findCraftedButton, selectAllButton, selectNoneButton;
	private JScrollPane scrollPane;
	private JTextArea recipeTextArea;
	private Runer main;

public static ImageIcon createImageIcon(String path,
                                           String description) {
    java.net.URL imgURL = Runer.class.getResource(path);
    if (imgURL != null) {
        return new ImageIcon(imgURL, description);
    } else {
        System.err.println("Couldn't find file: " + path);
        return null;
    }
}

	public RunerGUI()
	{
		// *********************************************************
		// runePanel (checkboxes for selecting which runes you have)

		runePanel = new JPanel (new GridLayout (GRID_HEIGHT, GRID_WIDTH));
		runePanel.setBorder (BorderFactory.createTitledBorder ("Runes Available"));
		//runePanel.setBackground (Color.black);
		runeCheckBox = new JCheckBox[RUNE_NAMES.length];

		for (int index = 0; index < RUNE_NAMES.length; index++)
		{
			//create check box and image
			ImageIcon runeImage = createImageIcon ("resources/" + RUNE_NAMES[index].toLowerCase() + ".JPG", "rune icon");
			JLabel runeIconLabel = new JLabel (runeImage);
			runeCheckBox[index] = new JCheckBox (RUNE_NAMES[index]);
			//runeCheckBox[index].setBackground (Color.black);
			//add check box and image to own panel
			JPanel runeCheckIconPanel = new JPanel ();
			runeCheckIconPanel.setLayout (new BoxLayout (runeCheckIconPanel, BoxLayout.X_AXIS));
			runeCheckIconPanel.add (runeIconLabel);
			//runeCheckIconPanel.add (Box.createHorizontalGlue());
			runeCheckIconPanel.add (runeCheckBox[index]);
			//runeCheckIconPanel.setBackground (Color.black);
			//add that panel to main runePanel
			runePanel.add (runeCheckIconPanel);
		}

		// *********************************************************
		// selectPanel (buttons for quicker [de]selecting of runes)
		selectAllButton = new JButton ("Select All");
		selectAllButton.addActionListener (new ButtonListener());
		selectAllButton.setMnemonic ('A');

		selectNoneButton = new JButton ("Select None");
		selectNoneButton.addActionListener (new ButtonListener());
		selectNoneButton.setMnemonic ('N');

		selectPanel = new JPanel();
		selectPanel.add (selectAllButton);
		selectPanel.add (selectNoneButton);

		// *********************************************************
		// comboTab (panel for choosing wot item and num slots you wish to search)
		itemList = new JComboBox(DUMMY_ITEM_LIST);

		slotSlider = new JSlider (2, 6, 2);
		slotSlider.setMajorTickSpacing (1);
		slotSlider.setPaintLabels (true);
		slotSlider.setPaintTicks (true);
		slotSlider.setSnapToTicks (true);
		slotSlider.setToolTipText ("Selects number of slots in desired recipe");

		matchAllSlotsCheckBox = new JCheckBox ("Match All Slots");
		matchAllSlotsCheckBox.addItemListener (new CheckBoxListener());
		matchAllSlotsCheckBox.setToolTipText ("Ignores number of slots in search if ticked");

		slotPanel = new JPanel();
		slotPanel.setLayout (new BoxLayout (slotPanel, BoxLayout.Y_AXIS));
		slotPanel.add (slotSlider);
		slotPanel.add (matchAllSlotsCheckBox);

		findComboButton = new JButton ("Search");
		findComboButton.addActionListener (new ButtonListener());
		findComboButton.setMnemonic ('S');
		findComboButton.setToolTipText ("Initiate Rune Combo Search with desired parameters");

		comboTab = new JPanel();
		comboTab.add (itemList);
		comboTab.add (slotPanel);
		comboTab.add (findComboButton);

		// *********************************************************
		// crafted item panel setup
		gemCheckBox = new JCheckBox[DUMMY_GEM_LIST.length];
		gemPanel = new JPanel(new GridLayout (2, 3));

		for (int index = 0; index < DUMMY_GEM_LIST.length; index++)
		{
			gemCheckBox[index] = new JCheckBox (DUMMY_GEM_LIST[index]);
			gemPanel.add (gemCheckBox[index]);
		}
		findCraftedButton = new JButton ("Search");
		findCraftedButton.addActionListener (new ButtonListener());
		findCraftedButton.setMnemonic ('S');

		craftedTab = new JPanel();
		//craftedTab.setLayout (new BoxLayout (craftedTab, BoxLayout.X_AXIS));
		craftedTab.add (gemPanel);
		//craftedTab.add (Box.createHorizontalGlue());
		craftedTab.add (findCraftedButton);

		// *********************************************************
		// tabbed pane setup
		tabbedPane = new JTabbedPane();
		tabbedPane.add ("Rune Word Items", comboTab);
		tabbedPane.add ("Crafted Items", craftedTab);

		// *********************************************************
		// scrollpane setup
		recipeTextArea = new JTextArea (23, 70);
		recipeTextArea.setFont (new Font("Courier", Font.PLAIN, 12));
		scrollPane = new JScrollPane (recipeTextArea);
		scrollPane.setBorder (BorderFactory.createRaisedBevelBorder());

		// *********************************************************
		// primary panel set up
		primary = new JPanel();
		primary.setLayout(new BoxLayout (primary, BoxLayout.Y_AXIS));
		primary.add (runePanel);
		primary.add (selectPanel);
		primary.add (tabbedPane);
		primary.add (scrollPane);
	}

	public JPanel getPanel()
	{
		return primary;
	}

	public void appendToRecipes (String str)
	{
		recipeTextArea.append (str);
	}

	private ArrayList createRuneList()
	{
		ArrayList runeList = new ArrayList();
		for (int index = 0; index < RUNE_NAMES.length; index++)
			if (runeCheckBox[index].isSelected())
				runeList.add (RUNE_NAMES[index]);
		return runeList;
	}
	private ArrayList createGemList()
	{
		ArrayList gemList = new ArrayList();
		for (int index = 0; index < DUMMY_GEM_LIST.length; index++)
			if (gemCheckBox[index].isSelected())
				gemList.add (DUMMY_GEM_LIST[index].toUpperCase());
		return gemList;
	}

	private class ButtonListener implements ActionListener
	{
		public void actionPerformed (ActionEvent event)
		{
			Object source = event.getSource();
			if (source == findComboButton)
			{
				String selectedItemType = itemList.getSelectedItem().toString();
				int numSlots = slotSlider.getValue();
				String dataFileName = DATA_FILE_NAMES[0];
				ArrayList runeList = createRuneList();
				boolean ignoreSlots = matchAllSlotsCheckBox.isSelected();
				RunerRecipeFinder finder = new RunerRecipeFinder("resources/" + dataFileName);
				recipeTextArea.append (finder.findCombos (runeList, selectedItemType, numSlots, ignoreSlots));
			}
			else if (source == findCraftedButton)
			{
				ArrayList gems = createGemList(), runes = createRuneList();
				String fileName = DATA_FILE_NAMES[0];
				RunerRecipeFinder finder = new RunerRecipeFinder("resources/" + fileName);
				recipeTextArea.append (finder.findCrafted (gems,runes));
			}
			else if (source == selectAllButton)
				for (int index = 0; index < RUNE_NAMES.length; index++)
					runeCheckBox[index].setSelected (true);
			else if (source == selectNoneButton)
				for (int index = 0; index < RUNE_NAMES.length; index++)
					runeCheckBox[index].setSelected (false);
		}
	}
	private class CheckBoxListener implements ItemListener
	{
		public void itemStateChanged (ItemEvent event)
		{
			slotSlider.setEnabled (!(matchAllSlotsCheckBox.isSelected()));
		}
	}
}