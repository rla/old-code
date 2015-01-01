package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Scanner;

import org.apache.commons.io.FileUtils;

public class IntGraphReader {
	
	@SuppressWarnings("unchecked")
	public static Graph<Integer> read(File file, int numberOfVertices) throws IOException {
		Graph<Integer> graph = new Graph<Integer>();
		
		for (int i = 0; i < numberOfVertices; i++) {
			graph.addNode(i);
		}
		
		for (String line : (List<String>) FileUtils.readLines(file)) {
			Scanner scn = new Scanner(line);
			graph.connect(scn.nextInt(), scn.skip("\\s*>\\s*").nextInt());
		}
		
		return graph;
	}
}
