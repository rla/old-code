package ee.pri.rl.wiki.parser.test;

import java.io.IOException;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.wiki.parser.WikiParser;
import ee.pri.rl.wiki.parser.WikiParserException;
import ee.pri.rl.wiki.tokenizer.WikiTokenizer;

/**
 * Test cases for wiki parser.
 */

public class WikiParserTest extends TestCase {

	public void testWikiParser() throws IOException, TokenizerException, WikiParserException {
		String input = FileUtils.getFromResource("ee/pri/rl/wiki/tokenizer/test/test.wiki");
		List<Token> tokens = WikiTokenizer.tokenize(input);
		assertFalse(tokens.isEmpty());
		Node node = WikiParser.parse(tokens);
		assertNotNull(node);
	}
}
