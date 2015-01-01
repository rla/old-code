package ee.pri.rl.wiki.desktop.test;

import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.wiki.WikiPageParser;
import ee.pri.rl.wiki.desktop.ParserWrapper;
import ee.pri.rl.wiki.parser.WikiParser;
import ee.pri.rl.wiki.parser.WikiParserException;
import ee.pri.rl.wiki.tokenizer.WikiTokenizer;

/**
 * Test cases for wiki parser wrapper.
 */

public class ParserWrapperTest extends TestCase {
	
	public void testTokenizer() throws Exception {
		System.out.println(WikiTokenizer.tokenize("test"));
	}
	
	public void testParser() throws Exception {
		List<Token> tokens = WikiTokenizer.tokenize("test");
		WikiParser.parse(tokens);
	}
	
	public void testWikiPageParser() throws WikiParserException {
		WikiPageParser.tokenizeAndParse("haha");
	}
	
	public void testParserWrapper() throws Exception {
		ParserWrapper.parseAndSave("haha", "test", "test/test.html", "test/header.html", "test/footer.html");
	}
}
