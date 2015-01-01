package ee.pri.rl.parser.reader.test;

import java.io.IOException;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.reader.ReaderTokenizer;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Test cases for parser file tokenizer.
 */

public class ReaderTokenizerTest extends TestCase {

	public void testReaderTokenizer() throws IOException, TokenizerException {
		List<Token> tokens = ReaderTokenizer.tokenize(FileUtils.getFromResource("ee/pri/rl/parser/reader/test/parser.rules"));
		assertFalse(tokens.isEmpty());
	}
}
