package ee.pri.rl.treedistance.tree;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ee.pri.rl.treedistance.util.TreeUtil;

public class TreeContext {
	private Node root;
	private Map<String, Leaf> leafs; // All original + generated labels
	
	public TreeContext(Node root) {
		this.leafs = new HashMap<String, Leaf>();
		this.root = root;
		
		List<Leaf> leafs = TreeUtil.findLeafs(root);
		for (Leaf leaf : leafs) {
			this.leafs.put(leaf.getLabel(), leaf);
		}
	}

	public Leaf getLeaf(String label) {
		return leafs.get(label);
	}
	
	public void putLeaf(Leaf leaf) {
		leafs.put(leaf.getLabel(), leaf);
	}
	
	public Node getRoot() {
		return root;
	}
}
