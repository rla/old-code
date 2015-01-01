/**
 * 
 */
package ee.pri.rl.tts.tokenizer;

import java.util.List;

/**
 * Tokeniseeriate liides.
 * @author raivo
 */
public interface Tokenizer {
	public List<TokenTerminal> tokenize(String input) throws TokenizeException;
	public List<TokenTerminal> tokenizeFile(String filename) throws TokenizeException;
}
