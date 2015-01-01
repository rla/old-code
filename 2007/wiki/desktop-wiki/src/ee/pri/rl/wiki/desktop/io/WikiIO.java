package ee.pri.rl.wiki.desktop.io;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import ee.pri.rl.parser.Node;
import ee.pri.rl.text.template.TemplateProcessor;
import ee.pri.rl.tokenizer.TokenizerException;
import ee.pri.rl.wiki.WikiPageParser;
import ee.pri.rl.wiki.WikiPageParserException;
import ee.pri.rl.wiki.desktop.output.TitleProducer;
import ee.pri.rl.wiki.parser.WikiParserException;

/**
 * Wiki filesystem interface.
 */

public class WikiIO {
	private static final Logger log = Logger.getLogger(WikiIO.class);
	
	public static final String HTML_HEADER_FILE_NAME = "header.html";
	public static final String HTML_FOOTER_FILE_NAME = "footer.html";
	public static final String HTML_STYLE_FILE_NAME = "wiki.css";
	
	private static final String HTML_TEMPLATE_PARAMETER_TITLE = "title";
	private static final String HTML_TEMPLATE_PARAMETER_STYLE = "style";
	
	public static void compilePage(File file) throws WikiIOException {
		try {	
			Node root = parseInput(FileUtils.readFileToString(file, "UTF-8"));

			Map<String, String> templateMapper = new HashMap<String, String>();
			templateMapper.put(HTML_TEMPLATE_PARAMETER_TITLE, TitleProducer.findTitle(root));
			templateMapper.put(HTML_TEMPLATE_PARAMETER_STYLE, findStyle(file, findStyleFile(file.getParentFile())));
			
			String wikiFilePath = file.getAbsolutePath();
			
			FileUtils.writeStringToFile(
				new File(wikiFilePath.substring(0, wikiFilePath.lastIndexOf('.')) + ".html"),
				TemplateProcessor.process(
					templateMapper,
					FileUtils.readFileToString(findHeaderFile(file.getParentFile()), "UTF-8")
				)
				+ WikiPageParser.compileIntoXHTML(root, file.getParent())
				+ FileUtils.readFileToString(findFooterFile(file.getParentFile()), "UTF-8"),
				"UTF-8"
			);
		} catch (IOException e) {
			throw new WikiIOException("Cannot read input file", e);
		} catch (WikiParserException e) {
			throw new WikiIOException("Cannot parse input file", e);
		} catch (WikiPageParserException e) {
			throw new WikiIOException("Cannot produce output file", e);
		} catch (TokenizerException e) {
			throw new WikiIOException("Problem while processing header", e);
		}
	}
	
	private static String findStyle(File wikiFile, File styleFile) {
		File wikiDirectory = wikiFile.getParentFile();
		File styleDirectory = styleFile.getParentFile();
		String prefix = "";
		while (!styleDirectory.equals(wikiDirectory)) {
			wikiDirectory = wikiDirectory.getParentFile();
			prefix += "../";
		}
		
		return prefix + styleFile.getName();
	}
	
	private static final Node parseInput(String input) throws WikiParserException {
		long start = System.currentTimeMillis();
		Node root = WikiPageParser.tokenizeAndParse(input);
		log.info("Tokenizing and parsing took " + (System.currentTimeMillis() - start) + "ms");
		return root;
	}
	
	public static File findHeaderFile(File directory) {
		return FileFinder.findFile(HTML_HEADER_FILE_NAME, directory);
	}
	
	public static File findFooterFile(File directory) {
		return FileFinder.findFile(HTML_FOOTER_FILE_NAME, directory);
	}
	
	public static File findStyleFile(File directory) {
		return FileFinder.findFile(HTML_STYLE_FILE_NAME, directory);
	}
}
