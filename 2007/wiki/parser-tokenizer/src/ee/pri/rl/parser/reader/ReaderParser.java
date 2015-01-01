package ee.pri.rl.parser.reader;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.NonterminalSymbol;
import ee.pri.rl.parser.Parser;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.Symbol;
import ee.pri.rl.parser.TerminalSymbol;
import ee.pri.rl.tokenizer.Token;

/**
 * Parses tokens of input file of parser being read.
 */

public class ReaderParser {
	private static Map<String, Symbol> symbolMapper;
	private static Set<String> semantics;

	static {
		symbolMapper = new HashMap<String, Symbol>();
		Parser.addSymbolToMapper(new TerminalSymbol("tTerminalName", "terminalName"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tTokenName", "tokenName"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tNonterminalName", "nonterminalName"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tSymbolName", "symbolName"), symbolMapper);
		Parser.addSymbolToMapper(new TerminalSymbol("tSemanticsIdentifier", "semanticsIdentifier"), symbolMapper);
		
		Parser.addSymbolToMapper(new NonterminalSymbol("nGrammar", new String[][] {
				new String[] {"nGrammarElements"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nGrammarElements", new String[][] {
				new String[] {"nGrammarElement", "nGrammarElements"},
				new String[] {"nGrammarElement"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nGrammarElement", new String[][] {
				new String[] {"nTerminalSpec"},
				new String[] {"nNonterminalSpec"},
				new String[] {"nSemanticsSpec"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nTerminalSpec", new String[][] {
				new String[] {"tTerminalName", "tTokenName"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nNonterminalSpec", new String[][] {
				new String[] {"tNonterminalName", "nDefinition"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nDefinition", new String[][] {
				new String[] {"nSymbols"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nSymbols", new String[][] {
				new String[] {"tSymbolName", "nSymbols"},
				new String[] {"tSymbolName"}
		}), symbolMapper);
		Parser.addSymbolToMapper(new NonterminalSymbol("nSemanticsSpec", new String[][] {
				new String[] {"tSemanticsIdentifier"}
		}), symbolMapper);
		
		// Specify which terminals/nonterminal have semantics
		semantics = new HashSet<String>();
		
		semantics.add("tTerminalName");
		semantics.add("tTokenName");
		semantics.add("tNonterminalName");
		semantics.add("tSymbolName");
		semantics.add("tSemanticsIdentifier");
		semantics.add("nGrammar");
		semantics.add("nTerminalSpec");
		semantics.add("nNonterminalSpec");
		semantics.add("nSemanticsSpec");
		semantics.add("nDefinition");
	}
	
	/**
	 * Parses tokens into abstract syntax tree.
	 */

	public static Node parse(List<Token> tokens) throws ParserException {
		return Parser.removeNonSemanticNodes(Parser.parse(tokens, symbolMapper, "nGrammar"), semantics);
	}
}