package ee.pri.rl.tokenizer;

import java.io.Serializable;

/**
 * Home-grown fast and unsafe implementation of StringBuilder which
 * is optimized for operations on string prefix.
 */

public class FixedCharacterBuffer implements Serializable {
	private static final long serialVersionUID = 3225066333708705859L;
	
	private char[] characters;
	private int start;
	private int end;
	
	public FixedCharacterBuffer(char[] characters, int start, int end) {
		this.characters = characters;
		this.start = start;
		this.end = end;
	}

	public FixedCharacterBuffer(String string) {
		this(string.toCharArray());
	}
	
	public FixedCharacterBuffer(char[] characters) {
		this(characters, 0, characters.length);
	}
	
	public int length() {
		return end - start;
	}
	
	public void deletePrefix(int length) {
		start += length;
	}
	
	public FixedCharacterBuffer getPrefix(int length) {
		return new FixedCharacterBuffer(characters, start, start + length);
	}
	
	public char charAt(int i) {
		return characters[start + i];
	}

	@Override
	public String toString() {
		return new String(characters, start, end - start);
	}
	
	public boolean startsWith(String string) {
		if (string.length() > length()) {
			return false;
		}
		for (int i = start; i < start + string.length(); i++) {
			if (characters[i] != string.charAt(i - start)) {
				return false;
			}
		}
		return true;
	}
	
}
