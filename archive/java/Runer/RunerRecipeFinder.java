import java.util.ArrayList;

public class RunerRecipeFinder
{
	private final String COMBO_HEADER = "<combo>", COMBO_FOOTER = "</combo>",
		CRAFTED_HEADER = "<crafted>", CRAFTED_FOOTER = "</crafted>";
	private final String[]
		CATEGORY_MELEE = {"Melee","Axe","Claws","Club","Hammer","Mace","Polearm","Scepter","Staff","Sword","Wand"},
		CATEGORY_SHIELD = {"SHIELD","SHIELD(PALADIN)"};

	private final String ASTERIX_ROW = "**************************************"
		+ "***************";
	private RunerDataReader data;

	public RunerRecipeFinder (String fileName)
	{
		data = new RunerDataReader (fileName);
	}

	private boolean isStringInArray (String str, String[] array)
	{
		boolean inArray = false;
		for (int index = 0; index < array.length; index++)
			if (array[index].equalsIgnoreCase (str))
			{
				inArray = true;
				break;
			};
		return inArray;
	}

	private boolean checkItemType (String item, String required)
	{
		boolean correctItemType = false;
		if (item.equalsIgnoreCase ("ANY ITEM"))
		{
			correctItemType = true;
		}
		else if (item.equalsIgnoreCase ("SHIELD(PALADIN)"))
		{
			if (isStringInArray (required, CATEGORY_SHIELD))
			{
				correctItemType = true;
			}
		}
		else if (item.equals ("ANY MELEE"))
		{
			if (isStringInArray (required, CATEGORY_MELEE))
			{
				correctItemType = true;
			}
		}
		else if (item.equalsIgnoreCase ("ANY MISSILE") && required.equalsIgnoreCase ("MISSILE"))
		{
			correctItemType = true;
		}
		else if (item.equals ("ANY WEAPON"))
		{
			if (isStringInArray (required, CATEGORY_MELEE) || required.equals ("MISSILE") || required.equals ("WEAPON"))
			{
				correctItemType = true;
			}
		}
		else if (required.equals ("MELEE"))
		{
			if (isStringInArray (item, CATEGORY_MELEE))
			{
				correctItemType = true;
			}
		}
		else if (required.equals ("WEAPON"))
		{
			if (isStringInArray (item, CATEGORY_MELEE) ||
				item.equals ("ANY MELEE") || item.equals ("ANY MISSILE") ||
				item.equals ("ANY WEAPON"))
			{
				correctItemType = true;
			}
		}
		else
		{
			if (required.equalsIgnoreCase (item.toString()))
			{
				correctItemType = true;
			}
		}
		return correctItemType;
	}

	public String findCrafted (ArrayList gems, ArrayList runes)
	{
		String recipes = "";
		int numRecipes = 0;
		while (data.findHeader (CRAFTED_HEADER) == true)
		{
			data.nextWord();
			if (gems.contains (data.getWord()))
			{
				data.nextWord();
				if (runes.contains (data.getWord()))
				{
					data.nextLine();
					numRecipes++;
					recipes += "\n";
					while (!(data.getWord().equals (CRAFTED_FOOTER)))
					{
						recipes += "\n" + data.getLine();
						data.nextLine();
					}
				}
			}
		}

		String searchResult = ASTERIX_ROW + "\nSearch for crafted items gave "
			+ numRecipes + " results." + recipes + "\n\n";

		return searchResult;
	}

	public String findCombos (ArrayList runes, String item, int slots, boolean ignoreSlots)
	{
		String recipes = "";
		int numRecipes = 0;
		while (data.findHeader (COMBO_HEADER) == true)
		{
			data.nextWord();

			boolean isItemMatch = false;
			boolean moveOn;
			if (checkItemType (item.toUpperCase(), data.getWord().toUpperCase()))
				isItemMatch = true;
			do
			{
				data.nextWord();
				moveOn = true;
				try
				{
					Integer.parseInt (data.getWord());
				}
				catch (NumberFormatException exception)
				{
					if(checkItemType (item.toUpperCase(), data.getWord().toUpperCase()))
						isItemMatch = true;
					moveOn = false;
				}
			}
			while (moveOn == false);

			if (isItemMatch)
			{
				if (Integer.parseInt(data.getWord()) == slots || ignoreSlots)
				{
					boolean haveRunes = true;
					data.nextWord();
					while (data.getWord() != "last" && haveRunes == true)
					{
						if (!(runes.contains (data.getWord())))
							haveRunes = false;
						data.nextWord();
					}
					if (haveRunes)
					{
						data.nextLine();
						numRecipes++;
						recipes += "\n";
						while (!(data.getWord().equals (COMBO_FOOTER)))
						{
							recipes += "\n" + data.getLine();
							data.nextLine();
						}
					}
				}
			}
		}
		String slotsStr = (ignoreSlots) ? "ANY" : String.valueOf (slots);
		String searchResult = ASTERIX_ROW
			+ "\nSearch for " + slotsStr + " SOCKET " + item.toUpperCase()
			+ " gave " + numRecipes + " results." + recipes + "\n\n";

		return searchResult;
	}
}