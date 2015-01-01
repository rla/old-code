package ee.pri.rl.tokenizer.reader;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.NonterminalSymbol;
import ee.pri.rl.parser.Parser;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.Symbol;
import ee.pri.rl.parser.TerminalSymbol;
import ee.pri.rl.parser.support.xml.XMLProducer;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Parser for tokenizer rules.
 */

public class ReaderParser {
	private static Map<String, Symbol> symbolMapper;
	private static Set<String> semantics;

	static {
		symbolMapper = new HashMap<String, Symbol>();

		Parser.addSymbolToMapper(new TerminalSymbol("tStartState", "startState"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEndState", "endState"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tStringTransition", "stringTransition"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEscapeEscape", "escapeEscape"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEscapeTab", "escapeTab"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEscapeQuote", "escapeQuote"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEscapeNewline", "escapeNewline"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEscapeReturn", "escapeReturn"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tSemanticsIdentifier", "semanticsIdentifier"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tSemanticsSemantics", "semanticsSemantics"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tOldState", "oldState"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tNextState", "nextState"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tCharTransition", "charTransition"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tEndTransition", "endTransition"), symbolMapper);

		Parser.addSymbolToMapper(new NonterminalSymbol("nRuleCollection", new String[][] { new String[] {
				"tStartState", "tEndState", "nRules" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nRules", new String[][] { new String[] { "nRule", "nRules" },
				new String[] { "nRule" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nRule", new String[][] { new String[] { "nTransitionRule" },
				new String[] { "nSemanticsDescriptor" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nTransitionRule", new String[][] { new String[] { "tOldState",
				"nTransition", "tNextState" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nTransition", new String[][] {
				new String[] { "nStringTransition" }, new String[] { "tCharTransition" },
				new String[] { "tEndTransition" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nStringTransition",
				new String[][] { new String[] { "nStringTransitionBody" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nStringTransitionBody", new String[][] {
				new String[] { "nStringTransitionElement", "nStringTransitionBody" },
				new String[] { "nStringTransitionElement" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nStringTransitionElement", new String[][] {
				new String[] { "tStringTransition" }, new String[] { "tEscapeEscape" },
				new String[] { "tEscapeQuote" }, new String[] { "tEscapeNewline" }, new String[] { "tEscapeTab" },
				new String[] { "tEscapeReturn" } }), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nSemanticsDescriptor", new String[][] { new String[] {
				"tSemanticsIdentifier", "tSemanticsSemantics" } }), symbolMapper);

		// Specify which terminals/nonterminal have semantics
		semantics = new HashSet<String>();
		
		semantics.add("nRuleCollection");
		semantics.add("nTransitionRule");
		semantics.add("nSemanticsDescriptor");
		semantics.add("nStringTransition");
		semantics.add("tStartState");
		semantics.add("tEndState");
		semantics.add("tStringTransition");
		semantics.add("tEscapeEscape");
		semantics.add("tEscapeQuote");
		semantics.add("tEscapeNewline");
		semantics.add("tEscapeTab");
		semantics.add("tEscapeReturn");
		semantics.add("tNextState");
		semantics.add("tSemanticsIdentifier");
		semantics.add("tSemanticsSemantics");
		semantics.add("tOldState");
		semantics.add("tCharTransition");
		semantics.add("tEndTransition");
	}

	/**
	 * Parses tokens into abstract syntax tree.
	 */

	public static Node parse(List<Token> tokens) throws ParserException {
		return Parser.removeNonSemanticNodes(Parser.parse(tokens, symbolMapper, "nRuleCollection"), semantics);
	}

	public static void main(String[] args) throws TokenizerException, IOException, ParserException {
		String filename = "test/wiki/test.rules";
		if (args.length > 0) {
			filename = args[0];
		}

		List<Token> tokens = ReaderTokenizer.tokenize(FileUtils.readFile(filename));

		for (Token token : tokens) {
			System.out.println(token);
		}

		System.out.println(XMLProducer.getXML(parse(tokens)));
	}
}
