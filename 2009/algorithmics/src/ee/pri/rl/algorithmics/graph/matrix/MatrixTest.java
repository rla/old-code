package ee.pri.rl.algorithmics.graph.matrix;

import junit.framework.TestCase;
import ee.pri.rl.algorithmics.graph.matrix.op.IntegerAddOperation;
import ee.pri.rl.algorithmics.graph.matrix.op.IntegerMultOperation;

public class MatrixTest extends TestCase {
	
	public void testMultiplication() {
		Matrix<Integer> B = new Matrix<Integer>(new Integer[][] {
			new Integer[] {1, 0, 2},
			new Integer[] {-1, 3, 1}
		});
		
		Matrix<Integer> A = new Matrix<Integer>(new Integer[][] {
			new Integer[] {3, 1},
			new Integer[] {2, 1},
			new Integer[] {1, 0}
		});
		
		Matrix<Integer> solution = new Matrix<Integer>(new Integer[][] {
			new Integer[] {5, 1},
			new Integer[] {4, 2}
		});
		
		Matrix<Integer> BA = B.multiply(new IntegerAddOperation(), new IntegerMultOperation(), A, 0);
		
		assertEquals(solution, BA);
	}
}
