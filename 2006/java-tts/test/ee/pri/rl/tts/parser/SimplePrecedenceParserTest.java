/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.List;

import ee.pri.rl.tts.constructor.model.grammar.Grammar;
import ee.pri.rl.tts.constructor.model.grammar.GrammarException;
import ee.pri.rl.tts.constructor.model.grammar.Terminal;
import ee.pri.rl.tts.tokenizer.SimpleTokenizer;
import ee.pri.rl.tts.tokenizer.TokenTerminal;
import ee.pri.rl.tts.tokenizer.TokenizeException;

/**
 * @author raivo
 */
public class SimplePrecedenceParserTest {

	public static void main(String[] args) {
		try {
			/*Loeme sisse grammatika*/
			Grammar grammar = Grammar.read("/home/raivo/workspace/tts/test-data/TRI.GRM");
			System.out.println(grammar);
			/*Loome uue tokenisaatori*/
			SimpleTokenizer tokenizer = new SimpleTokenizer(grammar);
			/*Tokeniseerime lähteteksti*/
			List<TokenTerminal> terminals = tokenizer.tokenizeFile("/home/raivo/workspace/tts/test-data/P11.TRI");
			System.out.println("Tokeniseerimise järel saadi:");
			for (Terminal terminal : terminals) {
				System.out.print(terminal + ".");
			}
			/*Loome grammatika põhjal analüsaatori*/
			SimplePrecedenceParser parser = new SimplePrecedenceParser(grammar);
			/*Analüüsime tokeniseeritud lähteteksti*/
			parser.parse(terminals);
			
		} catch (GrammarException e) {
			e.printStackTrace();
		} catch (TokenizeException e) {
			e.printStackTrace();
		} catch (ParserException e) {
			e.printStackTrace();
		}	
	}

}
