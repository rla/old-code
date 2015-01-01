package ee.pri.rl.parser;

/**
 * Nonterminalsymbol represents abstract symbol and
 * is defined by other symbols it may contain.
 */

public class NonterminalSymbol extends Symbol {
	private static final long serialVersionUID = -2998501641236035886L;
	
	private String[][] definitions;

	public NonterminalSymbol(String name, String[][] definitions) {
		super(name);
		this.definitions = definitions;
	}

	public String[][] getDefinitions() {
		return definitions;
	}

	public void setDefinitions(String[][] definitions) {
		this.definitions = definitions;
	}

	@Override
	public String toString() {
		return getName();
	}
	
	
}
