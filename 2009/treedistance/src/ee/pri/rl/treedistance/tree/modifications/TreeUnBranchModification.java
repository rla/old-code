package ee.pri.rl.treedistance.tree.modifications;

import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.Node;

public class TreeUnBranchModification extends TreeModification {
	private Branch branchA;
	private Branch branchB;
	private Leaf leafA;
	private Leaf leafB;
	private Leaf first;
	private Leaf second;
	
	public TreeUnBranchModification(Branch branchA, Branch branchB, Leaf leafA, Leaf leafB, Leaf first, Leaf second) {
		this.branchA = branchA;
		this.branchB = branchB;
		this.leafA = leafA;
		this.leafB = leafB;
		this.first = first;
		this.second = second;
	}

	public Leaf getFirst() {
		return first;
	}

	public Leaf getSecond() {
		return second;
	}

	public Branch getBranchA() {
		return branchA;
	}
	
	public Branch getBranchB() {
		return branchB;
	}

	public Leaf getLeafA() {
		return leafA;
	}

	public Leaf getLeafB() {
		return leafB;
	}

	@Override
	protected Node getLocalModificationResult(Node original) {
		if (original instanceof Branch) {
			if (branchA == original) {
				return leafA;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	
}
