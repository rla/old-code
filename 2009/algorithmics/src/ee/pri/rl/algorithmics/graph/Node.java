package ee.pri.rl.algorithmics.graph;

import java.util.HashSet;
import java.util.Set;

public class Node<T> {
	private final T value;
	private final Set<Node<T>> connections;
	
	public Node(T value) {
		this.value = value;
		this.connections = new HashSet<Node<T>>();
	}

	public Set<Node<T>> getConnections() {
		return connections;
	}

	public T getValue() {
		return value;
	}

	@Override
	public int hashCode() {
		return value.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof Node && ((Node<?>) getValue()).equals(value); 
	}

	@Override
	public String toString() {
		return value.toString();
	}
	
}
