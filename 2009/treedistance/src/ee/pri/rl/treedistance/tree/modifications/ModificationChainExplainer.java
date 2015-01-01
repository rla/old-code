package ee.pri.rl.treedistance.tree.modifications;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;


/**
 * Helper class to dump out modifications chain.
 */
public class ModificationChainExplainer {
	
	public static void explain(TreeModification m) {
		List<TreeModification> list = new LinkedList<TreeModification>();
		
		int swaps = 0;
		while (m != null) {
			list.add(m);
			if (m instanceof TreeLeafSwapModification) {
				swaps++;
			}
			m = m.getPrevious();
		}
		
		Collections.reverse(list);
		for (TreeModification singleModification : list) {
			explainModification(singleModification);
		}
		
		System.out.println("Swaps: " + swaps);
	}

	private static void explainModification(TreeModification m) {
		if (m instanceof TreeLeafSwapModification) {
			TreeLeafSwapModification swap = (TreeLeafSwapModification) m;
			System.out.println("Swap " + swap.getFirst() + " and " + swap.getSecond() + " in first tree");
		} else if (m instanceof TreeUnBranchModification) {
			TreeUnBranchModification merge = (TreeUnBranchModification) m;
			System.out.println("Merge " + merge.getFirst() + " and " + merge.getSecond() + " in both trees into " + merge.getLeafA());
		}
	}
}
