package ee.pri.rl.wiki.desktop.ui.tree;

import java.io.File;
import java.util.Enumeration;
import java.util.List;
import java.util.Vector;

import javax.swing.tree.TreeNode;

/**
 * TreeNode for wiki.
 */

public class WikiTreeNode implements TreeNode, Comparable<WikiTreeNode> {
	private String path;
	private List<WikiTreeNode> nodes;
	private WikiTreeNode parent;
	
	public Enumeration<WikiTreeNode> children() {
		if (nodes != null) {
			return new Vector<WikiTreeNode>(nodes).elements();
		}
		return null;
	}

	public boolean getAllowsChildren() {
		return nodes != null;
	}

	public TreeNode getChildAt(int childIndex) {
		return nodes == null || childIndex < 0 || childIndex >= nodes.size() ? null : nodes.get(childIndex);
	}

	public int getChildCount() {
		return nodes == null ? 0 : nodes.size();
	}

	public int getIndex(TreeNode node) {
		return nodes == null ? -1 : nodes.indexOf(node);
	}

	public TreeNode getParent() {
		return parent;
	}

	public boolean isLeaf() {
		return nodes == null;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj != null && obj instanceof WikiTreeNode) {
			WikiTreeNode other = (WikiTreeNode) obj;
			return path != null && path.equals(other.getPath());
		} else {
			return false;
		}
	}

	@Override
	public int hashCode() {
		return path == null ? 0 : path.hashCode();
	}

	@Override
	public String toString() {
		if (path != null) {
			String name = new File(path).getName();
			if (name.length() > 0) {
				int pos = name.lastIndexOf('.');
				return Character.toUpperCase(name.charAt(0)) + (pos > 0 ? name.substring(1, pos) : name.substring(1)).replace('_', ' ');
			}
		}
		return ""; 
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public List<WikiTreeNode> getNodes() {
		return nodes;
	}

	public void setNodes(List<WikiTreeNode> nodes) {
		this.nodes = nodes;
	}

	public void setParent(WikiTreeNode parent) {
		this.parent = parent;
	}

	public int compareTo(WikiTreeNode o) {
		if (o == null) {
			return 1;
		}
		int byLeaf = compareByLeafness(o);
		if (byLeaf != 0) {
			return byLeaf;
		}
		return toString().compareTo(o.toString());
	}
	
	private int compareByLeafness(WikiTreeNode o) {
		if (isLeaf()) {
			return o.isLeaf() ? 0 : 1;
		} else {
			return o.isLeaf() ? -1 : 0;
		}
	}

}
