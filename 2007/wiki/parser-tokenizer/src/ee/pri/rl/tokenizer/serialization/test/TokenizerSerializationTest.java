package ee.pri.rl.tokenizer.serialization.test;

import java.io.File;
import java.io.IOException;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.tokenizer.CharacterClassFactoryException;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.reader.Reader;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;
import junit.framework.TestCase;

/**
 * Test for serialization/desrialization for tokenizer.
 */

public class TokenizerSerializationTest extends TestCase {

	public void testSerializationDeserialization() throws TokenizerException, ParserException,
			CharacterClassFactoryException, IOException, ClassNotFoundException {
		String input = FileUtils.getFromResource("ee/pri/rl/tokenizer/reader/test/test.rules");
		SerializableTokenizer tokenizer = Reader.fromString(input);
		File temp = File.createTempFile("test_", ".file");
		tokenizer.writeToFile(temp.getAbsolutePath());
		SerializableTokenizer readed = SerializableTokenizer.readFromFile(temp.getAbsolutePath());
		assertTrue(tokenizer.equals(readed));
		temp.deleteOnExit();
	}
}
