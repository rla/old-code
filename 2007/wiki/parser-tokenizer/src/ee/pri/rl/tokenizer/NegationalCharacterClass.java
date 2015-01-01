
package ee.pri.rl.tokenizer;

/**
 * Character class that negates the isIn() method
 * of internal character class.
 */

public class NegationalCharacterClass implements CharacterClass {
	private static final long serialVersionUID = 8834511496324236887L;
	
	private CharacterClass internal;
	
	public NegationalCharacterClass(CharacterClass internal) {
		this.internal = internal;
	}

	public String getName() {
		return "!" + internal.getName();
	}

	public boolean isIn(char ch) {
		return !internal.isIn(ch);
	}
}
