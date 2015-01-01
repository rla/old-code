package ee.pri.rl.wiki.desktop.test;

import java.io.IOException;

import ee.pri.rl.wiki.desktop.ui.tree.WikiTreeBuilder;
import ee.pri.rl.wiki.desktop.ui.tree.WikiTreeNode;
import junit.framework.TestCase;

/**
 * Test cases for wiki tree builder.
 */

public class WikiTreeBuilderTest extends TestCase {

	public void testBuildTree() throws IOException {
		WikiTreeNode root = WikiTreeBuilder.buildTree("/home/raivo/web");
		assertNotNull(root);
		assertNotNull(root.getNodes());
		assertTrue(root.getChildCount() > 0);
	}
}
