/**
 * 
 */
package ee.pri.rl.tts.tokenizer;

import java.util.List;

import ee.pri.rl.constructor.model.grammar.GrammarReadTest;
import ee.pri.rl.tts.constructor.model.grammar.Terminal;

/**
 * @author raivo
 *
 */
public class GeneralTokenizerTest extends GrammarReadTest {
	
	public static void main(String[] args) {
		setUp();
		System.out.println(getGrammar());

		GeneralTokenizer tokenizer = new GeneralTokenizer(getGrammar());
		try {
			List<TokenTerminal> terminals = tokenizer.tokenizeFile("/home/raivo/workspace/tts/test-data/KONSTANT.PRG");
			System.out.println("Tokeniseerimise järel saadi:");
			for (Terminal terminal : terminals) {
				System.out.print(terminal + ".");
			}
		} catch (TokenizeException e) {
			e.printStackTrace();
		}
	}

}
