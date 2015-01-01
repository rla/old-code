package ee.pri.rl.tokenizer;

/**
 * Rule for transition at the end of the input.
 */

public class EndRule extends Rule {
	private static final long serialVersionUID = -6687617069776068835L;
	
	public EndRule(State oldState, State newState) {
		super(oldState, newState);
	}

	@Override
	public boolean applies(FixedCharacterBuffer input) {
		return input.length() == 0;
	}

	@Override
	public FixedCharacterBuffer eat(FixedCharacterBuffer input) {
		return input.getPrefix(0);
	}

}
