package ee.pri.rl.algorithmics.graph.weighted;

/**
 * 
 * <pre>
 * d --> e (6.0 6.0)
 * d --> b (3.0 2.0)
 * d --> c (4.0 1.0)
 * e --> t (6.0 6.0)
 * e --> c (2.0 2.0)
 * s --> d (8.0 8.0)
 * s --> b (4.0 0.0)
 * s --> a (5.0 4.0)
 * b --> e (5.0 2.0)
 * c --> e (2.0 0.0)
 * c --> t (10.0 6.0)
 * c --> a (2.0 0.0)
 * a --> d (1.0 1.0)
 * a --> c (3.0 3.0)
 * </pre>
 */
public class Solution6 {

	public static void main(String[] args) {
		Graph<String, FlowEdgeData> g = new Graph<String, FlowEdgeData>();
		g.addNode("a");
		g.addNode("b");
		g.addNode("c");
		g.addNode("d");
		g.addNode("e");
		g.addNode("s");
		g.addNode("t");
		
		g.connect("s", "a", new FlowEdgeData(5));
		g.connect("s", "d", new FlowEdgeData(8));
		g.connect("s", "b", new FlowEdgeData(4));
		
		g.connect("a", "c", new FlowEdgeData(3));
		g.connect("a", "d", new FlowEdgeData(1));
		
		g.connect("b", "e", new FlowEdgeData(5));
		
		g.connect("d", "c", new FlowEdgeData(4));
		g.connect("d", "b", new FlowEdgeData(3));
		g.connect("d", "e", new FlowEdgeData(6));
		
		g.connect("c", "a", new FlowEdgeData(2));
		g.connect("c", "t", new FlowEdgeData(10));
		g.connect("c", "e", new FlowEdgeData(2));
		
		g.connect("e", "t", new FlowEdgeData(6));
		g.connect("e", "c", new FlowEdgeData(2));
		
		maxFlow(g, "s", "t");
		
		for (Node<String, FlowEdgeData> node : g) {
			for (Edge<String, FlowEdgeData> edge : node.getConnections()) {
				System.out.println(edge);
			}
		}
	}
	
	private static <T> void maxFlow(Graph<T, FlowEdgeData> g, T start, T end) {
		EdgePredicate<T, FlowEdgeData> predicate = new FlowLessThanCapacityEdgePredicate<T>();
		Path<T, FlowEdgeData> path = null;
		while ((path = g.findPath(start, end, predicate)) != null) {
			double minRemainingCapacity = Double.MAX_VALUE;
			
			// Find minimum capacity on current path
			for (Edge<T, FlowEdgeData> edge : path) {
				double remainingCapacity = edge.data.getRemainingCapacity();
				if (remainingCapacity < minRemainingCapacity) {
					minRemainingCapacity = remainingCapacity;
				}
			}
			
			// Send flow with minimum capacity through current path
			for (Edge<T, FlowEdgeData> edge : path) {
				edge.data.setFlow(edge.data.getFlow() + minRemainingCapacity);
				Edge<T, FlowEdgeData> backwards = edge.to.getEdge(edge.from);
				if (backwards != null) {
					backwards.data.setFlow(edge.data.getFlow() - minRemainingCapacity);
				}
			}
		}
	}
	
	private static class FlowLessThanCapacityEdgePredicate<T> implements EdgePredicate<T, FlowEdgeData> {

		@Override
		public boolean isPassable(Edge<T, FlowEdgeData> edge) {
			return edge.data.getCapacity() > edge.data.getFlow();
		}
		
	}

}
