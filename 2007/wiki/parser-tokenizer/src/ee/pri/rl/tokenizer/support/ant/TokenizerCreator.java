package ee.pri.rl.tokenizer.support.ant;

import org.apache.tools.ant.Task;

import ee.pri.rl.tokenizer.reader.Reader;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * Ant task that creates serialized tokenizer into given file. Also performs
 * validation for the tokenizer rules.
 */

public class TokenizerCreator extends Task {
	private String input;
	private String output;

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
	
	/**
	 * Do the actual work. Read in the rules file and write out
	 * the tokenizer in serialized form.
	 */

	@Override
	public void execute() {
		try {
			System.out.println("Converting '" + input + "' into serialized form '" + output + "'");
			SerializableTokenizer tokenizer = Reader.read(input);
			tokenizer.writeToFile(output);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
