package ee.pri.rl.treedistance.tree;


public class Branch extends Node {
	private Node left;
	private Node right;
	
	public Branch(Node left, Node right) {
		this.left = left;
		this.right = right;
	}

	public Node getLeft() {
		return left;
	}

	public Node getRight() {
		return right;
	}

	@Override
	public String toString() {
		return "(" + left + "," + right + ")";
	}

	@Override
	public boolean isLeaf() {
		return false;
	}

}
