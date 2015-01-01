package ee.pri.rl.parser.support.xml;

import ee.pri.rl.parser.Node;

/**
 * Output writer that produces XML representation of abstract syntax tree with
 * token contents. This class does not provide DOM tree but writes XML directly
 * as string. The line ends in the output string will be \n. The producer writes
 * no XML version tag allowing easy insertion of xsl stylesheet name or other
 * things like that.
 */

public class XMLProducer {

	public static String getXML(Node node) {
		StringBuilder stringBuilder = new StringBuilder();
		writeToBuffer(node, stringBuilder, "");
		return stringBuilder.toString();
	}

	private static void writeToBuffer(Node node, StringBuilder stringBuilder, String indent) {
		stringBuilder.append(indent);
		stringBuilder.append("<" + node.getName() + ">\n");

		if (node.getContents() != null) {
			String contents = indent + node.getContents().replace("\n", "\n" + indent);
			stringBuilder.append(contents);
			stringBuilder.append('\n');
		}

		for (Node child : node.getNodes()) {
			writeToBuffer(child, stringBuilder, indent + "\t");
		}

		stringBuilder.append(indent);
		stringBuilder.append("</" + node.getName() + ">\n");
	}
}
