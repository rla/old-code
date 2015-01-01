package ee.pri.rl.tokenizer;

import java.io.Serializable;

/**
 * Fixed buffer for character accumulators.
 */

public class FixedCharacterAccumulator implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private char[] characters;
	private int length = 0;
	
	public FixedCharacterAccumulator(int length) {
		characters = new char[length];
	}
	
	public void appendCharacter(char ch) {
		characters[length++] = ch;
	}
	
	public void clear() {
		length = 0;
	}

	@Override
	public String toString() {
		return new String(characters, 0, length);
	}
}
