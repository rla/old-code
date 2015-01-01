package ee.pri.rl.parser.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.parser.NonterminalSymbol;
import ee.pri.rl.parser.Parser;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.ParserFailedException;
import ee.pri.rl.parser.Symbol;
import ee.pri.rl.parser.TerminalSymbol;
import ee.pri.rl.tokenizer.Token;

/**
 * Tests for the parser.
 */

public class ParserTest extends TestCase {
	private TerminalSymbol textSymbol;
	private TerminalSymbol boldSymbol;
	private NonterminalSymbol elementSymbol;
	private NonterminalSymbol pageSymbol;
	
	private HashMap<String, Symbol> symbolMapper;
	
	@Override
	protected void setUp() throws Exception {
		textSymbol = new TerminalSymbol("tText", "text");
		boldSymbol = new TerminalSymbol("tBold", "bold");
		elementSymbol = new NonterminalSymbol("nElement", new String[][] {
				new String[] {textSymbol.getName()},
				new String[] {boldSymbol.getName()}
		});
		pageSymbol = new NonterminalSymbol("nPage", new String[][] {
				new String[] {elementSymbol.getName(), "nPage"},
				new String[] {elementSymbol.getName()}
		});
		symbolMapper = new HashMap<String, Symbol>();
		symbolMapper.put(textSymbol.getName(), textSymbol);
		symbolMapper.put(boldSymbol.getName(), boldSymbol);
		symbolMapper.put(elementSymbol.getName(), elementSymbol);
		symbolMapper.put(pageSymbol.getName(), pageSymbol);
	}

	public void testParser() throws ParserException {
		List<Token> tokens = new ArrayList<Token>();
		tokens.add(new Token("text", "my\n", 1));
		tokens.add(new Token("bold", "boldie\n", 2));
		tokens.add(new Token("text", "thingie", 3));
		
		long start = System.currentTimeMillis();
		Parser.parse(tokens, symbolMapper, "nPage");
		System.out.println((System.currentTimeMillis() - start) + "ms");
	}
	
	// FIXME not run at current moment
	public void ttestFailingParser() {
		List<Token> tokens = new ArrayList<Token>();
		tokens.add(new Token("text", "my\n", 1));
		tokens.add(new Token("bold", "boldie\n", 2));
		tokens.add(new Token("blah", "boldie\n", 2));
		tokens.add(new Token("text", "thingie", 3));
		
		try {
			Parser.parse(tokens, symbolMapper, "nPage");
		} catch (ParserException e) {
			if (e instanceof ParserFailedException) {
				assertEquals(((ParserFailedException) e).getLineNumber(), 2);
			}
			return;
		}
		
		fail("Parser does not throw exception on incorrect syntax.");
	}
}