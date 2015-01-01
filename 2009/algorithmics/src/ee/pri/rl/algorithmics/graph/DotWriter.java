package ee.pri.rl.algorithmics.graph;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;

public class DotWriter {
	
	public static void writeGraph(Graph<?> graph, File file) throws IOException {
		StringBuilder builder = new StringBuilder();
		
		builder
			.append("digraph G {\n")
			.append("\tnode [fontsize=8,height=0.3,width=0.3,fixedsize=\"true\"]\n")
			.append("\tedge [len=8,arrowsize=.02]\n");
		
		for (Node<?> node : graph.getNodes()) {
			for (Node<?> connectedNode : node.getConnections()) {
				builder
					.append('\t').append('"').append(node).append('"')
					.append(" -> ").append('"').append(connectedNode).append('"').append('\n');
			}
		}
		
		for (Node<?> node : graph.getNodes()) {
			if (node.getConnections().isEmpty()) {
				builder.append('\t').append('"').append(node).append("\"\n");
			}
		}
		
		builder.append("}\n");
		
		FileUtils.writeStringToFile(file, builder.toString());
	}
}
