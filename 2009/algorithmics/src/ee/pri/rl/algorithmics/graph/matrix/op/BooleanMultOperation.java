package ee.pri.rl.algorithmics.graph.matrix.op;

public class BooleanMultOperation implements Operation<Boolean> {

	@Override
	public Boolean apply(Boolean a, Boolean b) {
		return a && b;
	}

}
