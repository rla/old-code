package ee.pri.rl.algorithmics.ted;

public class LeafNode extends Node {
	private String label;

	public LeafNode(String label) {
		this.label = label;
	}

	public String getLabel() {
		return label;
	}

	@Override
	public String toString() {
		return label;
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof LeafNode && ((LeafNode) obj).getLabel().equals(label);
	}

	@Override
	public int hashCode() {
		return label.hashCode();
	}
	
}
