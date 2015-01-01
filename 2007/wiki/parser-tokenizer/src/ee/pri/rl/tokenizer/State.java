package ee.pri.rl.tokenizer;

import java.io.Serializable;

/**
 * Class for denoting the state in tokenizer.
 */

public class State implements Serializable {
	private static final long serialVersionUID = 6505402638139855258L;
	
	private String name;
	private String semantics;
	
	public State(String name, String semantics) {
		this.name = name;
		this.semantics = semantics;
	}
	
	public State(String name) {
		this(name, null);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSemantics() {
		return semantics;
	}

	public void setSemantics(String semantics) {
		this.semantics = semantics;
	}

	@Override
	public int hashCode() {
		return name.hashCode();
	}

	@Override
	public String toString() {
		return name;
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof State ? ((State) obj).getName().equals(name) : false;
	}

	@Override
	protected Object clone() throws CloneNotSupportedException {
		State state = new State(name, semantics);
		return state;
	}
	
	public boolean hasSemantics() {
		return semantics != null;
	}
}
