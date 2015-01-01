package ee.pri.rl.tokenizer;

/**
 * Rule that uses character classes for transition.
 */

public class CharacterRule extends Rule {
	private static final long serialVersionUID = -6393909159445863886L;
	
	private CharacterClass characterClass;
	private boolean creedy;

	public CharacterRule(State oldState, State newState, CharacterClass characterClass, boolean creedy) {
		super(oldState, newState);
		this.characterClass = characterClass;
		this.creedy = creedy;
	}

	public CharacterRule(State oldState, State newState, CharacterClass characterClass) {
		this(oldState, newState, characterClass, false);
	}

	public boolean isCreedy() {
		return creedy;
	}
	
	public void setCreedy(boolean creedy) {
		this.creedy = creedy;
	}

	@Override
	protected boolean applies(FixedCharacterBuffer input) {
		return input.length() > 0 ? characterClass.isIn(input.charAt(0)) : false;
	}

	@Override
	public FixedCharacterBuffer eat(FixedCharacterBuffer input) {
		FixedCharacterBuffer eaten = input.length() > 0 && creedy ? input.getPrefix(1) : input.getPrefix(0);
		if (creedy) {
			input.deletePrefix(1);
		}
		return eaten;
	}

}
