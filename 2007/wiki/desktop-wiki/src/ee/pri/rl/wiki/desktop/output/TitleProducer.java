package ee.pri.rl.wiki.desktop.output;

import ee.pri.rl.parser.Node;

public class TitleProducer {

	public static String findTitle(Node root) {
		Node heading = root.getNodeByName("tHeading1");
		return heading == null ? "Untitled" : heading.getContents();
	}
}
