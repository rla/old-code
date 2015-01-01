package ee.pri.rl.treedistance.test;

import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.TreeContext;
import junit.framework.TestCase;

public class TreeTestCase extends TestCase {
	
	protected static TreeContext makeSimpleTreeA() {
		Leaf leafA = new Leaf("A");
		Leaf leafB = new Leaf("B");
		Leaf leafC = new Leaf("C");
		Branch branch = new Branch(leafB, leafC);
		leafB.setParent(branch);
		leafC.setParent(branch);
		
		Branch root = new Branch(leafA, branch);
		branch.setParent(root);
		leafA.setParent(root);
		
		TreeContext tree = new TreeContext(root);
		
		return tree;
	}
	
	protected static TreeContext makeSimpleTreeB() {
		Leaf leafA = new Leaf("A");
		Leaf leafB = new Leaf("B");
		Leaf leafC = new Leaf("C");
		Branch branch = new Branch(leafA, leafC);
		leafA.setParent(branch);
		leafC.setParent(branch);
		
		Branch root = new Branch(leafB, branch);
		branch.setParent(root);
		leafB.setParent(root);
		
		TreeContext tree = new TreeContext(root);
		
		return tree;
	}
}
