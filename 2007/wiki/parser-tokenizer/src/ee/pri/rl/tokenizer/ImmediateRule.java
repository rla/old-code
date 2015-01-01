package ee.pri.rl.tokenizer;

/**
 * Rule that applies immediately for given state without
 * caring anything about input string. Used for generating
 * helper states for parser.
 */

public class ImmediateRule extends Rule {
	private static final long serialVersionUID = -684254303874559639L;
	
	public ImmediateRule(State oldState, State newState) {
		super(oldState, newState);
	}

	@Override
	protected boolean applies(FixedCharacterBuffer input) {
		return true;
	}

	@Override
	public FixedCharacterBuffer eat(FixedCharacterBuffer input) {
		return input.getPrefix(0);
	}

}
