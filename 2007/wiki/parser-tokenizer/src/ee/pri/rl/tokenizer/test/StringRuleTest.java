package ee.pri.rl.tokenizer.test;

import ee.pri.rl.tokenizer.FixedCharacterBuffer;
import ee.pri.rl.tokenizer.State;
import ee.pri.rl.tokenizer.StringRule;
import junit.framework.TestCase;

/**
 * Test for string transition rule.
 */

public class StringRuleTest extends TestCase {

	public void testStringRule() {
		StringRule stringRule = new StringRule(new State("text"), new State("bold"), "**");
		assertTrue(stringRule.applies(new FixedCharacterBuffer("** and some text"), new State("text")));
		assertFalse(stringRule.applies(new FixedCharacterBuffer("*"), new State("text")));
		assertFalse(stringRule.applies(new FixedCharacterBuffer("** and some text"), new State("bold")));
		FixedCharacterBuffer input = new FixedCharacterBuffer("** and some text");
		stringRule.eat(input);
		assertEquals(input.toString(), " and some text");
	}
}
