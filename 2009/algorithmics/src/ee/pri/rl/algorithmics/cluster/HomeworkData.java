package ee.pri.rl.algorithmics.cluster;

import java.util.LinkedList;
import java.util.List;

public class HomeworkData {
	
	public static List<Cluster<Point>> getInitialClusters() {
		List<Cluster<Point>> clusters = new LinkedList<Cluster<Point>>();
		
		for (Point p : getDataPoints()) {
			clusters.add(new Cluster<Point>(p));
		}
		
		return clusters;
	}
	
	public static List<Point> getDataPoints() {		
		List<Point> points = new LinkedList<Point>();
		
		points.add(new Point("A", 3.0, 4.0));
		points.add(new Point("B", 2.0, 7.0));
		points.add(new Point("C", 1.0, 3.0));
		points.add(new Point("D", 2.0, 4.0));
		points.add(new Point("E", 3.0, 6.0));
		points.add(new Point("F", 5.0, 3.0));
		points.add(new Point("G", 4.0, 2.0));
		points.add(new Point("H", 2.0, 2.0));
		points.add(new Point("I", 5.0, 5.0));
		
		return points;
	}

}
