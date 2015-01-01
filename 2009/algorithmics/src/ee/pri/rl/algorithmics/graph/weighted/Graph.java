package ee.pri.rl.algorithmics.graph.weighted;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

public class Graph<T, W> implements Iterable<Node<T, W>> {
	private final Map<T, Node<T, W>> map;
	
	public Graph() {
		map = new HashMap<T, Node<T, W>>();
	}
	
	public void connect(T a, T b, W data) {
		Node<T, W> nodeA = getMakeNode(a);
		nodeA.getConnections().add(new Edge<T, W>(nodeA, getMakeNode(b), data));
	}
	
	public void addNode(T value) {
		if (!map.containsKey(value)) {
			map.put(value, new Node<T, W>(value));
		}
	}
	
	public boolean hasNode(T value) {
		return map.containsKey(value);
	}
	
	public Node<T, W> getNode(T value) {
		return map.get(value);
	}
	
	private Node<T, W> getMakeNode(T value) {
		Node<T, W> node = map.get(value);
		if (node == null) {
			node = new Node<T, W>(value);
			map.put(value, node);
		}
		
		return node;
	}
	
	@Override
	public Iterator<Node<T, W>> iterator() {
		return map.values().iterator();
	}
	
	/**
	 * Assumes start != end.
	 */
	public Path<T, W> findPath(T start, T end, EdgePredicate<T, W> predicate) {
		assert !start.equals(end);
		
		Set<Node<T, W>> loopKiller = new HashSet<Node<T,W>>();
		PathResult<T, W> result = findPath(getMakeNode(start), getMakeNode(end), loopKiller, predicate);
		
		if (result.hasFound()) {
			return result.path;
		} else {
			return null;
		}
	}
	
	private PathResult<T, W> findPath(
			Node<T, W> start,
			Node<T, W> end,
			Set<Node<T, W>> loopKiller,
			EdgePredicate<T, W> predicate) {
		
		for (Edge<T, W> edge : start) {
			if (!predicate.isPassable(edge)) {
				continue;
			}
			if (loopKiller.contains(edge.to)) {
				continue;
			}
			if (edge.to.equals(end)) {
				return PathResult.foundPath(new Path<T, W>(start, edge, null));
			}
			loopKiller.add(edge.to);
			PathResult<T, W> result = findPath(edge.to, end, loopKiller, predicate);
			if (result.hasFound()) {
				return PathResult.foundPath(new Path<T, W>(start, edge, result.path));
			}
		}
		return PathResult.notFoundPath();
	}
	
	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		for (Node<T, W> node : map.values()) {
			for (Edge<T, W> edge : node) {
				builder
					.append(edge.from)
					.append(" -(").append(edge.data).append(")-> ")
					.append(edge.to)
					.append('\n');
			}
		}
		
		return builder.toString();
	}

	private static class PathResult<T, W> {
		public final Path<T, W> path;
		
		private PathResult(Path<T, W> path) {
			this.path = path;
		}

		public static <T, W> PathResult<T, W> foundPath(Path<T, W> path) {
			return new PathResult<T, W>(path);
		}
		
		public static <T, W> PathResult<T, W> notFoundPath() {
			return new PathResult<T, W>(null);
		}
		
		public boolean hasFound() {
			return path != null;
		}
	}

}
