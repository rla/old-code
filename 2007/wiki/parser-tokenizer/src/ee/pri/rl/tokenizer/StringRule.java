package ee.pri.rl.tokenizer;

/**
 * Rule for transition on input string prefix.
 */

public class StringRule extends Rule {
	private static final long serialVersionUID = 8478905234312185987L;
	
	private String prefix;
	
	public StringRule(State oldState, State newState, String prefix) {
		super(oldState, newState);
		this.prefix = prefix;
	}

	public String getPrefix() {
		return prefix;
	}

	public void setPrefix(String prefix) {
		this.prefix = prefix;
	}

	@Override
	public boolean applies(FixedCharacterBuffer input) {
		return input.startsWith(prefix);
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof StringRule ? super.equals(obj) && ((StringRule) obj).getPrefix().equals(prefix) : false;
	}

	@Override
	public FixedCharacterBuffer eat(FixedCharacterBuffer input) {
		FixedCharacterBuffer eaten = input.getPrefix(prefix.length());
		input.deletePrefix(prefix.length());
		return eaten;
	}
}
