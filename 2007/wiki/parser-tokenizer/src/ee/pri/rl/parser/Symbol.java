package ee.pri.rl.parser;

import java.io.Serializable;

/**
 * Represents parser symbol. Symbol can be terminal
 * or nonterminal symbol.
 */

public class Symbol implements Serializable {
	private static final long serialVersionUID = -9047408394844518674L;
	
	private String name;
	
	public Symbol(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof Symbol ? ((Symbol) obj).getName().equals(name) : false;
	}
}
