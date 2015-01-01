package ee.pri.rl.treedistance.tree.modifications;

import ee.pri.rl.treedistance.tree.Node;

public abstract class TreeModification implements Comparable<TreeModification> {
	private double value;
	private TreeModification previous;

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}

	public TreeModification getPrevious() {
		return previous;
	}

	public void setPrevious(TreeModification previous) {
		this.previous = previous;
	}
	
	public Node getModificationResult(Node original) {
		Node result = null;
		if (previous != null) {
			result = previous.getModificationResult(original);
		}
		if (result != null) {
			Node result1 = result;
			result = getLocalModificationResult(result);
			if (result == null) {
				return result1;
			} else {
				return result;
			}
		} else {
			result = getLocalModificationResult(original);
			if (result == null) {
				return original;
			} else {
				return result;
			}
		}
	}
	
	protected abstract Node getLocalModificationResult(Node original);

	@Override
	public int compareTo(TreeModification o) {
		return new Double(value).compareTo(o.getValue());
	}

}
