package ee.pri.rl.algorithmics.ted.test;

import java.io.File;
import java.io.IOException;

import junit.framework.TestCase;
import ee.pri.rl.algorithmics.ted.LeafNode;
import ee.pri.rl.algorithmics.ted.NHXReader;
import ee.pri.rl.algorithmics.ted.Node;
import ee.pri.rl.algorithmics.ted.NHXParser.ParseException;
import ee.pri.rl.algorithmics.ted.util.TreeUtil;

public class NHXReaderTest extends TestCase {
	
	public void testParse() throws IOException, ParseException {
		Node node = NHXReader.readTree(new File("data/ted/test.txt"));
		System.out.println(node);
		
		for (LeafNode leaf : TreeUtil.findLeafs(node)) {
			System.out.println(leaf);
		}
	}
}
