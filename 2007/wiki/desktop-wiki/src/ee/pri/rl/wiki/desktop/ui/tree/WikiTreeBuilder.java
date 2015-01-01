package ee.pri.rl.wiki.desktop.ui.tree;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;

/**
 * Creates wiki tree from directory path.
 */

public class WikiTreeBuilder {

	public static WikiTreeNode buildTree(String directory) throws IOException {
		if (directory == null) {
			throw new IllegalArgumentException("Given path is null!");
		}
		File file = new File(directory);
		WikiTreeNode root = new WikiTreeNode();
		root.setNodes(new ArrayList<WikiTreeNode>());
		root.setPath(file.getCanonicalPath());
		findNodes(root, file.getAbsoluteFile());
		return root;
	}

	private static boolean findNodes(WikiTreeNode root, File path) {
		validateDirectory(path);
		boolean containsWikiPage = false;
		for (File file : path.listFiles()) {
			if (isWikiFile(file)) {
				WikiTreeNode node = new WikiTreeNode();
				node.setPath(file.getAbsolutePath());
				node.setParent(root);
				root.getNodes().add(node);
				containsWikiPage = true;
			} else if (isReadableDirectory(file)) {
				WikiTreeNode node = new WikiTreeNode();
				node.setPath(file.getAbsolutePath());
				node.setParent(root);
				node.setNodes(new ArrayList<WikiTreeNode>());
				if (findNodes(node, file)) {
					containsWikiPage = true;
					root.getNodes().add(node);
				}
			}
		}
		if (containsWikiPage) {
			Collections.sort(root.getNodes());
		}
		return containsWikiPage;
	}
	
	private static boolean isReadableDirectory(File file) {
		return file != null && file.canRead() && file.isDirectory() && !file.isHidden();
	}
	
	private static boolean isWikiFile(File file) {
		return file != null && file.canRead() && file.getName().endsWith(".wiki");
	}
	
	private static void validateDirectory(File file) {
		if (!file.exists()) {
			throw new IllegalArgumentException("Given path " + file + " does not exist!");
		}
		if (!file.isDirectory()) {
			throw new IllegalArgumentException("Given path " + file + " does not denote the directory!");
		}
		if (!file.canRead()) {
			throw new IllegalArgumentException("Given directory " + file + " cannot be read!");
		}
	}
	
}
