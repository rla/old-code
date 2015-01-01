package ee.pri.rl.parser;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Single node in parse tree.
 */

public class Node implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private List<Node> nodes;
	private String name;
	private String contents;
	
	public Node(String name) {
		this.name = name;
		nodes = new ArrayList<Node>();
		contents = null;
	}
	
	public void addNode(Node node) {
		nodes.add(node);
	}

	public List<Node> getNodes() {
		return nodes;
	}

	public String getName() {
		return name;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	@Override
	public String toString() {
		return name + ":" + contents + ":" + nodes.size();
	}
	
	/**
	 * Get subnode by name. If the node with given name
	 * does not exist returns null.
	 */
	
	public Node getNodeByName(String name) {
		for (Node node : nodes) {
			if (node.getName().equals(name)) {
				return node;
			}
		}
		return null;
	}

	public void setNodes(List<Node> nodes) {
		this.nodes = nodes;
	}
}
