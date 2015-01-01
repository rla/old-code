package ee.pri.rl.algorithmics.graph.matrix;


public class Solution2 {

	public static void main(String[] args) {
		Matrix<Boolean> A = new Matrix<Boolean>(new Boolean[][] {
			new Boolean[] {false, true , false, false, false},
			new Boolean[] {false, false, false, true , false},
			new Boolean[] {false, true , false, false, true },
			new Boolean[] {false, false, false, false, true },
			new Boolean[] {true , false, false, false, false}
		});
		
		System.out.println("Transitiivne sulund Warshalli algoritmiga:");
		System.out.println(warshall(A));
	}
	
	private static Matrix<Boolean> warshall(Matrix<Boolean> m) {
		assert m.getRows() == m.getCols();
		
		int n = m.getRows();
		
		for (int i = 0; i < n; i++) {
			m.setAt(i, i, true); // self-loop
		}
		
		Matrix<Boolean> A = new Matrix<Boolean>(n, n, false);
		
		for (int r = 0; r < n; r++) {
			for (int c = 0; c < n; c++) {
				A.setAt(r, c, m.getAt(r, c));
			}
		}
		
		// A on m sisuga
		
		for (int i = 0; i < n; i++) {
			for (int s = 0; s < n; s++) {
				for (int t = 0; t < n; t++) {
					if (A.getAt(s, i) && A.getAt(i, t)) {
						A.setAt(s, t, true);
					}
				}
			}
		}
		
		return A;
	}

}
