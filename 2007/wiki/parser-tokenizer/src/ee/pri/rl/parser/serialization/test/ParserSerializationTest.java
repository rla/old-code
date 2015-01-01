package ee.pri.rl.parser.serialization.test;

import java.io.File;
import java.io.IOException;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.reader.Reader;
import ee.pri.rl.parser.serialization.SerializableParser;
import ee.pri.rl.tokenizer.CharacterClassFactoryException;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Test cases for parser serialization.
 */

public class ParserSerializationTest extends TestCase {

	public void testSerializationDeserialization() throws TokenizerException, ParserException, CharacterClassFactoryException, IOException, ClassNotFoundException {
		String input = FileUtils.getFromResource("ee/pri/rl/parser/reader/test/parser.rules");
		SerializableParser parser = Reader.fromString(input);
		parser.setTopLevel("test");
		File temp = File.createTempFile("test_", ".file");
		parser.writeToFile(temp.getAbsolutePath());
		SerializableParser readed = SerializableParser.readFromFile(temp.getAbsolutePath());
		assertTrue(parser.equals(readed));	
		temp.deleteOnExit();
	}
}
