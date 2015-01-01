package ee.pri.rl.cliindexer;

import java.io.BufferedReader;
import java.io.FileReader;

import ee.pri.rl.cliindexer.data.WordDatabase;
import ee.pri.rl.cliindexer.data.WordParser;
import ee.pri.rl.cliindexer.model.Word;

/**
 * Loeb dump failidest info andmebaasi.
 * 
 * @author raivo
 */
public class DumpReader {
	
	public static void main(String[] args) throws Exception {
		String wordfile = "/arhiiv2/junk/words.dump";
		WordDatabase wordDatabase = new WordDatabase("/home/raivo/junk/words3.db");
		BufferedReader reader = new BufferedReader(new FileReader(wordfile));
		while (true) {
			String line = reader.readLine();
			if (line != null) {
				System.out.println(line);
				Word word = WordParser.parseLine(line);			
				if (word.getContents() != null) {
					wordDatabase.saveWord(word);
				}
				
			} else {
				break;
			}
		}
		reader.close();
	}

}
