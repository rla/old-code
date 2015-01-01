package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;

/**
 * Output:
 * <pre>
 * Graph1 - number of edges: 1000
 * Graph2 - number of edges: 2000
 * Graph Small - number of edges: 24
 * Graph1 (symmetric) - number of edges: 1972
 * Graph2 (symmetric) - number of edges: 3989
 * Graph Small (symmetric) - number of edges: 46
 * </pre>
 */
public class Solution1 {

	public static void main(String[] args) throws IOException {
		Graph<Integer> graph1 = IntGraphReader.read(new File("data/graph1.txt"), 1000);
		Graph<Integer> graph2 = IntGraphReader.read(new File("data/graph2.txt"), 1000);
		Graph<Integer> graphSmall = IntGraphReader.read(new File("data/graph_small.txt"), 12);
		
		System.out.println("Graph1 - number of edges: " + graph1.getNumberOfEdges());
		System.out.println("Graph2 - number of edges: " + graph2.getNumberOfEdges());
		System.out.println("Graph Small - number of edges: " + graphSmall.getNumberOfEdges());
		
		graph1.symmetrize();
		graph2.symmetrize();
		graphSmall.symmetrize();
		
		System.out.println("Graph1 (symmetric) - number of edges: " + graph1.getNumberOfEdges());
		System.out.println("Graph2 (symmetric) - number of edges: " + graph2.getNumberOfEdges());
		System.out.println("Graph Small (symmetric) - number of edges: " + graphSmall.getNumberOfEdges());
	}

}
