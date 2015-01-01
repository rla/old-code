package ee.pri.rl.parser.test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import ee.pri.rl.parser.NondetParser;
import ee.pri.rl.parser.NonterminalSymbol;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.Symbol;
import ee.pri.rl.parser.TerminalSymbol;
import ee.pri.rl.parser.support.xml.XMLProducer;
import ee.pri.rl.tokenizer.Token;
import junit.framework.TestCase;

public class NondetParserTest extends TestCase {
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
	
	public void testCompile() {
		NondetParser.compile(symbolMapper, "nPage");
	}
	
	public void testParse() throws ParserException {
		List<Token> tokens = new ArrayList<Token>();
		tokens.add(new Token("text", "my", 1));
		tokens.add(new Token("bold", "boldie", 2));
		tokens.add(new Token("text", "thingie", 3));
		
		System.out.println(XMLProducer.getXML(NondetParser.parse(tokens, symbolMapper, "nPage")));
	}
}
