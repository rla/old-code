package ee.pri.rl.cliindexer;

import ee.pri.rl.cliindexer.data.WordDatabase;
import ee.pri.rl.cliindexer.model.Word;

/**
 * Etteantud sõna id leidmine.
 * 
 * @author raivo
 */
public class WordSearch {
	public static void main(String[] args) {
		if (args.length == 0) {
			System.out.println("Sisesta otsitav sõna argumendina");
		} else {
			WordDatabase wordDatabase = new WordDatabase("/home/raivo/junk/words3.db");
			long start = System.currentTimeMillis();
			Word word = wordDatabase.getWord(args[0]);
			if (word == null) {
				System.out.println("sõna ei eksisteeri");
			} else {
				System.out.println("Sõna: " + word);
				System.out.println("id = " + word.getId());
				System.out.println("count = " + word.getCount());
			}
			System.out.println("aega läks: " + (System.currentTimeMillis() - start) + "ms");
		}
	}
}
