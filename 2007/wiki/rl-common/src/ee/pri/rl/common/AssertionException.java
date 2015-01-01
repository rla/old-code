package ee.pri.rl.common;

/**
 * Exception that is thrown when some assertion is violated.
 */

public class AssertionException extends RuntimeException {
	private static final long serialVersionUID = -6179192420278082733L;

	public AssertionException(String message) {
		super(message);
	}
}
