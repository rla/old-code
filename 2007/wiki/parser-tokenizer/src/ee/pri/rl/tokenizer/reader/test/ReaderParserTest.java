package ee.pri.rl.tokenizer.reader.test;

import java.io.IOException;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.support.xml.XMLProducer;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.reader.ReaderParser;
import ee.pri.rl.tokenizer.reader.ReaderTokenizer;

/**
 * Tests for tokenizer rule file parser.
 */

public class ReaderParserTest extends TestCase {
	
	public void testParser() throws IOException, TokenizerException, ParserException {
		String input = FileUtils.getFromResource("ee/pri/rl/tokenizer/reader/test/test.rules");
		List<Token> tokens = ReaderTokenizer.tokenize(input);
		assertFalse(tokens.isEmpty());
		Node node = ReaderParser.parse(tokens);
		assertNotNull(node);
		System.out.println(XMLProducer.getXML(node));
	}
}
