package ee.pri.rl.treedistance.tree;


public abstract class Node {
	private Branch parent;
	
	public Branch getParent() {
		return parent;
	}

	public void setParent(Branch parent) {
		this.parent = parent;
	}
	
	public abstract boolean isLeaf();
}
