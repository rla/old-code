package ee.pri.rl.algorithmics.graph.matrix.op;

public class DoubleMultOperation implements Operation<Double> {

	@Override
	public Double apply(Double a, Double b) {
		return a * b;
	}

}
