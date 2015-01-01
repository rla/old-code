package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.MessageFormat;

public class Solution4 {

	public static void main(String[] args) throws IOException {
		Graph<Integer> graph1 = IntGraphReader.read(new File("data/graph1.txt"), 1000);
		Graph<Integer> graph2 = IntGraphReader.read(new File("data/graph2.txt"), 1000);
		Graph<Integer> graphSmall = IntGraphReader.read(new File("data/graph_small.txt"), 12);
		
		printnNodeReachabilityToFile(graph1, new int[] {1, 10, 500, 999}, "graph1");
		printnNodeReachabilityToFile(graph2, new int[] {1, 10, 500, 999}, "graph2");
		printnNodeReachabilityToFile(graphSmall, new int[] {1}, "graph_small");
	}
	
	public static void printnNodeReachabilityToFile(Graph<Integer> graph, int[] starts, String name) throws IOException {
		for (int i : starts) {
			OrderPrintingNodeVisitor<Integer> printVisitor = new OrderPrintingNodeVisitor<Integer>(new File("data/" + name + "_" + i + "_bfs.txt"));
			graph.bfs(i, printVisitor);
			printVisitor.close();
			
			
			printVisitor = new OrderPrintingNodeVisitor<Integer>(new File("data/" + name + "_" + i + "_dfs.txt"));
			graph.dfs(i, printVisitor);
			printVisitor.close();
		}
	}
	
	private static class OrderPrintingNodeVisitor<T> implements NodeVisitor<T> {
		private final PrintWriter writer;
		
		public OrderPrintingNodeVisitor(File file) throws IOException {
			writer = new PrintWriter(new FileWriter(file));
		}
		
		@Override
		public void visit(Node<T> node, Node<T> from) {
			if (from != null) {
				writer.println(MessageFormat.format("{0} -> {1}", from, node));
			}
		}
		
		public void close() throws IOException {
			writer.close();
		}
		
	}

}
