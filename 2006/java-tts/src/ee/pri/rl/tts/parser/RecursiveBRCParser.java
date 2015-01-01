/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.List;

import ee.pri.rl.tts.parser.tree.ParseTree;
import ee.pri.rl.tts.tokenizer.TokenTerminal;

/**
 * Rekursiivne BRC(1,1)-redutseeritava eelnevusgrammatika
 * analüsaator.
 * @author raivo
 */
public class RecursiveBRCParser implements Parser {

	/* (non-Javadoc)
	 * @see ee.pri.rl.tts.parser.Parser#parse(java.util.List)
	 */
	public ParseTree parse(List<TokenTerminal> tokens) throws ParserException {
		ParseTree parseTree = new ParseTree();
		parseRecursive(tokens, parseTree);
		return parseTree;
	}
	
	private void parseRecursive(List<TokenTerminal> words, ParseTree tree) throws ParserException {
		
	}

}
