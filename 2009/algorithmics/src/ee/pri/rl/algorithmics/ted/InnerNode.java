package ee.pri.rl.algorithmics.ted;

public class InnerNode extends Node {
	private Node left;
	private Node right;
	
	public InnerNode(Node left, Node right) {
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

}
