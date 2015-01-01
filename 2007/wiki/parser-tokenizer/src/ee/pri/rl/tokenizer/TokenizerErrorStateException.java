package ee.pri.rl.tokenizer;


/**
 * Exception when the tokenizer reaches error state.
 * Error state is state supplied by token rules creator.
 */

public class TokenizerErrorStateException extends TokenizerException {
	private static final long serialVersionUID = -6823476839369433517L;
	
	private State oldState;
	private int lineNumber;
	private String accumulatorContents;
	private String errorString;
	
	public TokenizerErrorStateException(String message, State oldState, int lineNumber, String accumulatorContents, String errorString) {
		super(message);
		this.oldState = oldState;
		this.lineNumber = lineNumber;
		this.accumulatorContents = accumulatorContents;
		this.errorString = errorString;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public State getOldState() {
		return oldState;
	}

	public void setOldState(State oldState) {
		this.oldState = oldState;
	}

	@Override
	public String getMessage() {
		return super.getMessage() + "\nLast state was: " + oldState
		+ "\nAccumulator contents was: " + accumulatorContents
		+ "\nLine number was: " + lineNumber
		+ "\nError string was: " + errorString;
	}
}
