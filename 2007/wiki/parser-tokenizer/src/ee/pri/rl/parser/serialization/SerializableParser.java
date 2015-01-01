package ee.pri.rl.parser.serialization;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.Parser;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.parser.Symbol;
import ee.pri.rl.tokenizer.Token;

/**
 * Class for parser that can be serialized/deserialized.
 */

public class SerializableParser implements Serializable {
	private static final long serialVersionUID = 1L;

	private HashMap<String, Symbol> symbolMapper;
	private String topLevel;
	private HashSet<String> semantics;

	public String getTopLevel() {
		return topLevel;
	}

	public void setTopLevel(String topLevel) {
		this.topLevel = topLevel;
	}

	public HashMap<String, Symbol> getSymbolMapper() {
		return symbolMapper;
	}

	public void setSymbolMapper(HashMap<String, Symbol> symbolMapper) {
		this.symbolMapper = symbolMapper;
	}

	public HashSet<String> getSemantics() {
		return semantics;
	}

	public void setSemantics(HashSet<String> semantics) {
		this.semantics = semantics;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof SerializableParser) {
			SerializableParser other = (SerializableParser) obj;
			return other.getTopLevel().equals(topLevel) &&
				other.getSemantics().equals(semantics) &&
				other.getSymbolMapper().equals(symbolMapper);
		} else {
			return false;
		}
	}
	
	public Node parse(List<Token> tokens) throws ParserException {
		return Parser.removeNonSemanticNodes(Parser.parse(tokens, symbolMapper, topLevel), semantics);
	}

	/**
	 * Read parser from file.
	 */

	public static SerializableParser readFromFile(String filename) throws FileNotFoundException, IOException,
			ClassNotFoundException {
		return (SerializableParser) FileUtils.readObjectFromFile(filename);
	}
	
	public void writeToFile(String filename) throws FileNotFoundException, IOException {
		FileUtils.writeObjectToFile(filename, this);
	}
	
	public static SerializableParser readFromResource(String resourceName) throws IOException, ClassNotFoundException {
		InputStream inputStream = SerializableParser.class.getResourceAsStream(resourceName);
		return (SerializableParser) FileUtils.readObjectFromStream(new ObjectInputStream(inputStream));
	}
	
	
}
