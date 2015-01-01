package ee.pri.rl.tokenizer;


/**
 * Character class that can be specified by suppling an array of characters
 * that this class contains.
 */

public class CharacterArrayClass implements CharacterClass {
	private static final long serialVersionUID = 1466872342828698078L;
	
	private char[] characters;
	private String name;
	
	/**
	 * Constructs new character class based on array of characters this
	 * class contains.
	 */
	
	public CharacterArrayClass(char[] characters, String name) {
		this.characters = characters;
		this.name = name;
	}

	public boolean isIn(char ch) {
		for (int i = 0; i < characters.length; i++) {
			if (ch == characters[i]) {
				return true;
			}
		}
		return false;
	}

	public String getName() {
		return name;
	}

	@Override
	public String toString() {
		return name;
	}
}
