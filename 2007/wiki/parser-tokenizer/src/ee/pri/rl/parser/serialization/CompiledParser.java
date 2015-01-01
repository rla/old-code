package ee.pri.rl.parser.serialization;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.Serializable;
import java.util.HashSet;
import java.util.List;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.nondet.Procedure;
import ee.pri.rl.parser.Node;
import ee.pri.rl.parser.NondetParser;
import ee.pri.rl.parser.Parser;
import ee.pri.rl.parser.ParserException;
import ee.pri.rl.tokenizer.Token;

/**
 * Parser as a program for nondeterministic machine.
 */

public class CompiledParser implements Serializable {
	private static final long serialVersionUID = -3658253181845259748L;
	
	private Procedure program;
	private HashSet<String> semantics;
	
	public CompiledParser(Procedure program, HashSet<String> semantics) {
		this.program = program;
		this.semantics = semantics;
	}

	public Procedure getProgram() {
		return program;
	}

	public void setProgram(Procedure program) {
		this.program = program;
	}

	public Node parse(List<Token> tokens) throws ParserException {
		return Parser.removeNonSemanticNodes(NondetParser.parse(tokens, program), semantics);
	}
	
	public static CompiledParser readFromFile(String filename) throws FileNotFoundException, IOException,
		ClassNotFoundException {	
		return (CompiledParser) FileUtils.readObjectFromFile(filename);
	}

	public void writeToFile(String filename) throws FileNotFoundException, IOException {
		FileUtils.writeObjectToFile(filename, this);
	}

	public static CompiledParser readFromResource(String resourceName) throws IOException, ClassNotFoundException {
		InputStream inputStream = CompiledParser.class.getResourceAsStream(resourceName);
		return (CompiledParser) FileUtils.readObjectFromStream(new ObjectInputStream(inputStream));
	}

	public HashSet<String> getSemantics() {
		return semantics;
	}

	public void setSemantics(HashSet<String> semantics) {
		this.semantics = semantics;
	}
	
}
