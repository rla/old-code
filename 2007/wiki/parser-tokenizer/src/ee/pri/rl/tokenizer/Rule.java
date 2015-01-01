package ee.pri.rl.tokenizer;

import java.io.Serializable;

/**
 * Abstract base class for transition rules.
 */

public abstract class Rule implements Serializable {
	private State oldState;
	private State newState;
	
	public Rule(State oldState, State newState) {
		this.oldState = oldState;
		this.newState = newState;
	}

	public State getNewState() {
		return newState;
	}

	public void setNewState(State newState) {
		this.newState = newState;
	}

	public State getOldState() {
		return oldState;
	}

	public void setOldState(State oldState) {
		this.oldState = oldState;
	}

	public final boolean applies(FixedCharacterBuffer input, State state) {
		return state.equals(oldState) && applies(input);
	}
	
	protected abstract boolean applies(FixedCharacterBuffer input);
	
	public abstract FixedCharacterBuffer eat(FixedCharacterBuffer input);

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Rule) {
			Rule other = (Rule) obj;
			return other.getOldState().equals(oldState) && other.getNewState().equals(newState);
		} else {
			return false;
		}
	}
	
	
}
