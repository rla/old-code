package ee.pri.rl.algorithmics.ted.util;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.algorithmics.ted.InnerNode;
import ee.pri.rl.algorithmics.ted.LeafNode;
import ee.pri.rl.algorithmics.ted.Node;

public class TreeUtil {
	
	public static List<LeafNode> findLeafs(Node tree) {
		List<LeafNode> leafs = new ArrayList<LeafNode>();
		findLeafs(tree, leafs);
		
		return leafs;
	}

	private static void findLeafs(Node tree, List<LeafNode> leafs) {
		if (tree instanceof LeafNode) {
			leafs.add((LeafNode) tree);
		} else {
			InnerNode innerNode = (InnerNode) tree;
			findLeafs(innerNode.getLeft(), leafs);
			findLeafs(innerNode.getRight(), leafs);
		}
	}
}
