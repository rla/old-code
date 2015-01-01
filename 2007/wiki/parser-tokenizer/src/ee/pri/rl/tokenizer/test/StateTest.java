package ee.pri.rl.tokenizer.test;

import java.io.File;
import java.io.IOException;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.tokenizer.State;
import junit.framework.TestCase;

/**
 * Tests for tokenizer state.
 */

public class StateTest extends TestCase {

	public void testState() {
		assertTrue(new State("text").equals(new State("text")));
		assertTrue(new State("text", "text").equals(new State("text", "not text")));
		assertFalse(new State("text").equals(new State("bold")));
	}
	
	public void testSerialization() throws IOException, ClassNotFoundException {
		File temp = File.createTempFile("test_", ".file");
		State before = new State("text");
		FileUtils.writeObjectToFile(temp.getAbsolutePath(), new State("text"));
		State after = (State) FileUtils.readObjectFromFile(temp.getAbsolutePath());
		assertTrue(before.equals(after));
		temp.delete();
	}
}
