/**
 * 
 */
package ee.pri.rl.constructor.model.grammar;

import ee.pri.rl.tts.constructor.model.grammar.Grammar;
import ee.pri.rl.tts.constructor.model.grammar.GrammarException;

/**
 * @author raivo
 * Grammatika sisselugeja testimine.
 */
public class GrammarReadTest {
	
	private static Grammar grammar;
	
	public static Grammar getGrammar() {
		return grammar;
	}

	public static void setUp() {
		String filename = "/home/raivo/workspace/tts/test-data/JAVA.GRM";
		try {
			grammar = Grammar.read(filename);
		} catch (GrammarException e) {
			e.printStackTrace();
		}		
	}

	public static void main(String[] args) {
			setUp();
			System.out.println(grammar);
	}
}
