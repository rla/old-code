package ee.pri.rl.tokenizer.serialization;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.tokenizer.Rule;
import ee.pri.rl.tokenizer.State;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.Tokenizer;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Wrapper around the tokenizer to create serializable abd easily loadable
 * tokenizer.
 */

public class SerializableTokenizer implements Serializable {
	private static final long serialVersionUID = 7961178026263457719L;

	private List<Rule> rules;
	private State startState;
	private State endState;
	
	public SerializableTokenizer() {
		rules = new ArrayList<Rule>();
	}

	public State getEndState() {
		return endState;
	}

	public void setEndState(State endState) {
		this.endState = endState;
	}

	public List<Rule> getRules() {
		return rules;
	}

	public void setRules(List<Rule> rules) {
		this.rules = rules;
	}

	public State getStartState() {
		return startState;
	}

	public void setStartState(State startState) {
		this.startState = startState;
	}
	
	
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof SerializableTokenizer) {
			SerializableTokenizer other = (SerializableTokenizer) obj;
			return other.getStartState().equals(startState) &&
				other.getEndState().equals(endState) &&
				other.getRules().equals(rules);
		} else {
			return false;
		}
	}

	/**
	 * Tokenize the string using this tokenizer.
	 */
	
	public List<Token> tokenize(String input) throws TokenizerException {
		return Tokenizer.tokenize(input, rules, startState, endState);
	}
	
	/**
	 * Read tokenizer from file.
	 */

	public static SerializableTokenizer readFromFile(String filename) throws FileNotFoundException, IOException,
			ClassNotFoundException {
		return (SerializableTokenizer) FileUtils.readObjectFromFile(filename);
	}
	
	public void writeToFile(String filename) throws FileNotFoundException, IOException {
		FileUtils.writeObjectToFile(filename, this);
	}
	
	public static SerializableTokenizer readFromResource(String resourceName) throws IOException, ClassNotFoundException {
		InputStream inputStream = SerializableTokenizer.class.getResourceAsStream(resourceName);
		return (SerializableTokenizer) FileUtils.readObjectFromStream(new ObjectInputStream(inputStream));
	}
}
