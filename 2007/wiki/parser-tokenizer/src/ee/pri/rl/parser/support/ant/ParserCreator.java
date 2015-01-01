package ee.pri.rl.parser.support.ant;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

import ee.pri.rl.parser.reader.Reader;
import ee.pri.rl.parser.serialization.SerializableParser;

/**
 * Ant task for transforming parser into serialized form.
 */

public class ParserCreator extends Task {
	private String input;
	private String output;
	private String top;
	
	/**
	 * Get the name of the input file.
	 */
	
	public String getInput() {
		return input;
	}
	
	/**
	 * Set the name of the input file.
	 */
	
	public void setInput(String input) {
		this.input = input;
	}
	
	/**
	 * Get the name of the output file.
	 */
	
	public String getOutput() {
		return output;
	}
	
	/**
	 * Set the name of the output file.
	 */
	
	public void setOutput(String output) {
		this.output = output;
	}

	@Override
	public void execute() throws BuildException {
		try {
			System.out.println("Converting '" + input + "' into serialized form '" + output + "'");
			SerializableParser parser = Reader.fromFile(input);
			parser.setTopLevel(top);
			parser.writeToFile(output);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	public String getTop() {
		return top;
	}

	public void setTop(String top) {
		this.top = top;
	}
}
