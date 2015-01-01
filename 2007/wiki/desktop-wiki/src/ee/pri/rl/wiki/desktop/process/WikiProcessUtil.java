package ee.pri.rl.wiki.desktop.process;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;

import ee.pri.rl.parser.Node;
import ee.pri.rl.wiki.WikiPageParser;
import ee.pri.rl.wiki.parser.WikiParserException;

/**
 * Wiki processing helper methods.
 * FIXME HTML processing
 */

public class WikiProcessUtil {
	
	public static Set<File> getLinkedFilesTransitiveClosure(File wikiFile) throws WikiParserException, IOException {
		Set<File> foundFiles = new HashSet<File>();
		Set<File> returnFiles = new HashSet<File>();
		foundFiles.add(wikiFile);
		returnFiles.add(wikiFile);
		findLinkedFilesRec(wikiFile, foundFiles, returnFiles);
		return returnFiles;
	}
	
	private static void findLinkedFilesRec(File file, Set<File> foundFiles, Set<File> returnFiles) throws WikiParserException, IOException {
		for (File next : getLinkedFiles(file)) {
			if (foundFiles.contains(next)) {
				continue;
			}
			foundFiles.add(next);
			String extension = FilenameUtils.getExtension(next.getName());
			if ("html".equalsIgnoreCase(extension)) {
				File wikiFile = new File(FilenameUtils.removeExtension(next.getAbsolutePath()) + ".wiki");
				if (wikiFile.exists() && wikiFile.canRead()) {
					returnFiles.add(wikiFile);
					findLinkedFilesRec(file, foundFiles, returnFiles);
				} else {
					returnFiles.add(file);
				}
			} else {
				// FIXME iterate over HTML files
				returnFiles.add(file);
			}
		}
	}

	public static List<File> getLinkedFiles(File wikiFile) throws WikiParserException, IOException {
		Node root = WikiPageParser.tokenizeAndParse(FileUtils.readFileToString(wikiFile, "UTF-8"));
		List<String> files = new ArrayList<String>();
		findFiles(files, root);
		List<File> returnFiles = new ArrayList<File>();
		for (String file : files) {
			if (file == null) {
				continue;
			}
			File returnFile = new File(wikiFile.getParent(), file);
			returnFiles.add(returnFile);
		}
		return returnFiles;
	}
	
	private static void findFiles(List<String> files, Node root) {
		if (root.getNodes() == null) {
			return;
		}
		for (Node node : root.getNodes()) {
			if ("tLink".equals(node.getName()) || "tImage".equals(node.getName())) {
				files.add(node.getContents());
			}
			findFiles(files, node);
		}
	}
	
	public static void main(String[] args) throws WikiParserException, IOException {
		Set<File> files = getLinkedFilesTransitiveClosure(new File("/home/raivo/web/index.wiki"));
		for (File file : files) {
			System.out.println(file);
		}
	}
	
}
