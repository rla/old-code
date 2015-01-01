package ee.pri.rl.parser.reader.test;

import java.io.IOException;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.reader.Reader;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Test cases for parser file reader.
 */

public class ReaderTest extends TestCase {

	public void testReader() throws TokenizerException, ParserException, IOException {
		String input = FileUtils.getFromResource("ee/pri/rl/parser/reader/test/parser.rules");
		assertNotNull(Reader.fromString(input));
	}
}
