package ee.pri.rl.tokenizer.test;

import ee.pri.rl.tokenizer.CharacterClassFactory;
import ee.pri.rl.tokenizer.CharacterClassFactoryException;
import junit.framework.TestCase;

/**
 * Test cases for character classes and character class factory.
 */

public class CharacterClassFactoryTest extends TestCase {
	private String[] classes;

	@Override
	protected void setUp() throws Exception {
		classes = new String[] {
				"decimal_numeric",
				"nonbreaking_whitespace",
				"line_end",
				"whitespace",
				"lower_identifier",
				"upper_identifier",
				"identifier",
				"!decimal_numeric",
				"!nonbreaking_whitespace",
				"!line_end",
				"!whitespace",
				"!lower_identifier",
				"!upper_identifier",
				"!identifier"
		};
 	}
	
	public void testClassesExist() throws CharacterClassFactoryException {
		for (String className : classes) {
			assertNotNull(CharacterClassFactory.getClassForName(className));
		}
	}
	
	public void testClassNotExists() {
		try {
			CharacterClassFactory.getClassForName("blah blah");
		} catch (CharacterClassFactoryException e) {
			return;
		}
		fail("Character class factory does not throw exception for non-existing class");
	}
}
