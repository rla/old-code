package ee.pri.rl.parser;

/**
 * Exception that is thrown when parsing fails at some point.
 */

public class ParserFailedException extends ParserException {
	private static final long serialVersionUID = 624248974006065608L;
	
	private int lineNumber;

	public ParserFailedException(String message, int lineNumber) {
		super(message);
		this.lineNumber = lineNumber;
	}

	public int getLineNumber() {
		return lineNumber;
	}
}
