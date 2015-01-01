package ee.pri.rl.tokenizer.support.dot;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import ee.pri.rl.tokenizer.reader.Reader;
import ee.pri.rl.tokenizer.serialization.SerializableTokenizer;

/**
 * Converter to convert tokenizer into .dot file.
 */

public class DotView {	
	public static void main(String[] args) {
		if (args.length < 2) {
			System.err.println("Usage: dotview <input.rules> <output.dot>");
			return;
		}
		
		File inputFile = new File(args[0]);
		if (!inputFile.canRead()) {
			System.err.println("Cannot read input file!");
			return;
		}
		
		File outputFile = new File(args[1]);
		BufferedWriter writer = null;
		try {
			writer = new BufferedWriter(new FileWriter(outputFile));
		} catch (IOException e1) {
			e1.printStackTrace(System.err);
		}
		try {
			SerializableTokenizer tokenizer = Reader.read(inputFile.getAbsolutePath());
			DotWriter.writeDot(writer, tokenizer);
		} catch (Exception e) {
			e.printStackTrace(System.err);
			return;
		} finally {
			try {
				writer.close();
			} catch (IOException e) {
				e.printStackTrace(System.err);
			}
		}
	}
}
