package ee.pri.rl.algorithmics.cluster;

public class SingleLinkagePointDistance implements Distance<Point> {

	@Override
	public double measure(Cluster<Point> a, Cluster<Point> b) {
		double minDistance = Double.MAX_VALUE;
		
		for (Point pA : a.getElements()) {
			for (Point pB : b.getElements()) {
				double distance = pA.distance(pB);
				if (distance <= minDistance) {
					minDistance = distance;
				}
			}
		}
		
		return minDistance;
	}

}
