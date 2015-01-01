package ee.pri.rl.tokenizer.reader.test;

import java.io.IOException;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.reader.ReaderTokenizer;

/**
 * Test cases for tokenizer rule file tokenizer.
 */

public class ReaderTokenizerTest extends TestCase {

	public void testReaderTokenizerRules() throws IOException, TokenizerException {
		String input = FileUtils.getFromResource("ee/pri/rl/tokenizer/reader/test/test.rules");
		long start = System.currentTimeMillis();
		List<Token> tokens = ReaderTokenizer.tokenize(input);
		System.out.println("Tokenizing took " + (System.currentTimeMillis() - start) + "ms");
		assertFalse(tokens.isEmpty());
		assertTrue(tokens.get(0).equals(new Token("startState", "startState", 0)));
		assertTrue(tokens.get(1).equals(new Token("endState", "end", 0)));
	}
}
