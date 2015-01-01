package ee.pri.rl.parser.support.ant;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

import ee.pri.rl.nondet.Procedure;
import ee.pri.rl.parser.NondetParser;
import ee.pri.rl.parser.serialization.CompiledParser;
import ee.pri.rl.parser.serialization.SerializableParser;

/**
 * Ant task for compiling parser specification into a program
 * of nondeterministic automata.
 */

public class ParserCompiler extends Task {
	private String input;
	private String output;
	
	
	public String getInput() {
		return input;
	}


	public void setInput(String input) {
		this.input = input;
	}


	public String getOutput() {
		return output;
	}


	public void setOutput(String output) {
		this.output = output;
	}


	@Override
	public void execute() throws BuildException {
		System.out.println("Compiling '" + input + "' into '" + output + "'");
		try {
			SerializableParser parser = SerializableParser.readFromFile(input);
			Procedure program = NondetParser.compile(parser.getSymbolMapper(), parser.getTopLevel());
			CompiledParser compiledParser = new CompiledParser(program, parser.getSemantics());
			compiledParser.writeToFile(output);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
