package ee.pri.rl.parser;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import ee.pri.rl.tokenizer.Token;

/**
 * General parser.
 */

public class Parser {
	
	/**
	 * Inner class for holding the result of parsing
	 * of given symbol. This is necessary for
	 * nondeterministic execution of parsing rules.
	 */
	
	private static class ParserResult {
		private boolean success;
		private int lineNumber;
		private Node node;
		private List<Token> accumulator;

		public List<Token> getAccumulator() {
			return accumulator;
		}

		public void setAccumulator(List<Token> accumulator) {
			this.accumulator = accumulator;
		}

		public Node getNode() {
			return node;
		}

		public void setNode(Node node) {
			this.node = node;
		}

		public int getLineNumber() {
			return lineNumber;
		}

		public void setLineNumber(int lineNumber) {
			this.lineNumber = lineNumber;
		}

		/**
		 * True iff if parsing was successful.
		 */
		
		public boolean isSuccess() {
			return success;
		}

		public void setSuccess(boolean success) {
			this.success = success;
		}
	}
	
	/**
	 * Parse the input list of tokens.
	 * @param tokens The list of tokens to be parsed.
	 * @param symbolMapper Map that maps symbol textual name into actual symbol.
	 * @param topLevel Name of the symbol that is supposed to be the root of the parse tree.
	 * @return Root node of parse tree.
	 * @throws ParserException Exception is thrown if given symbol cannot be found or if parsing error occurs.
	 */
	
	public static Node parse(
			List<Token> tokens,
			Map<String, Symbol> symbolMapper,
			String topLevel) throws ParserException {
		return NondetParser.parse(tokens, symbolMapper, topLevel);
		
		/*
		Symbol topLevelSymbol = symbolMapper.get(topLevel);
		if (topLevelSymbol == null) {
			throw new ParserException("Symbol with name " + topLevel + " does not exist");
		}
		ParserResult result = parse(tokens, symbolMapper, topLevelSymbol);
		if (result.isSuccess() && result.getAccumulator().isEmpty()) {
			return result.getNode();
		} else {
			throw new ParserFailedException("Parser failed at line " + result.getLineNumber(), result.getLineNumber());
		}
		*/
	}
	
	/**
	 * Internal procedure that tries to detect given symbol from
	 * input tokens. Since the procedure is fundamentally different
	 * for nonterminal and terminal symbols we branch execution from
	 * here.
	 * @throws ParserException 
	 */

	private static ParserResult parse(
			List<Token> tokens,
			Map<String, Symbol> symbolMapper,
			Symbol top) throws ParserException {
		
		if (top instanceof TerminalSymbol) {
			return parseTerminalSymbol(tokens, symbolMapper, (TerminalSymbol) top);
		} else {
			return parseNonterminalSymbol(tokens, symbolMapper, (NonterminalSymbol) top);
		}
	}

	private static ParserResult parseNonterminalSymbol(
			List<Token> tokens,
			Map<String, Symbol> symbolMapper,
			NonterminalSymbol top) throws ParserException {
		
		// Last line number from this parsing
		int lastLineNumber = 0;
		// Try all definitions of given symbol until finding
		// one that returns successful result.
		for (String[] definition : top.getDefinitions()) {
			boolean parsed = true;
			// Create node for current top symbol.
			Node node = new Node(top.getName());
			// Create temporar input
			List<Token> temp = new LinkedList<Token>(tokens);
			// Try to parse every symbol of from definition
			// from left to right.
			for (String symbolName : definition) {
				Symbol symbol = symbolMapper.get(symbolName);
				if (symbol == null) {
					throw new ParserException("Cannot find symbol " + symbolName);
				}
				ParserResult result = parse(temp, symbolMapper, symbol);
				if (!result.isSuccess()) {
					// Parsing of current symbol failed.
					// Set flag "parsed" false and return from loop.
					parsed = false;
					break;
				}
				node.addNode(result.getNode());
				lastLineNumber = result.getLineNumber();
				// Use list from accumulator.
				// (Some n-th first elements have been parsed and removed from old temp list)
				temp = result.getAccumulator();
			}
			
			if (parsed) {
				// Current definition was suitable.
				ParserResult result = new ParserResult();
				result.setSuccess(true);
				result.setAccumulator(temp);
				result.setNode(node);
				result.setLineNumber(lastLineNumber);
				return result;
			}
		}
		ParserResult result = new ParserResult();
		result.setSuccess(false);
		result.setLineNumber(lastLineNumber);
		return result;
	}

	private static ParserResult parseTerminalSymbol(
			List<Token> tokens,
			Map<String, Symbol> symbolMapper,
			TerminalSymbol top) {
		if (tokens.size() == 0) {
			ParserResult result = new ParserResult();
			result.setSuccess(false);
			return result;
		}
		Token token = tokens.get(0);
		ParserResult result;
		if (token.getName().equals(top.getTokenName())) {
			tokens.remove(0);
			result = new ParserResult();
			result.setSuccess(true);
			result.setAccumulator(new LinkedList<Token>(tokens));
			Node node = new Node(top.getName());
			node.setContents(token.getContents());
			result.setNode(node);
			result.setLineNumber(token.getLineNumber());
		} else {
			result = new ParserResult();
			result.setSuccess(false);
			result.setLineNumber(token.getLineNumber());
		}
		return result;
	}
	
	/**
	 * Helper method for adding symbols into symbols mapper.
	 */
	
	public static void addSymbolToMapper(Symbol symbol, Map<String, Symbol> symbolMapper) {
		symbolMapper.put(symbol.getName(), symbol);
	}
	
	/**
	 * Remove nodes which have no semantics.
	 */
	
	public static Node removeNonSemanticNodes(Node node, Set<String> semantics) throws ParserException {
		if (!semantics.contains(node.getName())) {
			throw new ParserException("Root node must have semantics!");
		}

		Node ret = new Node(node.getName());
		for (Node child : node.getNodes()) {
			ret.getNodes().addAll(removeAndGetSemanticNodes(child, semantics));
		}
		
		return ret;
	}

	private static List<Node> removeAndGetSemanticNodes(Node node, Set<String> semantics) {
		if (semantics.contains(node.getName())) {
			Node ret = new Node(node.getName());
			ret.setContents(node.getContents());
			for (Node child : node.getNodes()) {
				ret.getNodes().addAll(removeAndGetSemanticNodes(child, semantics));
			}
			List<Node> nodes = new ArrayList<Node>();
			nodes.add(ret);
			return nodes;
		} else {
			List<Node> ret = new ArrayList<Node>();
			for (Node child : node.getNodes()) {
				ret.addAll(removeAndGetSemanticNodes(child, semantics));
			}
			return ret;
		}
	}
}
