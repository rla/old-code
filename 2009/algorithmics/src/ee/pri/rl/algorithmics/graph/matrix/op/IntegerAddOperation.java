package ee.pri.rl.algorithmics.graph.matrix.op;

public class IntegerAddOperation implements Operation<Integer> {

	@Override
	public Integer apply(Integer a, Integer b) {
		return a + b;
	}

}
