import java.io.*;
import java.util.StringTokenizer;
import javax.swing.*;

public class RunerDataReader
{
	public final String NO_MORE_TOKENS = "last";


	private FileReader fr;
	private BufferedReader inFile;
	private StringTokenizer tokenizer;
	private String line, word;
/*
protected static FileReader createFileReader(String path) {
    java.net.URL frURL = RunerDataReader.class.getResource(path);
    if (frURL != null) {
        return new FileReader(frURL);
    } else {
        System.err.println("Couldn't find file: " + path);
        return null;
    }
}
*/
	public RunerDataReader (String fileName)
	{
		//inFile = new InputStreamReader(url.openStream());
		inFile = new BufferedReader (new InputStreamReader(getClass().getResourceAsStream(fileName)));
		/*
		try
		{
			URL url = new URL (fileName);
			//fr = new FileReader(this.getClass().getResource(fileName));
			inFile = new BufferedReader (fr);
		}
		catch (FileNotFoundException exception)
		{
			JOptionPane.showMessageDialog (null, "The data file " + fileName + "was not found.");
		}
		catch (IOException exception)
		{
			JOptionPane.showMessageDialog (null, exception);
		}
		*/
	}

	public boolean findHeader (String header)
	{
		boolean headerFound = false;
		boolean endOfFile = false;
		do
		{
			nextLine();
			if (line == null) endOfFile = true;
			if (getWord().equalsIgnoreCase (header)) headerFound = true;
		}
		while (!endOfFile && !headerFound);
		return (line != null);
	}

	public String getLine()
	{
		return line;
	}

	public void nextLine()
	{
		try
		{
			line = inFile.readLine();
		}
		catch (IOException exception)
		{
			JOptionPane.showMessageDialog (null, exception);
		}
		if (line != null)
			tokenizer = new StringTokenizer (line);
		else
			tokenizer = new StringTokenizer ("empty line!");
		nextWord();
	}

	public String getWord()
	{
		return word;
	}

	public void nextWord()
	{
		if (tokenizer.hasMoreTokens() == true)
			word = tokenizer.nextToken();
		else
			word = NO_MORE_TOKENS;
	}
}