package ee.pri.rl.tokenizer.support.dot;

import java.io.IOException;
import java.io.Writer;

import ee.pri.rl.tokenizer.Rule;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * .dot file writer. Writes rules as .dot commands.
 */

public class DotWriter {
	public static void writeDot(Writer writer, SerializableTokenizer tokenizer) throws IOException {
		writePreamble(writer);
		for (Rule rule : tokenizer.getRules()) {
			writeRule(writer, rule);
		}
		writePostamble(writer);
	}

	private static void writeRule(Writer writer, Rule rule) throws IOException {
		line(writer, rule.getOldState().getName() + " -> " + rule.getNewState().getName() + ";");
	}

	private static void writePostamble(Writer writer) throws IOException {
		line(writer, "}");
	}

	private static void writePreamble(Writer writer) throws IOException {
		line(writer, "digraph G {");
	}
	
	private static void line(Writer writer, String line) throws IOException {
		writer.append(line);
		writer.append("\n");
	}
}
