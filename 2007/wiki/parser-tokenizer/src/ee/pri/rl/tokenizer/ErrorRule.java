package ee.pri.rl.tokenizer;

/**
 * Special transition rule for detecting errors.
 */

public class ErrorRule extends Rule {
	private static final long serialVersionUID = -3866712603957027627L;
	
	private Rule internal;
	private String message;

	public ErrorRule(Rule internal, String message) {
		super(internal.getOldState(), internal.getNewState());
		this.internal = internal;
		this.message = message;
	}

	@Override
	protected boolean applies(FixedCharacterBuffer input) {
		return internal.applies(input);
	}
	
	@Override
	public FixedCharacterBuffer eat(FixedCharacterBuffer input) {
		return internal.eat(input);
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}
