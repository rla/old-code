package ee.pri.rl.treedistance.tree.modifications;

import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.Node;

/**
 * Operation of swapping two leafs of one tree so that in the other tree the two
 * leafs have also same parent.
 */
public class TreeLeafSwapModification extends TreeModification {
	private Branch branch1;
	private Branch branch1New;
	private Branch branch2;
	private Branch branch2New;
	private Leaf first;
	private Leaf second;

	public TreeLeafSwapModification(Branch branch1, Branch branch1New, Branch branch2, Branch branch2New, Leaf first, Leaf second) {
		this.branch1 = branch1;
		this.branch1New = branch1New;
		this.branch2 = branch2;
		this.branch2New = branch2New;
		this.first = first;
		this.second = second;
	}

	public Leaf getFirst() {
		return first;
	}

	public Leaf getSecond() {
		return second;
	}

	@Override
	protected Node getLocalModificationResult(Node original) {
		if (original instanceof Branch) {
			if (original == branch1) {
				return branch1New;
			} else if (original == branch2) {
				return branch2New;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	
}
