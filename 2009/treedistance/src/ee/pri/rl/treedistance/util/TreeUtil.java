package ee.pri.rl.treedistance.util;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.Node;

public class TreeUtil {
	
	public static Leaf findMatchingLeaf(Leaf leaf, List<Leaf> leafs) {
		for (Leaf l : leafs) {
			if (leaf.equals(l)) {
				return l;
			}
		}
		
		return null;
	}
	
	public static List<Leaf> findLeafs(Node tree) {
		List<Leaf> leafs = new ArrayList<Leaf>();
		findLeafs(tree, leafs);
		
		return leafs;
	}

	private static void findLeafs(Node tree, List<Leaf> leafs) {
		if (tree instanceof Leaf) {
			leafs.add((Leaf) tree);
		} else {
			Branch innerNode = (Branch) tree;
			findLeafs(innerNode.getLeft(), leafs);
			findLeafs(innerNode.getRight(), leafs);
		}
	}
}
