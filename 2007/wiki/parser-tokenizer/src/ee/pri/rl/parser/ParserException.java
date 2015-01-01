package ee.pri.rl.parser;

/**
 * Base class for parser exceptions.
 */

public class ParserException extends Exception {
	private static final long serialVersionUID = -8413109847445906152L;

	public ParserException(String message) {
		super(message);
	}
}
