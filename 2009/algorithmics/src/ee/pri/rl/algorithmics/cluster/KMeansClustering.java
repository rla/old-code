package ee.pri.rl.algorithmics.cluster;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class KMeansClustering {
	
	public static Cluster[] doClustering(List<Point> points, boolean debug, Point... starts) {
		boolean change = true;
		
		Cluster[] clusters = new Cluster[starts.length];
		
		int i = 0;
		for (Point p : starts) {
			clusters[i++] = new Cluster(p);
		}
		
		while (change) {
			Point[] means = new Point[clusters.length];
			
			for (int j = 0; j < clusters.length; j++) {
				means[j] = clusters[j].getCalculatedMean();
				clusters[j].setMean(means[j]);
				clusters[j].clear();
			}
			
			for (Point point : points) {
				clusters[closestClusterIndex(means, point)].addPoint(point);
			}
			
			if (debug) {
				System.out.println(Arrays.toString(clusters));
			}
			
			change = false;
			for (Cluster cluster : clusters) {
				change |= cluster.hasChange();
			}
		}
		
		return clusters;
	}
	
	private static int closestClusterIndex(Point[] means, Point point) {
		double closestClusterDistance = Double.MAX_VALUE;
		int closestClusterIndex = -1;
		
		for (int i = 0; i < means.length; i++) {
			double distance = point.distance(means[i]);
			if (distance <= closestClusterDistance) {
				closestClusterDistance = distance;
				closestClusterIndex = i;
			}
		}
		
		return closestClusterIndex;
	}
	
	public static class Cluster {
		private Point mean;
		private Set<Point> oldPoints;
		private Set<Point> points;
		
		public Cluster(Point mean) {
			this.mean = mean;
			this.points = new HashSet<Point>();
		}

		public Point getMean() {
			return mean;
		}
		
		public void setMean(Point mean) {
			this.mean = mean;
		}
		
		public void clear() {
			oldPoints = new HashSet<Point>(points);
			points.clear();
		}
		
		public boolean hasChange() {
			return !points.equals(oldPoints);
		}
		
		public void addPoint(Point point) {
			points.add(point);
		}

		public Set<Point> getPoints() {
			return points;
		}
		
		public Point getCalculatedMean() {
			if (points.isEmpty()) {
				return mean;
			}
			
			double sumX = 0;
			double sumY = 0;
			
			for (Point point : points) {
				sumX += point.getX();
				sumY += point.getY();
			}
			
			double size = points.size();
			
			return new Point(sumX / size, sumY / size);
		}

		@Override
		public String toString() {
			return "(" + mean + ", " + points.toString() + ")";
		}
		
	}
}
