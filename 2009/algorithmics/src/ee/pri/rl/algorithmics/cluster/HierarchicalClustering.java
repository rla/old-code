package ee.pri.rl.algorithmics.cluster;

import java.text.DecimalFormat;
import java.util.List;

public class HierarchicalClustering {
	
	public static <T> void doClustering(List<Cluster<T>> clusters, Distance<T> distance) {
		if (clusters.size() == 1) {
			System.out.println("End");
			return;
		}
		double minDistance = Double.MAX_VALUE;
		
		Cluster<T> first = null;
		Cluster<T> second = null;
		
		for (Cluster<T> a : clusters) {
			for (Cluster<T> b : clusters) {
				if (a.equals(b)) {
					continue;
				}
				double currentDistance = distance.measure(a, b);
				if (currentDistance <= minDistance) {
					minDistance = currentDistance;
					first = a;
					second = b;
				}
			}
		}
		
		System.out.println("Merge " + first + " and " + second
			+ " (" + new DecimalFormat("0.00").format(minDistance) + ")");
		
		clusters.remove(second);
		first.merge(second);
		
		doClustering(clusters, distance);
	}
}
