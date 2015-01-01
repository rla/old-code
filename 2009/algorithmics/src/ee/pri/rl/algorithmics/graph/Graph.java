package ee.pri.rl.algorithmics.graph;

import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

public class Graph<T> {
	private final Map<T, Node<T>> map;
	
	public Graph() {
		map = new HashMap<T, Node<T>>();
	}
	
	public void addNode(T value) {
		if (!map.containsKey(value)) {
			map.put(value, new Node<T>(value));
		}
	}
	
	public void connect(T a, T b) {
		getNode(a).getConnections().add(getNode(b));
	}
	
	public int getNumberOfEdges() {
		int edges = 0;
		for (Node<T> node : map.values()) {
			edges += node.getConnections().size();
		}
		
		return edges;
	}
	
	public void symmetrize() {
		for (Node<T> node : map.values()) {
			for (Node<T> connectedNode : node.getConnections()) {
				connectedNode.getConnections().add(node);
			}
		}
	}
	
	public List<Set<Node<T>>> findConnectedComponents() {
		List<Set<Node<T>>> components = new LinkedList<Set<Node<T>>>();
		
		Set<Node<T>> visitedNodes = new HashSet<Node<T>>();
		
		for (Node<T> node : map.values()) {
			if (!visitedNodes.contains(node)) {
				ReachableFinder finder = new ReachableFinder();
				dfs(node, finder);
				Set<Node<T>> component = finder.getReachableSet();
				visitedNodes.addAll(component);
				components.add(component);
			}
		}
		
		return components;
	}
	
	public void bfs(T start, NodeVisitor<T> visitor) {
		Queue<EdgeVisit> toVisit = new LinkedList<EdgeVisit>();
		toVisit.add(new EdgeVisit(null, getNode(start)));
		Set<Node<T>> loopKiller = new HashSet<Node<T>>();
		loopKiller.add(getNode(start));
		
		while (!toVisit.isEmpty()) {
			EdgeVisit edgeVisit = toVisit.poll();
			visitor.visit(edgeVisit.to, edgeVisit.from);
			loopKiller.add(edgeVisit.to);
			
			for (Node<T> node : edgeVisit.to.getConnections()) {
				if (!loopKiller.contains(node)) {
					loopKiller.add(node);
					toVisit.offer(new EdgeVisit(edgeVisit.to, node));
				}
			}
		}
	}
	
	public void dfs(T start, NodeVisitor<T> visitor) {
		dfs(getNode(start), visitor);
	}
	
	private void dfs(Node<T> start, NodeVisitor<T> visitor) {
		Set<Node<T>> loopKiller = new HashSet<Node<T>>();
		loopKiller.add(start);
		dfs(start, visitor, loopKiller, null);
	}
	
	private void dfs(Node<T> node, NodeVisitor<T> visitor, Set<Node<T>> loopKiller, Node<T> parent) {
		visitor.visit(node, parent);
		loopKiller.add(node);
		
		for (Node<T> next : node.getConnections()) {
			if (!loopKiller.contains(next)) {
				loopKiller.add(node);
				dfs(next, visitor, loopKiller, node);
			}
		}
	}
	
	public int size() {
		return map.size();
	}
	
	public Collection<Node<T>> getNodes() {
		return map.values();
	}
	
	private Node<T> getNode(T value) {
		Node<T> node = map.get(value);
		if (node == null) {
			node = new Node<T>(value);
			map.put(value, node);
		}
		
		return node;
	}
	
	private class EdgeVisit {
		public final Node<T> from;
		public final Node<T> to;
		
		public EdgeVisit(Node<T> from, Node<T> to) {
			this.from = from;
			this.to = to;
		}
	}
	
	private class ReachableFinder implements NodeVisitor<T> {
		private final Set<Node<T>> reachableSet;
		
		public ReachableFinder() {
			reachableSet = new HashSet<Node<T>>();
		}

		@Override
		public void visit(Node<T> node, Node<T> from) {
			reachableSet.add(node);
		}

		public Set<Node<T>> getReachableSet() {
			return reachableSet;
		}
		
	}
}
