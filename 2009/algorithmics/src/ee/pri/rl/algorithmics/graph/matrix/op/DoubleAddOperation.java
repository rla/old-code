package ee.pri.rl.algorithmics.graph.matrix.op;

public class DoubleAddOperation implements Operation<Double> {

	@Override
	public Double apply(Double a, Double b) {
		return a + b;
	}

}
