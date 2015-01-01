package ee.pri.rl.algorithmics.graph.weighted;

import java.util.Random;

/**
 * <pre>
 * Number of steps: 100
 * 0: 34, 0.34
 * 1: 31, 0.31
 * 2: 2, 0.02
 * 3: 23, 0.23
 * 4: 10, 0.1
 * 
 * Number of steps: 1000
 * 0: 328, 0.328
 * 1: 311, 0.311
 * 2: 17, 0.017
 * 3: 246, 0.246
 * 4: 98, 0.098
 * 
 * Number of steps: 10000
 * 0: 3262, 0.3262
 * 1: 3097, 0.3097
 * 2: 165, 0.0165
 * 3: 2446, 0.2446
 * 4: 1030, 0.103
 * 
 * Number of steps: 100000
 * 0: 32604, 0.32604
 * 1: 31025, 0.31025
 * 2: 1579, 0.01579
 * 3: 23870, 0.2387
 * 4: 10922, 0.10922
 * 
 * Number of steps: 1000000
 * 0: 326103, 0.326103
 * 1: 309592, 0.309592
 * 2: 16510, 0.01651
 * 3: 238525, 0.238525
 * 4: 109270, 0.10927
</pre>
 */
public class Solution2 {

	public static void main(String[] args) {
		Graph<RandomWalkNode, Double> g = new Graph<RandomWalkNode, Double>();
		
		RandomWalkNode node0 = new RandomWalkNode(0);
		RandomWalkNode node1 = new RandomWalkNode(1);
		RandomWalkNode node2 = new RandomWalkNode(2);
		RandomWalkNode node3 = new RandomWalkNode(3);
		RandomWalkNode node4 = new RandomWalkNode(4);
		
		g.connect(node0, node1, 0.95);
		g.connect(node0, node2, 0.05);
		g.connect(node1, node3, 0.70);
		g.connect(node1, node4, 0.30);
		g.connect(node2, node4, 1.00);
		g.connect(node3, node0, 1.00);
		g.connect(node4, node3, 0.20);
		g.connect(node4, node0, 0.80);
		
		for (int steps = 100; steps <= 1000000; steps *= 10) {
			System.out.println("Number of steps: " + steps);
			
			randomWalk(g.getNode(node0), steps);
		
			for (Node<RandomWalkNode, Double> node : g) {
				System.out.println(
					node.getValue().getName() + ": " +
					node.getValue().getVisitedCount() + ", " +
					node.getValue().getVisitedCount() / Integer.valueOf(steps).doubleValue()
				);
			}
			System.out.println();
			
			for (Node<RandomWalkNode, Double> node : g) {
				node.getValue().reset();
			}
		}
	}
	
	private static void randomWalk(Node<RandomWalkNode, Double> start, int steps) {
		Random random = new Random(System.currentTimeMillis());
		Node<RandomWalkNode, Double> next = start;
		
		int i = steps;
		while (i-- > 0) {
			next.getValue().incVisitedCount();
			double d = random.nextDouble();
			double sum = 0;
			for (Edge<RandomWalkNode, Double> edge : next) {
				sum += edge.data;
				if (d < sum) {
					next = edge.to;
					break;
				}
			}
		}
	}

}
