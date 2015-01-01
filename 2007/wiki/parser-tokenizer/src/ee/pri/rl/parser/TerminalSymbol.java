package ee.pri.rl.parser;

/**
 * Represents terminal symbol. Terminal symbol represents
 * some token.
 */

public class TerminalSymbol extends Symbol {
	private static final long serialVersionUID = -1516845935949471037L;
	
	private String tokenName;

	public TerminalSymbol(String name, String tokenName) {
		super(name);
		this.tokenName = tokenName;
	}

	public String getTokenName() {
		return tokenName;
	}

	public void setTokenName(String tokenName) {
		this.tokenName = tokenName;
	}

	@Override
	public String toString() {
		return getName() + ":" + tokenName;
	}
}
