package ee.pri.rl.wiki;

import java.io.IOException;

import ee.pri.rl.common.CommandLineUtils;
import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.wiki.parser.WikiParser;
import ee.pri.rl.wiki.parser.WikiParserException;
import ee.pri.rl.wiki.tokenizer.WikiTokenizer;
import ee.pri.rl.wiki.transform.pre.WikiPreTransformer;
import ee.pri.rl.wiki.transform.xhtml.WikiXHTMLTransformer;

/**
 * Tokenizes and parses wiki page.
 */

public class WikiPageParser {
	
	/**
	 * Tokenize and parse given input string.
	 */
	
	public static Node tokenizeAndParse(String input) throws WikiParserException {
		try {
			return WikiParser.parse(WikiTokenizer.tokenize(input));
		} catch (TokenizerException e) {
			throw new WikiParserException("Tokenizing exception occurred", e);
		}
	}
	
	public static String compileIntoXHTML(Node root, String directory) throws WikiPageParserException {		
		try {
			root = new WikiPreTransformer(directory).apply(root);
		} catch (Exception e) {
			throw new WikiPageParserException("Error occurred during pre-transforming wiki AST", e);
		}
		
		try {
			return new WikiXHTMLTransformer().apply(root);
		} catch (Exception e) {
			throw new WikiPageParserException("Couldn't generate XHTML code", e);
		}
	}
	
	public static void main(String[] args) throws WikiPageParserException, IOException, WikiParserException {
		String inputFilename = CommandLineUtils.getArgument(args, "-in");
		String outputFilename = CommandLineUtils.getArgument(args, "-out");
		String directory = CommandLineUtils.getArgument(args, "-d", ".");
		String headerFilename = CommandLineUtils.getArgument(args, "-pre");
		String footerFilename = CommandLineUtils.getArgument(args, "-post");
		
		if (CommandLineUtils.isOptionSet(args, "-h") ||
			CommandLineUtils.isOptionSet(args, "--help")) {
			printHelp();
			return;
		}
		
		String header = "";
		if (headerFilename != null) {
			header = FileUtils.readFile(headerFilename);
		}
		
		String footer = "";
		if (footerFilename != null) {
			footer = FileUtils.readFile(footerFilename);
		}
		
		String input;
		if (inputFilename == null) {
			input = CommandLineUtils.readInput();
		} else {
			input = FileUtils.readFile(inputFilename);
		}
		Node root = tokenizeAndParse(input);
		String output = header + compileIntoXHTML(root, directory) + footer;
		if (outputFilename == null) {
			System.out.println(output);
		} else {
			FileUtils.writeFile(output, outputFilename);
		}
	}
	
	public static void printHelp() {
		try {
			System.out.println(FileUtils.getFromResource("ee/pri/rl/wiki/parser.help"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
