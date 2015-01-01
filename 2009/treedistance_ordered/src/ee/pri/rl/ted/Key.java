package ee.pri.rl.ted;

public final class Key {
	public final Forest left;
	public final Forest right;
	
	public Key(Forest left, Forest right) {
		this.left = left;
		this.right = right;
	}

	@Override
	public boolean equals(Object obj) {
		Key key = (Key) obj;
		return left.equals(key.left) && right.equals(key.right);
	}

	@Override
	public int hashCode() {
		return left.hashCode() ^ right.hashCode();
	}

	@Override
	public String toString() {
		return left.toString() + " ~ " + right.toString();
	}
	
}
