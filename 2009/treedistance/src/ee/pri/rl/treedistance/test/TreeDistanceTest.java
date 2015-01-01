package ee.pri.rl.treedistance.test;

import java.io.File;
import java.io.IOException;

import ee.pri.rl.treedistance.TreeDistance;
import ee.pri.rl.treedistance.TreeDistanceException;
import ee.pri.rl.treedistance.io.NHXParserException;
import ee.pri.rl.treedistance.io.NHXReader;
import ee.pri.rl.treedistance.tree.TreeContext;
import ee.pri.rl.treedistance.tree.modifications.ModificationChainExplainer;

public class TreeDistanceTest extends TreeTestCase {
	
	public void test() throws TreeDistanceException {
		TreeContext A = makeSimpleTreeA();
		TreeContext B = makeSimpleTreeB();
		
		ModificationChainExplainer.explain(TreeDistance.findModifications(A, B, 0.0, 1.0, 5000, false, 0));
	}
	
	public void testWithIO() throws IOException, NHXParserException, TreeDistanceException {
		TreeContext A = new TreeContext(NHXReader.readTree(new File("data/test/A.txt")));
		TreeContext B = new TreeContext(NHXReader.readTree(new File("data/test/B.txt")));
		
		ModificationChainExplainer.explain(TreeDistance.findModifications(A, B, 0.0, 1.0, 5000, false, 0));
	}
	
	public void testWithIOComplex() throws IOException, NHXParserException, TreeDistanceException {
		TreeContext A = new TreeContext(NHXReader.readTree(new File("data/test/complex/A.txt")));
		TreeContext B = new TreeContext(NHXReader.readTree(new File("data/test/complex/B.txt")));
		
		ModificationChainExplainer.explain(TreeDistance.findModifications(A, B, -1.0, 1.0, 5000, false, 0));
	}
}
