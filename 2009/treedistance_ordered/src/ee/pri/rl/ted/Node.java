package ee.pri.rl.ted;

import java.util.Arrays;


public final class Node {
	private int id;
	public final Node[] nodes;
	public final char value;
	
	public Node(char value, Node... nodes) {
		this.nodes = nodes;
		this.value = value;
	}

	public Node[] getNodes() {
		return nodes;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	@Override
	public boolean equals(Object obj) {
		return id == ((Node) obj).getId();
	}

	@Override
	public int hashCode() {
		return id;
	}
	
	public boolean isEmpty() {
		return nodes == null;
	}

	@Override
	public String toString() {
		return Character.valueOf(value).toString() + Arrays.toString(nodes);
	}
	
	
	
}
