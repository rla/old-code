package ee.pri.rl.algorithmics.graph.matrix;

import ee.pri.rl.algorithmics.graph.matrix.op.BooleanAddOperation;
import ee.pri.rl.algorithmics.graph.matrix.op.BooleanMultOperation;
import ee.pri.rl.algorithmics.graph.matrix.op.Operation;

/**
 * <pre>
 * Maatriks A:
 * false	true	false	false	false
 * false	false	false	true	false
 * false	true	false	false	true
 * false	false	false	false	true
 * true	false	false	false	false
 * 
 * Maatriks AA (kahe sammuga saadavad tipud):
 * false	false	false	true	false
 * false	false	false	false	true
 * true	false	false	true	false
 * true	false	false	false	false
 * false	true	false	false	false
 * 
 * Maatriks AAA (kolme sammuga saadavad tipud):
 * false	false	false	false	true
 * true	false	false	false	false
 * false	true	false	false	true
 * false	true	false	false	false
 * false	false	false	true	false
 * 
 * Maatriks A+ (transitiivne sulund):
 * true	true	false	true	true
 * true	true	false	true	true
 * true	true	true	true	true
 * true	true	false	true	true
 * true	true	false	true	true
 * </pre>
 */
public class Solution1 {
	private static final Operation<Boolean> OR = new BooleanAddOperation();
	private static final Operation<Boolean> AND = new BooleanMultOperation();

	public static void main(String[] args) {
		Matrix<Boolean> A = new Matrix<Boolean>(new Boolean[][] {
			new Boolean[] {false, true , false, false, false},
			new Boolean[] {false, false, false, true , false},
			new Boolean[] {false, true , false, false, true },
			new Boolean[] {false, false, false, false, true },
			new Boolean[] {true , false, false, false, false}
		});
		
		Matrix<Boolean> twoHopsMatrix = A.multiply(OR, AND, A, false);
		Matrix<Boolean> threeHopsMatrix = twoHopsMatrix.multiply(OR, AND, A, false);
		
		System.out.println("Maatriks A:");
		System.out.println(A);
		System.out.println();
		System.out.println("Maatriks AA (kahe sammuga saadavad tipud):");
		System.out.println(twoHopsMatrix);
		System.out.println();
		System.out.println("Maatriks AAA (kolme sammuga saadavad tipud):");
		System.out.println(threeHopsMatrix);
		System.out.println();
		System.out.println("Maatriks A+ (transitiivne sulund):");
		System.out.println(transitiveClosure(A));
	}
	
	private static Matrix<Boolean> transitiveClosure(Matrix<Boolean> m) {
		for (int i = 0; i < m.getRows(); i++) {
			m.setAt(i, i, true); // self-loop
		}
		return matrixExponent(m, m.getRows());
	}

	private static Matrix<Boolean> matrixExponent(Matrix<Boolean> m, int e) {
		if (e <= 1) {
			return m;
		} else if (e % 2 == 0) {
			Matrix<Boolean> factor = matrixExponent(m, e / 2);
			return factor.multiply(OR, AND, factor, false);
		} else {
			return m.multiply(OR, AND, matrixExponent(m, e - 1), false);
		}
	}

}
