package ee.pri.rl.tokenizer;

/**
 * An exception that is thrown if tokenizer expects some more
 * input.
 */

public class TokenizerUnexpectedEndOfInputException extends TokenizerException {
	private static final long serialVersionUID = -4454347499012830891L;
	
	private State state;
	private String accumulatorContents;

	public TokenizerUnexpectedEndOfInputException(String message, State state, String accumulatorContents) {
		super(message);
		this.state = state;
		this.accumulatorContents = accumulatorContents;
	}

	@Override
	public String getMessage() {
		return super.getMessage() + "\nLast state was: " + state
			+ "\nAccumulator contents was: " + accumulatorContents;
	}
}
