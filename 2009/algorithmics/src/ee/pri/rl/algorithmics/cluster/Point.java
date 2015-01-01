package ee.pri.rl.algorithmics.cluster;

import java.text.DecimalFormat;

public class Point {
	private String name;
	private Double x;
	private Double y;
	
	public Point(String name, Double x, Double y) {
		this.name = name;
		this.x = x;
		this.y = y;
	}
	
	public Point(Double x, Double y) {
		this(null, x, y);
	}
	
	public String getName() {
		return name;
	}

	public Double getX() {
		return x;
	}

	public Double getY() {
		return y;
	}

	public double distance(Point other) {
		double xDiff = Math.abs(x - other.getX());
		double yDiff = Math.abs(y - other.getY());
		
		return Math.sqrt(xDiff * xDiff + yDiff * yDiff);
	}

	@Override
	public String toString() {
		DecimalFormat format = new DecimalFormat("0.00");
		return name == null ? "(" + format.format(x) + ", " + format.format(y) + ")" : name;
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof Point && ((Point) obj).getName().equals(name);
	}

	@Override
	public int hashCode() {
		return name.hashCode();
	}
	
}
