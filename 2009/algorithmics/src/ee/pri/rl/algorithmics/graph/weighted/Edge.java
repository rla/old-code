package ee.pri.rl.algorithmics.graph.weighted;

public class Edge<T, W> {
	public final Node<T, W> from;
	public final Node<T, W> to;
	public final W data;
	
	public Edge(Node<T, W> from, Node<T, W> to, W data) {
		this.from = from;
		this.to = to;
		this.data = data;
	}
	
	@Override
	public boolean equals(Object obj) {
		return obj instanceof Edge && ((Edge<?, ?>) obj).to.equals(to); 
	}

	@Override
	public int hashCode() {
		return to.hashCode();
	}

	@Override
	public String toString() {
		return from + " --> " + to + " (" + data + ")";
	}
	
}
