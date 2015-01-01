package ee.pri.rl.ted;

import java.util.Arrays;


public final class Forest {
	public static final Forest EMPTY_FOREST = new Forest(new Node[0]);
	
	public final Node[] roots;

	public Forest(Node... roots) {
		this.roots = roots;
	}

	@Override
	public boolean equals(Object obj) {
		return Arrays.equals(roots, ((Forest) obj).roots);
	}

	@Override
	public int hashCode() {
		return Arrays.hashCode(roots);
	}

	@Override
	public String toString() {
		return Arrays.toString(roots);
	}

}
