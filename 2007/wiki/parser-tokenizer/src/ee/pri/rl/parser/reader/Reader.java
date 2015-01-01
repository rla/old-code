package ee.pri.rl.parser.reader;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map.Entry;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.NonterminalSymbol;
import ee.pri.rl.parser.Parser;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.Symbol;
import ee.pri.rl.parser.TerminalSymbol;
import ee.pri.rl.parser.serialization.SerializableParser;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Reader for parser.
 */

public class Reader {
	
	public static SerializableParser fromFile(String filename) throws TokenizerException, ParserException, IOException {
		return fromString(FileUtils.readFile(filename));
	}
	
	public static SerializableParser fromString(String input) throws TokenizerException, ParserException {		
		List<Token> tokens = ReaderTokenizer.tokenize(input);
		Node node = ReaderParser.parse(tokens);	
		return getParser(node);
	}
	
	private static SerializableParser getParser(Node root) {
		SerializableParser parser = new SerializableParser();
		HashSet<String> semantics = getSemantics(root);
		parser.setSemantics(semantics);
		parser.setSymbolMapper(new HashMap<String, Symbol>());
		processTerminals(root, parser);
		HashMap<String, List<String[]>> definitions = getDefinitions(root);
		processNonterminals(definitions, parser);
		return parser;
	}
	
	/**
	 * Look though abstract syntax tree and collect terminals.
	 */
	
	private static void processTerminals(Node root, SerializableParser parser) {
		for (Node node : root.getNodes()) {
			if (node.getName().equals("nTerminalSpec")) {
				String terminalName = node.getNodes().get(0).getContents();
				String tokenName = node.getNodes().get(1).getContents();
				Parser.addSymbolToMapper(new TerminalSymbol(terminalName, tokenName), parser.getSymbolMapper());
			}
		}
	}
	
	private static HashMap<String, List<String[]>> getDefinitions(Node root) {
		HashMap<String, List<String[]>> definitions = new HashMap<String, List<String[]>>();
		
		for (Node node : root.getNodes()) {
			if (node.getName().equals("nNonterminalSpec")) {
				String nonterminalName = node.getNodes().get(0).getContents();
				Node definitionNode = node.getNodes().get(1);
				String[] symbols = new String[definitionNode.getNodes().size()];
				int i = 0;
				for (Node symbol : definitionNode.getNodes()) {
					symbols[i++] = symbol.getContents();
				}
				List<String[]> nonTerminalDefinitions = definitions.get(nonterminalName);
				if (nonTerminalDefinitions == null) {
					nonTerminalDefinitions = new ArrayList<String[]>();
					nonTerminalDefinitions.add(symbols);
					definitions.put(nonterminalName, nonTerminalDefinitions);
				} else {
					nonTerminalDefinitions.add(symbols);
				}
			}
		}
		return definitions;
	}
	
	private static HashSet<String> getSemantics(Node root) {
		HashSet<String> semantics = new HashSet<String>();
		for (Node node : root.getNodes()) {
			if (node.getName().equals("nSemanticsSpec")) {
				Node semanticsIdentifierNode = node.getNodes().get(0);
				semantics.add(semanticsIdentifierNode.getContents());
			}
		}
		return semantics;
	}
	
	private static void processNonterminals(HashMap<String, List<String[]>> definitions, SerializableParser parser) {
		for (Entry<String, List<String[]>> entry : definitions.entrySet()) {
			String[][] definitionsArray = new String[entry.getValue().size()][];
			int i = 0;
			for (String[] definition : entry.getValue()) {
				definitionsArray[i++] = definition;
			}
			Parser.addSymbolToMapper(new NonterminalSymbol(entry.getKey(), definitionsArray), parser.getSymbolMapper());
		}
	}
}
