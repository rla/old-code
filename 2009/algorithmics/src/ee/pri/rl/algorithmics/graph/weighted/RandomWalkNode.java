package ee.pri.rl.algorithmics.graph.weighted;

public class RandomWalkNode {
	private int visitedCount;
	private Integer name;
	
	public RandomWalkNode(Integer name) {
		this.name = name;
		this.visitedCount = 0;
	}

	@Override
	public int hashCode() {
		return name.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		return obj instanceof RandomWalkNode && ((RandomWalkNode) obj).getName().equals(name);
	}

	public int getVisitedCount() {
		return visitedCount;
	}

	public Integer getName() {
		return name;
	}
	
	public void incVisitedCount() {
		visitedCount++;
	}
	
	public void reset() {
		visitedCount = 0;
	}

	@Override
	public String toString() {
		return name + "=" + visitedCount;
	}
	
}
