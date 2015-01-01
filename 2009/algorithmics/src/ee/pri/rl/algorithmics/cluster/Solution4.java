package ee.pri.rl.algorithmics.cluster;

import java.util.List;

import ee.pri.rl.algorithmics.cluster.KMeansClustering.Cluster;

/**
 * Output:
 * 
 * <pre>
 * 0,1,2 | 3,4,5
 * [(A, [D, F, G, A, I]), (B, [E, B]), (C, [C, H])]
 * [((3.80, 3.60), [F, G, A, I]), ((2.50, 6.50), [E, B]), ((1.50, 2.50), [D, C, H])]
 * [((4.25, 3.50), [F, G, A, I]), ((2.50, 6.50), [E, B]), ((1.67, 3.00), [D, C, H])]
 * -----
 * [(D, [D, A, C, H]), (E, [E, B]), (F, [F, G, I])]
 * [((2.00, 3.25), [D, A, C, H]), ((2.50, 6.50), [E, B]), ((4.67, 3.33), [F, G, I])]
 * </pre>
 */
public class Solution4 {

	public static void main(String[] args) {
		List<Point> points = HomeworkData.getDataPoints();
		
		boolean differenceFound = false;
		int i1 = 0, i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0;
		outer: for (i1 = 0; i1 < points.size(); i1++) {
			for (i2 = i1 + 1; i2 < points.size(); i2++) {
				for (i3 = i2 + 1; i3 < points.size(); i3++) {
					for (i4 = i3 + 1; i4 < points.size(); i4++) {
						for (i5 = i4 + 1; i5 < points.size(); i5++) {
							for (i6 = i5 + 1; i6 < points.size(); i6++) {
								Cluster[] clustering1 = KMeansClustering.doClustering(
									points,
									false,
									points.get(i1),
									points.get(i2),
									points.get(i3));
								Cluster[] clustering2 = KMeansClustering.doClustering(
										points,
										false,
										points.get(i4),
										points.get(i5),
										points.get(i6));
								equal: for (int i = 0; i < clustering1.length; i++) {
									boolean found = false;
									for (int j = 0; j < clustering2.length; j++) {
										if (clustering1[i].equals(clustering2[j])) {
											found = true;
										}
									}
									if (!found) {
										break equal;
									}
								}
								
								System.out.println(i1 + "," + i2 + "," + i3 + " | " + i4 + "," + i5 + "," + i6);
								differenceFound = true;
								break outer;
							}
						}
					}
				}
			}
		}
		
		if (differenceFound) {
			KMeansClustering.doClustering(
					points,
					true,
					points.get(i1),
					points.get(i2),
					points.get(i3));
			
			System.out.println("-----");
			
			KMeansClustering.doClustering(
					points,
					true,
					points.get(i4),
					points.get(i5),
					points.get(i6));
		}
	}

}
