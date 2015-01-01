package ee.pri.rl.algorithmics.ted;

public abstract class Node {
	private InnerNode parent;

	public InnerNode getParent() {
		return parent;
	}

	public void setParent(InnerNode parent) {
		this.parent = parent;
	}
	
}
