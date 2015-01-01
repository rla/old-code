package ee.pri.rl.treedistance;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Random;
import java.util.Set;

import ee.pri.rl.treedistance.tree.Branch;
import ee.pri.rl.treedistance.tree.Leaf;
import ee.pri.rl.treedistance.tree.Node;
import ee.pri.rl.treedistance.tree.TreeContext;
import ee.pri.rl.treedistance.tree.modifications.TreeIdentityModification;
import ee.pri.rl.treedistance.tree.modifications.TreeLeafSwapModification;
import ee.pri.rl.treedistance.tree.modifications.TreeModification;
import ee.pri.rl.treedistance.tree.modifications.TreeUnBranchModification;

public class TreeDistance {
	
	public static TreeModification findModifications(
			TreeContext A,
			TreeContext B,
			double unBranchWeigh,
			double swapWeight,
			int maxSteps,
			boolean randomSwaps,
			double numRandomSwaps) throws TreeDistanceException {
		
		PriorityQueue<TreeModification> queue = new PriorityQueue<TreeModification>();
		
		queue.add(new TreeIdentityModification());
		
		LabelGenerator labelGenerator = new LabelGenerator();
		
		int bound = maxSteps;
		while (!queue.isEmpty() && bound > 0) {
			TreeModification modificationChain = queue.poll();
			
			List<Leaf> leaves = findLeafs(A.getRoot(), modificationChain);
			
			if (leaves.size() == 1) {
				return modificationChain;
			}
			
			List<TreeUnBranchModification> unBranchModifications = findUnBranchModifications(
				leaves,
				B,
				labelGenerator
			);
			
			for (TreeUnBranchModification m : unBranchModifications) {
				m.setValue(modificationChain.getValue() + unBranchWeigh);
				m.setPrevious(modificationChain);
				queue.add(m);
			}
			
			if (unBranchModifications.isEmpty()) {
				List<TreeLeafSwapModification> swapModifications = null;
				if (randomSwaps) {
					swapModifications = findLeafRandomSwapModifications(
							leaves,
							modificationChain,
							numRandomSwaps
						);
				} else {
					swapModifications = findLeafSwapModifications(
						leaves,
						modificationChain
					);
				}
					
				for (TreeLeafSwapModification m : swapModifications) {
					m.setValue(modificationChain.getValue() + swapWeight);
					m.setPrevious(modificationChain);
					queue.add(m);
				}
			}
			
			bound--;
		}
		
		if (bound == 0) {
			throw new TreeDistanceException("Out of max steps (" + maxSteps + ")");
		}
		
		return null;
	}
	
	/**
	 * Finds all tree modifications where two leaves are swapped.
	 * 
	 * @param leaves Leaves of the tree.
	 * @return List of suitable modifications.
	 */
	public static List<TreeLeafSwapModification> findLeafSwapModifications(
			List<Leaf> leaves,
			TreeModification m) {
		
		List<TreeLeafSwapModification> modifications = new LinkedList<TreeLeafSwapModification>();
		
		for (int i = 0; i < leaves.size(); i++) {
			for (int j = i + 1; j < leaves.size(); j++) {
				Leaf a = leaves.get(i);
				Leaf b = leaves.get(j);
				if (a.getParent() != b.getParent()) {
					modifications.add(swapModification(a, b));
				}
			}
		}
		
		return modifications;
	}
	
	public static List<TreeLeafSwapModification> findLeafRandomSwapModifications(
			List<Leaf> leaves,
			TreeModification m,
			double numRandomSwaps) {
		
		List<TreeLeafSwapModification> modifications = new LinkedList<TreeLeafSwapModification>();
		
		Random random = new Random();
		int count = (int) (numRandomSwaps * leaves.size());
		if (count == 0) {
			count = 1;
		}
		while (count > 0) {
			Leaf a = leaves.get(random.nextInt(leaves.size()));
			Leaf b = leaves.get(random.nextInt(leaves.size()));
			if (a.getParent() != b.getParent()) {
				modifications.add(swapModification(a, b));
				count--;
			}
		}
		
		return modifications;
	}
	
	
	public static TreeLeafSwapModification swapModification(Leaf a, Leaf b) {
		Branch branch1 = a.getParent();
		Branch branch2 = b.getParent();
		
		Branch branch1New = null;
		Branch branch2New = null;
		
		if (a.isLeft()) {
			if (b.isLeft()) {
				branch1New = new Branch(b, branch1.getRight());
				branch2New = new Branch(a, branch2.getRight());
			} else {
				branch1New = new Branch(b, branch1.getRight());
				branch2New = new Branch(branch2.getLeft(), a);
			}
		} else {
			if (b.isLeft()) {
				branch1New = new Branch(branch1.getLeft(), b);
				branch2New = new Branch(a, branch2.getRight());
			} else {
				branch1New = new Branch(branch1.getLeft(), b);
				branch2New = new Branch(branch2.getLeft(), a);
			}
		}
		
		return new TreeLeafSwapModification(branch1, branch1New, branch2, branch2New, a, b);
	}
	
	/**
	 * Finds all tree modifications where branch with two leafs in both trees
	 * can be considered to be new leafs.
	 * 
	 * @param leafsA Leafs of tree A (in the context of previous modifications).
	 * @param contextB Context of tree B.
	 * @param labelGenerator Helper for generating new leafs with unique labels.
	 * @return List of suitable modifications.
	 */
	public static List<TreeUnBranchModification> findUnBranchModifications(
			List<Leaf> leafsA,
			TreeContext contextB,
			LabelGenerator labelGenerator) {
		
		List<TreeUnBranchModification> modifications = new LinkedList<TreeUnBranchModification>();
		
		Set<Leaf> checked = new HashSet<Leaf>();
		for (Leaf a1 : leafsA) {
			if (checked.contains(a1)) {
				continue;
			}
			Node a1b = a1.getBrother();
			if (a1b != null && a1b.isLeaf()) {
				Leaf a2 = (Leaf) a1b;
				checked.add(a1);
				checked.add(a2);
				Leaf b1 = contextB.getLeaf(a1.getLabel());
				Leaf b2 = contextB.getLeaf(a2.getLabel());
				if (b1.getParent() == b2.getParent()) {
					Branch branchA = a1.getParent();
					Branch branchB = b1.getParent();
					
					String label = labelGenerator.getLabel();
					
					Leaf leafA = new Leaf(label);
					Leaf leafB = new Leaf(label);
					
					contextB.putLeaf(leafB);
					leafB.setParent(branchB.getParent());
					
					modifications.add(new TreeUnBranchModification(branchA, branchB, leafA, leafB, a1, a2));
				}
			}
		}
		
		return modifications;
	}
	
	public static List<Leaf> findLeafs(Node tree, TreeModification modificationChain) {
		List<Leaf> leafs = new ArrayList<Leaf>();
		findLeafs(null, tree, leafs, modificationChain);
		
		return leafs;
	}

	private static Node findLeafs(Branch parent, Node original, List<Leaf> leafs, TreeModification modificationChain) {
		Node tree = modificationChain.getModificationResult(original);
		if (tree instanceof Leaf) {
			Leaf leaf = (Leaf) tree;
			leaf.setParent(parent);
			leafs.add(leaf);
			return leaf;
		} else {
			Branch branch = (Branch) tree;
			Node left = findLeafs(branch, branch.getLeft(), leafs, modificationChain);
			Node right = findLeafs(branch, branch.getRight(), leafs, modificationChain);
			
			if (left.isLeaf()) {
				((Leaf) left).setBrother(right);
			}
			
			if (right.isLeaf()) {
				((Leaf) right).setBrother(left);
			}
			
			branch.setParent(parent);
			
			return branch;
		}
	}
	
	public static class LabelGenerator {
		private int id;
		
		public LabelGenerator() {
			this.id = 0;
		}
		
		public String getLabel() {
			return "L" + id++;
		}
	}
}
