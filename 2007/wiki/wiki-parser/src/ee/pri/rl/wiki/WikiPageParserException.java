package ee.pri.rl.wiki;

/**
 * Base class for Wiki page parser exceptions.
 */

public class WikiPageParserException extends Exception {
	private static final long serialVersionUID = 8099954143492085762L;

	public WikiPageParserException(String message) {
		super(message);
	}
	
	public WikiPageParserException(String message, Throwable cause) {
		super(message, cause);
	}
}
