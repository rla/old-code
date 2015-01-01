package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;

public class SolutionBonus {

	public static void main(String[] args) throws IOException {
		Graph<Integer> graph1 = IntGraphReader.read(new File("data/graph1.txt"), 1000);
		Graph<Integer> graph2 = IntGraphReader.read(new File("data/graph2.txt"), 1000);
		Graph<Integer> graphSmall = IntGraphReader.read(new File("data/graph_small.txt"), 12);
		
		DotWriter.writeGraph(graph1, new File("data/graph1.dot"));
		DotWriter.writeGraph(graph2, new File("data/graph2.dot"));
		DotWriter.writeGraph(graphSmall, new File("data/graph_small.dot"));
	}

}
