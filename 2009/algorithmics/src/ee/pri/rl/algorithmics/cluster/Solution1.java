package ee.pri.rl.algorithmics.cluster;

import java.util.List;

/**
 * Output:
 * 
 * <pre>
 * Merge [D] and [A] (1.00)
 * Merge [H] and [C] (1.41)
 * Merge [C, H] and [D, A] (1.41)
 * Merge [G] and [F] (1.41)
 * Merge [E] and [B] (1.41)
 * Merge [I] and [F, G] (2.00)
 * Merge [F, G, I] and [D, A, C, H] (2.00)
 * Merge [D, F, G, A, C, H, I] and [E, B] (2.00)
 * End
 * </pre>
 */
public class Solution1 {

	public static void main(String[] args) {		
		List<Cluster<Point>> initialClusters = HomeworkData.getInitialClusters();
		HierarchicalClustering.doClustering(initialClusters, new SingleLinkagePointDistance());
	}

}
