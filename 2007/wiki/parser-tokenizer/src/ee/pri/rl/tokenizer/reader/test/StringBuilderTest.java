package ee.pri.rl.tokenizer.reader.test;

import junit.framework.TestCase;

/**
 * Tests for checking correct behaivor of StringBuilder.
 */

public class StringBuilderTest extends TestCase {

	public void testStringBuilder() {
		String input = "\\\\\\\\";
		assertTrue(input.equals(new StringBuilder(input).toString()));
	}
}
