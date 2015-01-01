package ee.pri.rl.algorithmics.graph.weighted;

import java.util.Iterator;


public class Path<T, W> implements Iterable<Edge<T, W>> {
	public final Node<T, W> node;
	public final Edge<T, W> head;
	public final Path<T, W> tail;
	
	public Path(Node<T, W> node, Edge<T, W> head, Path<T, W> tail) {
		this.node = node;
		this.head = head;
		this.tail = tail;
	}

	@Override
	public Iterator<Edge<T, W>> iterator() {
		return new PathIterator(this);
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		builder.append('[');
		boolean first = true;
		for (Edge<T, W> edge : this) {
			if (first) {
				first = false;
			} else {
				builder.append(", ");
				builder.append(edge);
			}
		}
		builder.append(']');
		
		return builder.toString();
	}

	private class PathIterator implements Iterator<Edge<T, W>> {
		private Path<T, W> path;

		public PathIterator(Path<T, W> path) {
			this.path = path;
		}

		@Override
		public boolean hasNext() {
			return path != null;
		}

		@Override
		public Edge<T, W> next() {
			Edge<T, W> edge = path.head;
			path = path.tail;
			
			return edge;
		}

		@Override
		public void remove() {
			throw new UnsupportedOperationException("Cannot remove edge from path");
		}
		
	}
	
}
