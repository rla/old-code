package ee.pri.rl.wiki.desktop;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import ee.pri.rl.common.FileUtils;
import ee.pri.rl.parser.Node;
import ee.pri.rl.text.template.TemplateProcessor;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.wiki.WikiPageParser;
import ee.pri.rl.wiki.WikiPageParserException;
import ee.pri.rl.wiki.desktop.output.TitleProducer;
import ee.pri.rl.wiki.parser.WikiParserException;

/**
 * Wrapper around wiki parser.
 */

public class ParserWrapper {
	private static final Logger log = Logger.getLogger(ParserWrapper.class);

	public static void parseAndSave(
			String input,
			String directory,
			String pageFile,
			String headerFile,
			String footerFile) throws WikiPageParserException, IOException, WikiParserException, TokenizerException {
		
		long start = System.currentTimeMillis();
		Node root = WikiPageParser.tokenizeAndParse(input);
		log.info("Tokenizing and parsing took " + (System.currentTimeMillis() - start) + "ms");
		String title = TitleProducer.findTitle(root);
		String output = WikiPageParser.compileIntoXHTML(root, directory);
		Map<String, String> titleMapper = new HashMap<String, String>();
		titleMapper.put("title", title);
		String header = TemplateProcessor.process(titleMapper, FileUtils.readFile(headerFile));
		String footer = FileUtils.readFile(footerFile);
		
		FileUtils.writeFile(header + output + footer, pageFile);
	}
	
	public static void writeFile(String contents, String filename) {
		BufferedWriter writer = null;
		try {
			writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filename), "UTF-8"));
		} catch (Exception e) {
			if (writer != null) {
				try {
					writer.close();
				} catch (IOException e1) {
					// FIXME log errors
				}
			}
		}
		
	}
}
