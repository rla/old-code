package ee.pri.rl.wiki.tokenizer;

import java.util.List;

import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * Reads tokenizer rules for wiki tokenizer.
 */

public class WikiTokenizer {
	private static SerializableTokenizer tokenizer;
	
	static {
		try {
			tokenizer = SerializableTokenizer.readFromResource("/ee/pri/rl/wiki/tokenizer/tokenizer.rules.ser");
		} catch (Exception e) {
			System.out.println("Cannot deserialize the tokenizer!");
			e.printStackTrace();
		}
	}
	
	/**
	 * Tokenize given input string.
	 */
	
	public static List<Token> tokenize(String input) throws TokenizerException {
		return tokenizer.tokenize(input);
	}
}
