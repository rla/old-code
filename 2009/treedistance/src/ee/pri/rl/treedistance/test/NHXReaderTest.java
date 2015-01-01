package ee.pri.rl.treedistance.test;

import java.io.File;
import java.io.IOException;

import junit.framework.TestCase;
import ee.pri.rl.treedistance.io.NHXParserException;
import ee.pri.rl.treedistance.io.NHXReader;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.Node;
import ee.pri.rl.treedistance.util.TreeUtil;

public class NHXReaderTest extends TestCase {
	
	public void testParse() throws IOException, NHXParserException {
		Node node = NHXReader.readTree(new File("data/test.txt"));
		System.out.println(node);
		
		for (Leaf leaf : TreeUtil.findLeafs(node)) {
			System.out.println(leaf);
		}
	}
}
