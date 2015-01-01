package ee.pri.rl.algorithmics.graph.weighted;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class Node<T, W> implements Iterable<Edge<T, W>> {
	private final T value;
	private final Set<Edge<T, W>> connections;
	
	public Node(T value) {
		this.value = value;
		this.connections = new HashSet<Edge<T, W>>();
	}

	public Set<Edge<T, W>> getConnections() {
		return connections;
	}
	
	public Edge<T, W> getEdge(Node<T, W> to) {
		for (Edge<T, W> edge : connections) {
			if (edge.to.equals(to)) {
				return edge;
			}
		}
		
		return null;
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
		return obj instanceof Node && ((Node<?, ?>) obj).getValue().equals(value); 
	}

	@Override
	public String toString() {
		return value.toString();
	}

	@Override
	public Iterator<Edge<T, W>> iterator() {
		return connections.iterator();
	}
	
}
