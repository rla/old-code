package ee.pri.rl.tokenizer;


/**
 * Factory for creating some common character classes.
 */

public class CharacterClassFactory {
	private static final char[] DECIMAL_NUMERIC = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
	private static final char[] NONBREAKING_WHITESPACE = new char[] { ' ', '\t' };
	private static final char[] LINE_END = new char[] { '\n', '\r' };
	private static final char[] WHITESPACE = new char[] { ' ', '\t', '\n', '\r' };
	private static final char[] LOWER_IDENTIFIER = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
			'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '_' };
	private static final char[] UPPER_IDENTIFIER = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
			'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '_' };
	private static final char[] IDENTIFIER = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
			'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '_', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
			'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
	
	/**
	 * Returns new character class based of class name. If the class does not exist
	 * and exception is thrown.
	 */
	
	public static CharacterClass getClassForName(String name) throws CharacterClassFactoryException {
		if (name.equalsIgnoreCase("decimal_numeric")) {
			return new CharacterArrayClass(DECIMAL_NUMERIC, "decimal_numeric");
		} else if (name.equalsIgnoreCase("nonbreaking_whitespace")) {
			return new CharacterArrayClass(NONBREAKING_WHITESPACE, "nonbreaking_whitespace");
		} else if (name.equalsIgnoreCase("line_end")) {
			return new CharacterArrayClass(LINE_END, "line_end");
		} else if (name.equalsIgnoreCase("whitespace")) {
			return new CharacterArrayClass(WHITESPACE, "whitespace");
		} else if (name.equalsIgnoreCase("lower_identifier")) {
			return new CharacterArrayClass(LOWER_IDENTIFIER, "lower_identifier");
		} else if (name.equalsIgnoreCase("upper_identifier")) {
			return new CharacterArrayClass(UPPER_IDENTIFIER, "upper_identifier");
		} else if (name.equalsIgnoreCase("identifier")) {
			return new CharacterArrayClass(IDENTIFIER, "identifier");
		} else if (name.startsWith("!")) {
			return new NegationalCharacterClass(getClassForName(name.substring(1)));
		} else {
			throw new CharacterClassFactoryException("No such class: " + name);
		}
	}
}
