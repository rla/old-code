package ee.pri.rl.tokenizer.reader;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.tokenizer.CharacterClass;
import ee.pri.rl.tokenizer.CharacterClassFactory;
import ee.pri.rl.tokenizer.CharacterClassFactoryException;
import ee.pri.rl.tokenizer.CharacterRule;
import ee.pri.rl.tokenizer.EndRule;
import ee.pri.rl.tokenizer.ImmediateRule;
import ee.pri.rl.tokenizer.State;
import ee.pri.rl.tokenizer.StringRule;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * Reader for the set of the rules.
 */

public class Reader {
	
	/**
	 * Read tokenizer from rule file.
	 */

	public static SerializableTokenizer read(String filename) throws TokenizerException, ParserException, IOException, CharacterClassFactoryException {
		return readAndProcess(FileUtils.readFile(filename));
	}
	
	/**
	 * Read tokenizer from String.
	 */
	
	public static SerializableTokenizer fromString(String input) throws TokenizerException, ParserException, CharacterClassFactoryException {
		return readAndProcess(input);
	}
	
	/**
	 * Does various things.
	 */

	private static SerializableTokenizer readAndProcess(String input) throws TokenizerException, ParserException, CharacterClassFactoryException {
		Node root = tokenizeAndParse(input);
		Map<String, String> semantics = getSemantics(root);
		String startStateName = getStartStateName(root);
		String endStateName = getEndStateName(root);
		State startState;
		String startStateSemantics = semantics.get(startStateName);
		if (startStateSemantics == null) {
			startState = new State(startStateName);
		} else {
			startState = new State(startStateName, startStateSemantics);
		}
		State endState;
		String endStateSemantics = semantics.get(endStateName);
		if (endStateSemantics == null) {
			endState = new State(endStateName);
		} else {
			endState = new State(endStateName, endStateSemantics);
		}
		SerializableTokenizer tokenizer = new SerializableTokenizer();
		tokenizer.setStartState(startState);
		tokenizer.setEndState(endState);
		
		findAndInsertTransitions(tokenizer, root, semantics);
		return tokenizer;
	}
	
	/**
	 * Tokenize and parse the text that represents some tokenizer rules.
	 */
	
	private static Node tokenizeAndParse(String input) throws TokenizerException, ParserException {
		return ReaderParser.parse(ReaderTokenizer.tokenize(input));
	}
	
	/**
	 * Traverse abstract syntax tree of tokenizer rules and collects
	 * semantic descriptors of tokens.
	 */
	
	private static Map<String, String> getSemantics(Node root) {
		Map<String, String> semantics = new HashMap<String, String>();
		for (Node node : root.getNodes()) {
			if (node.getName().equals("nSemanticsDescriptor")) {
				semantics.put(node.getNodes().get(0).getContents(), node.getNodes().get(1).getContents());
			}
		}
		return semantics;
	}
	
	/**
	 * Get the start state name for the tokenizer that is being read.
	 */
	
	private static String getStartStateName(Node root) {
		return root.getNodes().get(0).getContents();
	}

	/**
	 * Get the end state name for the tokenizer that is being read.
	 */
	
	private static String getEndStateName(Node root) {
		return root.getNodes().get(1).getContents();
	}
	
	/**
	 * Traverse the abstract syntax tree of the tokenizer being read and
	 * collect transition rules.
	 */
	
	private static void findAndInsertTransitions(SerializableTokenizer tokenizer, Node root,
			Map<String, String> semantics) throws CharacterClassFactoryException {
		for (Node node : root.getNodes()) {
			if (node.getName().equals("nTransitionRule")) {
				Node oldStateNode = node.getNodes().get(0);
				Node nextStateNode = node.getNodes().get(2);
				State oldState = createStateWithSemantics(oldStateNode.getContents(), semantics);
				State nextState = createStateWithSemantics(nextStateNode.getContents(), semantics);
				Node transitionNode = node.getNodes().get(1);
				String transitionNodeName = transitionNode.getName();
				if (transitionNodeName.equals("tCharTransition")) {
					String characterClassName = transitionNode.getContents();
					CharacterClass characterClass = CharacterClassFactory.getClassForName(characterClassName);
					tokenizer.getRules().add(new CharacterRule(oldState, nextState, characterClass));
				} else if (transitionNodeName.equals("tEndTransition")) {
					tokenizer.getRules().add(new EndRule(oldState, nextState));
				} else if (transitionNodeName.equals("nStringTransition")) {
					StringBuilder fragment = new StringBuilder();
					for (Node stringNode : transitionNode.getNodes()) {
						String stringNodeName = stringNode.getName();
						if (stringNodeName.equals("tStringTransition")) {
							fragment.append(stringNode.getContents());
						} else if (stringNodeName.equals("tEscapeQuote")) {
							fragment.append('"');
						} else if (stringNodeName.equals("tEscapeEscape")) {
							fragment.append('\\');
						} else if (stringNodeName.equals("tEscapeNewline")) {
							fragment.append('\n');
						} else if (stringNodeName.equals("tEscapeResturn")) {
							fragment.append('\r');
						} else if (stringNodeName.equals("tEscapeTab")) {
							fragment.append('\t');
						}
					}
					String fragmentString = fragment.toString();
					tokenizer.getRules().add(fragmentString.equals("") ? new ImmediateRule(oldState, nextState) : new StringRule(oldState, nextState, fragmentString));
				}
			}
		}
	}
	
	/**
	 * Create tokenizer state and check if it has semantics.
	 */
	
	private static State createStateWithSemantics(String stateName, Map<String, String> semantics) {
		String stateSemantics = semantics.get(stateName);
		if (stateSemantics == null) {
			return new State(stateName);
		} else {
			return new State(stateName, stateSemantics);
		}
	}
}
