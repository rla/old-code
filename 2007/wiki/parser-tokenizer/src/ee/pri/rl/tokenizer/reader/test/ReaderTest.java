package ee.pri.rl.tokenizer.reader.test;

import java.io.IOException;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.tokenizer.CharacterClassFactoryException;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.reader.Reader;

/**
 * Test cases for the tokenizer.
 */

public class ReaderTest extends TestCase {

	public void testReader() throws TokenizerException, IOException, ParserException, CharacterClassFactoryException {
		String input = FileUtils.getFromResource("ee/pri/rl/tokenizer/reader/test/test.rules");
		assertNotNull(Reader.fromString(input));
	}
}
