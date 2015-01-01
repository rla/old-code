package ee.pri.rl.wiki.tokenizer.test;

import java.io.IOException;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.wiki.tokenizer.WikiTokenizer;

/**
 * Test cases for wiki tokenizer.
 */

public class WikiTokenizerTest extends TestCase {

	public void testWikiTokenizer() throws IOException, TokenizerException {
		String input = FileUtils.getFromResource("ee/pri/rl/wiki/tokenizer/test/test.wiki");
		List<Token> tokens = WikiTokenizer.tokenize(input);
		for (Token token : tokens) {
			System.out.println(token);
		}
		assertFalse(tokens.isEmpty());
	}
}
