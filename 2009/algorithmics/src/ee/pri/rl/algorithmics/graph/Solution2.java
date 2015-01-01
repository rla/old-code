package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;

/**
 * Output:
 * <pre>
 * Graph1 - reach from 1 using BFS: 199
 * Graph1 - reach from 1 using DFS: 199
 * Graph1 - reach from 10 using BFS: 199
 * Graph1 - reach from 10 using DFS: 199
 * Graph1 - reach from 500 using BFS: 0
 * Graph1 - reach from 500 using DFS: 0
 * Graph1 - reach from 999 using BFS: 0
 * Graph1 - reach from 999 using DFS: 0
 * Graph2 - reach from 1 using BFS: 787
 * Graph2 - reach from 1 using DFS: 787
 * Graph2 - reach from 10 using BFS: 786
 * Graph2 - reach from 10 using DFS: 786
 * Graph2 - reach from 500 using BFS: 4
 * Graph2 - reach from 500 using DFS: 4
 * Graph2 - reach from 999 using BFS: 786
 * Graph2 - reach from 999 using DFS: 786
 * GraphSmall - reach from 1 using BFS: 6
 * GraphSmall - reach from 1 using DFS: 6
 * </pre>
 */
public class Solution2 {

	public static void main(String[] args) throws IOException {
		Graph<Integer> graph1 = IntGraphReader.read(new File("data/graph1.txt"), 1000);
		Graph<Integer> graph2 = IntGraphReader.read(new File("data/graph2.txt"), 1000);
		Graph<Integer> graphSmall = IntGraphReader.read(new File("data/graph_small.txt"), 12);
		
		printnNodeReachability(graph1, new int[] {1, 10, 500, 999}, "Graph1");
		printnNodeReachability(graph2, new int[] {1, 10, 500, 999}, "Graph2");
		printnNodeReachability(graphSmall, new int[] {1}, "GraphSmall");
	}
	
	public static void printnNodeReachability(Graph<Integer> graph, int[] starts, String name) {
		for (int i : starts) {
			ReachabilityCounter<Integer> r1Bfs = new ReachabilityCounter<Integer>();
			graph.bfs(i, r1Bfs);
			
			System.out.println(name + " - reach from " + i + " using BFS: " + (r1Bfs.getCount() - 1));
			
			ReachabilityCounter<Integer> r1Dfs = new ReachabilityCounter<Integer>();
			graph.dfs(i, r1Dfs);
			
			System.out.println(name + " - reach from " + i + " using DFS: " + (r1Dfs.getCount() - 1));
		}
	}
	
	private static class ReachabilityCounter<T> implements NodeVisitor<T> {
		private int count = 0;
		
		@Override
		public void visit(Node<T> node, Node<T> from) {
			count++;
		}

		public int getCount() {
			return count;
		}
		
	}

}
