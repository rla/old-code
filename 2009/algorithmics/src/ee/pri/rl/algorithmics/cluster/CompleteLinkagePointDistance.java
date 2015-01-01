package ee.pri.rl.algorithmics.cluster;

public class CompleteLinkagePointDistance implements Distance<Point> {

	@Override
	public double measure(Cluster<Point> a, Cluster<Point> b) {
		double maxDistance = Double.MIN_VALUE;
		
		for (Point pA : a.getElements()) {
			for (Point pB : b.getElements()) {
				double distance = pA.distance(pB);
				if (distance >= maxDistance) {
					maxDistance = distance;
				}
			}
		}
		
		return maxDistance;
	}

}
