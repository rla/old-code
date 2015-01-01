package ee.pri.rl.parser.reader.test;

import java.io.IOException;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.reader.ReaderParser;
import ee.pri.rl.parser.reader.ReaderTokenizer;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Tests for parser file parser.
 */

public class ReaderParserTest extends TestCase {

	public void testReaderParser() throws TokenizerException, IOException, ParserException {
		//String small = //"T: tTerminalName terminalName\n" +
				//"T: tTokenName tokenName\n" +
				//"N: nGrammar {nGrammarElements}\n" +
				//"N: nGrammarElements {nGrammarElement nGrammarElements}\n";
				//"S: nNonterminalSpec\n" +
		//		"S: nSemanticsSpec\n" +
		//		"S: nDefinition";
		List<Token> tokens = ReaderTokenizer.tokenize(FileUtils.getFromResource("ee/pri/rl/parser/reader/test/parser.rules"));
		//List<Token> tokens = ReaderTokenizer.tokenize(small);
		assertFalse(tokens.isEmpty());
		long start = System.currentTimeMillis();
		Node node = ReaderParser.parse(tokens);
		System.out.println((System.currentTimeMillis() - start) + "ms");
		assertNotNull(node);
	}
}
