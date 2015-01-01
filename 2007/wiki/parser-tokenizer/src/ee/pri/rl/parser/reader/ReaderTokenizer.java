package ee.pri.rl.parser.reader;

import java.util.List;

import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * Tokenizer for parser table rule file reader.
 */

public class ReaderTokenizer {
	private static SerializableTokenizer tokenizer;
	
	static {
		try {
			tokenizer = SerializableTokenizer.readFromResource("/ee/pri/rl/parser/reader/tokenizer.rules.ser");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Tokenize input string that represents the grammar that is being read.
	 */
	
	public static List<Token> tokenize(String input) throws TokenizerException {
		return tokenizer.tokenize(input);
	}
}
