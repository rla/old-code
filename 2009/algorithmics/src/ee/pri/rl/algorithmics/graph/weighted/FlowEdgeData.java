package ee.pri.rl.algorithmics.graph.weighted;

public class FlowEdgeData {
	private double capacity;
	private double flow;
	
	public FlowEdgeData(double capacity) {
		this.capacity = capacity;
		this.flow = 0;
	}

	public double getCapacity() {
		return capacity;
	}

	public void setCapacity(double capacity) {
		this.capacity = capacity;
	}

	public double getFlow() {
		return flow;
	}

	public void setFlow(double flow) {
		this.flow = flow;
	}
	
	public double getRemainingCapacity() {
		return capacity - flow;
	}

	@Override
	public String toString() {
		return capacity + " " + flow;
	}
	
}
