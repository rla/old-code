package ee.pri.rl.wiki.tokenizer;

/**
 * Class for exceptions of Wiki tokenizer.
 */

public class WikiTokenizerException extends Exception {
	private static final long serialVersionUID = -5108689031438071733L;

	public WikiTokenizerException(String message) {
		super(message);
	}

	public WikiTokenizerException(String message, Throwable cause) {
		super(message, cause);
	}
}
