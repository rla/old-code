package ee.pri.rl.wiki.desktop.process;

import java.util.List;

import ee.pri.rl.parser.Node;

/**
 * Tree of wiki pages.
 */

public class WikiTree {
	private String filename;
	private List<WikiTree> nodes;
	private Node root;

	/**
	 * Get the filename of this wikitree node.
	 */
	
	public String getFilename() {
		return filename;
	}

	/**
	 * Set the filename of this wikitree node.
	 */
	
	public void setFilename(String filename) {
		this.filename = filename;
	}

	/**
	 * Get the subnodes of this wikitree.
	 */
	
	public List<WikiTree> getNodes() {
		return nodes;
	}

	/**
	 * Set the subnodes of this wikitree.
	 */
	
	public void setNodes(List<WikiTree> nodes) {
		this.nodes = nodes;
	}

	/**
	 * Get document root node of this wikitree node.
	 */
	
	public Node getRoot() {
		return root;
	}

	/**
	 * Set document root node of this wikitree node.
	 */
	
	public void setRoot(Node root) {
		this.root = root;
	}
}
