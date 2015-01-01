package ee.pri.rl.tokenizer;

import java.io.Serializable;

/**
 * Base interface for character classes.
 */

public interface CharacterClass extends Serializable {

	/**
	 * Returns true if the given character is in this class.
	 */
	
	public boolean isIn(char ch);
	
	/**
	 * Return the name of this character class.
	 */
	
	public String getName();
}
