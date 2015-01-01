package ee.pri.rl.parser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ee.pri.rl.nondet.Argument;
import ee.pri.rl.nondet.Machine;
import ee.pri.rl.nondet.Procedure;
import ee.pri.rl.tokenizer.Token;

/**
 * Parser that uses nondet library.
 */

public class NondetParser {
	
	public static class ParserNode extends Argument<Node> {
		private static final long serialVersionUID = 1003406205800805165L;

		@SuppressWarnings("unchecked")
		@Override
		public Argument copy() {
			ParserNode copy = new ParserNode();
			Node nodeCopy = new Node(data.getName());
			nodeCopy.setContents(data.getContents());
			nodeCopy.getNodes().addAll(data.getNodes());
			copy.data = nodeCopy;
			copy.next = next; 
			return copy;
		}

		@Override
		public String toString() {
			return super.toString();
		}
		
		public void print() {
			for (Node node : data.getNodes()) {
				System.out.println("\t" + node);
			}
		}
	}

	public static class ParserProcedure extends Procedure {
		private static final long serialVersionUID = 2738721212125965260L;
		
		private boolean terminal;
		private Symbol symbol;
		
		/**
		 * Arguments: 0 - input token list
		 */
		@SuppressWarnings("unchecked")
		@Override
		public boolean doWorkBefore(Argument[] arguments) {
			//System.out.println("Executing '" + symbol + "'");
			if (terminal) {
				if (arguments[0] == null) {
					return false;
				}
				TerminalSymbol terminal = (TerminalSymbol) symbol;
				Token token = (Token)arguments[0].data;
				
				if (terminal.getTokenName().equals(token.getName())) {
					Node node = new Node(terminal.getName());
					node.setContents(token.getContents());
					ParserNode next = new ParserNode();
					next.data = node;
					((Node)arguments[1].data).addNode(node);
					//System.out.println("ADDED " + node + " TO " + ((Node) arguments[1].data).getName());
					arguments[0] = arguments[0].next;
					return true;
				}
				else {
					return false;
				}
			} else {
				Node node = new Node(symbol.getName());
				ParserNode next = new ParserNode();
				next.next = arguments[1];
				next.data = node;
				//((Node)arguments[1].data).addNode(node);
				arguments[1] = next;
				return true;
			}
		}

		@SuppressWarnings("unchecked")
		@Override
		public boolean doWorkAfter(Argument[] arguments) {
			if (!terminal) {
				if (((ParserNode)arguments[1].next).data.getName() != null) {
					((ParserNode)arguments[1]).next.data.getNodes().add(((ParserNode)arguments[1]).data);
					arguments[1] = arguments[1].next;
				}
			}
			return true;
		}

		public Symbol getSymbol() {
			return symbol;
		}

		public void setSymbol(Symbol symbol) {
			this.symbol = symbol;
		}

		public boolean isTerminal() {
			return terminal;
		}

		public void setTerminal(boolean terminal) {
			this.terminal = terminal;
		}
	}
	
	public static Node parse(
			List<Token> tokens,
			Map<String, Symbol> symbolMapper,
			String topLevel) throws ParserException {
		
		return parse(tokensToArgument(tokens), symbolMapper, topLevel);
	}
	
	public static Argument<Token> tokensToArgument(List<Token> tokens) {
		Argument<Token> argument = new Argument<Token>();
		Argument<Token> ret = argument;
		for (Token token : tokens) {
			Argument<Token> next = new Argument<Token>();
			next.data = token;
			argument.next = next;
			argument = next;
		}
		return ret.next;
	}
	
	@SuppressWarnings("unchecked")
	public static Node parse(Argument tokens, Map<String, Symbol> symbolMapper, String top) {
		long start = System.currentTimeMillis();
		ParserProcedure program = compile(symbolMapper, top);
		System.out.println("Compiling took " + (System.currentTimeMillis() - start) + "ms");
		Machine machine = new Machine();
		ParserNode node = new ParserNode();
		node.data = new Node(null);
		return (Node) machine.execute(program, new Argument[] {tokens, node})[1].data;
	}
	
	public static Node parse(List<Token> tokens, Procedure program) {
		Machine machine = new Machine();
		ParserNode node = new ParserNode();
		node.data = new Node(null);
		return (Node) machine.execute(program, new Argument[] {tokensToArgument(tokens), node})[1].data;
	}
	
	/**
	 * Compiles grammar specification into program that will
	 * be run on nondeterministic machine.
	 */
	public static ParserProcedure compile(Map<String, Symbol> symbolMapper, String top) {
		return compile(symbolMapper, top, new HashMap<String, ParserProcedure>());
	}
	
	public static ParserProcedure compile(Map<String, Symbol> symbolMapper, String top, Map<String, ParserProcedure> compiled) {
		if (compiled.containsKey(top)) {
			return compiled.get(top);
		}
		ParserProcedure ret;
		ParserProcedure procedure = new ParserProcedure();
		Symbol symbol = symbolMapper.get(top);
		if (symbol instanceof TerminalSymbol) {
			procedure.setSymbol(symbol);
			procedure.setTerminal(true);
			procedure.description = symbol.getName();
			ret = procedure;
			compiled.put(top, ret);
		} else {
			ret = procedure;
			compiled.put(top, ret);
			NonterminalSymbol nonterminal = (NonterminalSymbol) symbol;
			procedure.setSymbol(symbol);
			procedure.setTerminal(false);
			procedure.description = symbol.getName();
			String[] definition = nonterminal.getDefinitions()[0];
			Procedure[] body = new Procedure[definition.length];
			for (int i = 0; i < body.length; i++) {
				body[i] = compile(symbolMapper, definition[i], compiled);
			}
			procedure.body = body;
			for (int i = 1; i < nonterminal.getDefinitions().length; i++) {
				definition = nonterminal.getDefinitions()[i];
				body = new Procedure[definition.length];
				procedure.alterative = new ParserProcedure();
				procedure = (ParserProcedure) procedure.alterative;
				procedure.setSymbol(symbol);
				procedure.setTerminal(false);
				procedure.description = symbol.getName();
				for (int j = 0; j < body.length; j++) {
					body[j] = compile(symbolMapper, definition[j], compiled);
				}
				procedure.body = body;
			}
		}
		return ret;
	}
}
