package ee.pri.rl.cliindexer;

import ee.pri.rl.cliindexer.data.WordDatabase;

/**
 * @author raivo
 *
 */
public class WordIterator {

	public static void main(String[] args) {
		WordDatabase wordDatabase = new WordDatabase("/home/raivo/junk/words3.db");
		wordDatabase.dump();
	}

}
