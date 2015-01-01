package ee.pri.rl.treedistance.tree;


public class Leaf extends Node {
	private String label;
	private Node brother;
	
	public Leaf(String label) {
		this.label = label;
	}

	public void setBrother(Node brother) {
		this.brother = brother;
	}

	public String getLabel() {
		return label;
	}
	
	public Node getBrother() {
		return brother;
	}

	@Override
	public String toString() {
		return label;
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof Leaf && ((Leaf) obj).getLabel().equals(label);
	}

	@Override
	public int hashCode() {
		return label.hashCode();
	}

	@Override
	public boolean isLeaf() {
		return true;
	}
	
	public boolean isLeft() {
		return getParent() != null && getParent().getLeft() == this;
	}
	
}
