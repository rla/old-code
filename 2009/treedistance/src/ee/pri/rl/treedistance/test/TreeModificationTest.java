package ee.pri.rl.treedistance.test;

import java.util.List;

import ee.pri.rl.treedistance.TreeDistance;
import ee.pri.rl.treedistance.TreeDistance.LabelGenerator;
import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.TreeContext;
import ee.pri.rl.treedistance.tree.modifications.TreeIdentityModification;
import ee.pri.rl.treedistance.tree.modifications.TreeLeafSwapModification;
import ee.pri.rl.treedistance.tree.modifications.TreeUnBranchModification;
import ee.pri.rl.treedistance.util.TreeUtil;

public class TreeModificationTest extends TreeTestCase {
	
	public void testSwapModifications() {
		TreeContext treeA = makeSimpleTreeA();
		List<Leaf> leaves = TreeUtil.findLeafs(treeA.getRoot());
		
		List<TreeLeafSwapModification> modifications = TreeDistance.findLeafSwapModifications(leaves, new TreeIdentityModification());
		
		// Swap A with B or A with C
		assertEquals(2, modifications.size());
	}
	
	public void testNoUnBranchModifications() {
		TreeContext treeA = makeSimpleTreeA();
		TreeContext treeB = makeSimpleTreeB();
		
		List<Leaf> leafsA = TreeUtil.findLeafs(treeA.getRoot());
		LabelGenerator labelGenerator = new LabelGenerator();
		
		List<TreeUnBranchModification> modifications = TreeDistance.findUnBranchModifications(leafsA, treeB, labelGenerator);
		
		assertTrue(modifications.isEmpty());
	}
	
	public void testOneUnBranchModification() {
		TreeContext treeA = makeSimpleTreeA();
		TreeContext treeB = makeSimpleTreeA();
		
		List<Leaf> leafsA = TreeDistance.findLeafs(treeA.getRoot(), new TreeIdentityModification());
		LabelGenerator labelGenerator = new LabelGenerator();
		
		List<TreeUnBranchModification> modifications = TreeDistance.findUnBranchModifications(leafsA, treeB, labelGenerator);
		
		assertEquals(1, modifications.size());
		
		TreeUnBranchModification m = modifications.get(0);
		
		assertEquals(m.getLeafA(), m.getLeafB());
		
		Branch branchA = m.getBranchA();
		
		assertEquals(treeA.getLeaf("B"), branchA.getLeft());
		assertEquals(treeA.getLeaf("C"), branchA.getRight());
	}
	
	public void testOneUnBranchModificationAfterSwap() {
		TreeContext treeA = makeSimpleTreeA();
		TreeContext treeB = makeSimpleTreeB();
		
		List<Leaf> leafsA = TreeUtil.findLeafs(treeA.getRoot());
		LabelGenerator labelGenerator = new LabelGenerator();
		
		// Swap A and B
		// A and C can then be unbranched
		Leaf a = treeA.getLeaf("A");
		Leaf b = treeA.getLeaf("B");
		
		TreeLeafSwapModification swapModification = TreeDistance.swapModification(a, b);
		leafsA = TreeDistance.findLeafs(treeA.getRoot(), swapModification);
		
		List<TreeUnBranchModification> modifications = TreeDistance.findUnBranchModifications(leafsA, treeB, labelGenerator);
		
		assertEquals(1, modifications.size());
		
		TreeUnBranchModification m = modifications.get(0);
		
		assertEquals(m.getLeafA(), m.getLeafB());
		
		Branch branchA = m.getBranchA();
		
		assertEquals(treeA.getLeaf("A"), branchA.getLeft());
		assertEquals(treeA.getLeaf("C"), branchA.getRight());
	}
	
	public void testLeafsAfterUnBranchModification() {
		TreeContext treeA = makeSimpleTreeA();
		TreeContext treeB = makeSimpleTreeA();
		
		List<Leaf> leafsA = TreeDistance.findLeafs(treeA.getRoot(), new TreeIdentityModification());
		LabelGenerator labelGenerator = new LabelGenerator();
		
		List<TreeUnBranchModification> modifications = TreeDistance.findUnBranchModifications(leafsA, treeB, labelGenerator);
		
		assertEquals(1, modifications.size());
		TreeUnBranchModification m = modifications.get(0);
		
		// B-C taken as single leaf in both trees
		List<Leaf> leaves = TreeDistance.findLeafs(treeA.getRoot(), m);	
		assertEquals(2, leaves.size());
		
		// A is untouched
		assertTrue(leaves.contains(treeA.getLeaf("A")));
	}

}
