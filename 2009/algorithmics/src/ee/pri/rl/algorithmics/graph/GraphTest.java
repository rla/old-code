package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;

import junit.framework.TestCase;

public class GraphTest extends TestCase {
	
	public void test() throws IOException {
		Graph<Integer> graph = IntGraphReader.read(new File("data/graph_small.txt"), 12);
		assertEquals(12, graph.size());
		
		DotWriter.writeGraph(graph, new File("data/graph_small.dot"));
		
		graph.symmetrize();
		DotWriter.writeGraph(graph, new File("data/graph_small_sym.dot"));
	}
	
	public void testGraph2() throws IOException {
		Graph<Integer> graph = IntGraphReader.read(new File("data/graph2.txt"), 1000);
		
		DotWriter.writeGraph(graph, new File("data/graph2.dot"));
	}
}
