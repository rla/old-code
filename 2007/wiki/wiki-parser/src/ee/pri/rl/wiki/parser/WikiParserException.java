package ee.pri.rl.wiki.parser;

/**
 * Class for exceptions of Wiki parser.
 */

public class WikiParserException extends Exception {
	private static final long serialVersionUID = -7178565944611891830L;

	public WikiParserException(String message) {
		super(message);
	}

	public WikiParserException(String message, Throwable cause) {
		super(message, cause);
	}
}
