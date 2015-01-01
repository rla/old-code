/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.List;

import ee.pri.rl.tts.parser.tree.ParseTree;
import ee.pri.rl.tts.tokenizer.TokenTerminal;

/**
 * Parseri liides.
 * @author raivo
 */
public interface Parser {
	public ParseTree parse(List<TokenTerminal> tokens) throws ParserException;
}
