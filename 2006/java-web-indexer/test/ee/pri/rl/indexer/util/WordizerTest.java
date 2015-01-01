package ee.pri.rl.indexer.util;

import java.util.Set;

import junit.framework.TestCase;
import ee.pri.rl.indexer.indexing.Wordizer;
import ee.pri.rl.indexer.model.Word;

/**
 * Sõnadeks jaotaja testimine.
 * 
 * @author raivo
 */
public class WordizerTest extends TestCase {

	/**
	 * Kontrollime, kas sõne sõnadeks lahutaja töötab õigesti.
	 */
	public void testWordizeTest() {
		Set<Word> words = Wordizer.wordizeString(
				"Tere Tere! Mina olen arvuti.".toCharArray());
		System.out.println(words);
		assertTrue(words.contains(new Word("Tere")));
		assertFalse(words.contains(new Word("mina")));
		assertEquals(words.size(), 4);
	}

}
