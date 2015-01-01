package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;

/**
 * Output:
 * 
 * <pre>
 * Graph1 - reach from 1 using BFS: 199
 * Graph1 - reach from 1 using DFS: 199
 * Graph1 - reach from 10 using BFS: 199
 * Graph1 - reach from 10 using DFS: 199
 * Graph1 - reach from 500 using BFS: 0
 * Graph1 - reach from 500 using DFS: 0
 * Graph1 - reach from 999 using BFS: 0
 * Graph1 - reach from 999 using DFS: 0
 * Graph2 - reach from 1 using BFS: 979
 * Graph2 - reach from 1 using DFS: 979
 * Graph2 - reach from 10 using BFS: 979
 * Graph2 - reach from 10 using DFS: 979
 * Graph2 - reach from 500 using BFS: 979
 * Graph2 - reach from 500 using DFS: 979
 * Graph2 - reach from 999 using BFS: 979
 * Graph2 - reach from 999 using DFS: 979
 * GraphSmall - reach from 1 using BFS: 11
 * GraphSmall - reach from 1 using DFS: 11
 * Graph 1 num. of components: 801
 * Graph 2 num. of components: 21
 * Small graph num. of components: 1
 * </pre>
 */
public class Solution3 {

	public static void main(String[] args) throws IOException {
		Graph<Integer> graph1 = IntGraphReader.read(new File("data/graph1.txt"), 1000);
		Graph<Integer> graph2 = IntGraphReader.read(new File("data/graph2.txt"), 1000);
		Graph<Integer> graphSmall = IntGraphReader.read(new File("data/graph_small.txt"), 12);
		
		graph1.symmetrize();
		graph2.symmetrize();
		graphSmall.symmetrize();
		
		Solution2.printnNodeReachability(graph1, new int[] {1, 10, 500, 999}, "Graph1");
		Solution2.printnNodeReachability(graph2, new int[] {1, 10, 500, 999}, "Graph2");
		Solution2.printnNodeReachability(graphSmall, new int[] {1}, "GraphSmall");
		
		System.out.println("Graph 1 num. of components: " + graph1.findConnectedComponents().size());
		System.out.println("Graph 2 num. of components: " + graph2.findConnectedComponents().size());
		System.out.println("Small graph num. of components: " + graphSmall.findConnectedComponents().size());
	}

}
