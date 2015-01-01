package ee.pri.rl.tokenizer;

/**
 * Base class for tokenizer exceptions.
 */

public class TokenizerException extends Exception {
	private static final long serialVersionUID = 1L;

	public TokenizerException(String message) {
		super(message);
	}
}
