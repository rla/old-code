package ee.pri.rl.wiki.parser;

import java.util.List;

import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.serialization.CompiledParser;
import ee.pri.rl.tokenizer.Token;

/**
 * Parser for wiki pages.
 */

public class WikiParser {
	private static CompiledParser parser;

	static {
		try {
			parser = CompiledParser.readFromResource("/ee/pri/rl/wiki/parser/parser.rules.comp");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * Parse given list of tokens.
	 */
	
	public static Node parse(List<Token> tokens) throws WikiParserException {
		try {
			return parser.parse(tokens);
		} catch (ParserException e) {
			throw new WikiParserException("Parsing failed", e);
		}
	}
}
