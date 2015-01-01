package ee.pri.rl.algorithmics.cluster;

import java.util.List;

/**
 * Output:
 * 
 * <pre>
 * Merge [D] and [A] (1.00)
 * Merge [H] and [C] (1.41)
 * Merge [G] and [F] (1.41)
 * Merge [E] and [B] (1.41)
 * Merge [C, H] and [D, A] (2.24)
 * Merge [I] and [F, G] (3.16)
 * Merge [F, G, I] and [D, A, C, H] (4.47)
 * Merge [D, F, G, A, C, H, I] and [E, B] (5.39)
 * End
 * </pre>
 */
public class Solution2 {

	public static void main(String[] args) {
		List<Cluster<Point>> initialClusters = HomeworkData.getInitialClusters();
		HierarchicalClustering.doClustering(initialClusters, new CompleteLinkagePointDistance());
	}

}
