package ee.pri.rl.algorithmics.cluster;

import java.util.List;

/**
 * Output:
 * 
 * <pre>
 * [(A, [D, F, G, A, I]), (B, [E, B]), (C, [C, H])]
 * [((3.80, 3.60), [F, G, A, I]), ((2.50, 6.50), [E, B]), ((1.50, 2.50), [D, C, H])]
 * [((4.25, 3.50), [F, G, A, I]), ((2.50, 6.50), [E, B]), ((1.67, 3.00), [D, C, H])]
 * </pre>
 */
public class Solution3 {

	public static void main(String[] args) {
		List<Point> points = HomeworkData.getDataPoints();
		KMeansClustering.doClustering(points, true, points.get(0), points.get(1), points.get(2));
	}

}
