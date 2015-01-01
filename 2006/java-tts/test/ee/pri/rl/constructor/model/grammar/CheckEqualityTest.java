/**
 * 
 */
package ee.pri.rl.constructor.model.grammar;

import ee.pri.rl.tts.constructor.model.grammar.Word;

/**
 * @author raivo
 * 
 */
public class CheckEqualityTest extends GrammarReadTest {
	public static void main(String[] args) {
		setUp();
		System.out.println(getGrammar());
		for (Word word1 : getGrammar().getNonTerminals()) {
			for (Word word2 : getGrammar().getNonTerminals()) {
				if (word1.equals(word2)) {
					System.out.println("aaarrghhh!");
					return;
				}
			}
		}
	}

}
