package ee.pri.rl.algorithmics.dp;

import ee.pri.rl.algorithmics.graph.matrix.Matrix;

/**
 * <pre>
 * Max expression: (2 + 1) * 3 * (2 + 1) * (1 + 2)
 * </pre>
 */
public class Solution1 {

	public static void main(String[] args) {
		Matrix<Expression> m = new Matrix<Expression>(new Expression[][] {
			new Expression[] {new Expression(2), null, null, null, null, null, null},
			new Expression[] {null, new Expression(1), null, null, null, null, null},
			new Expression[] {null, null, new Expression(3), null, null, null, null},
			new Expression[] {null, null, null, new Expression(2), null, null, null},
			new Expression[] {null, null, null, null, new Expression(1), null, null},
			new Expression[] {null, null, null, null, null, new Expression(1), null},
			new Expression[] {null, null, null, null, null, null, new Expression(2)}
		});
		
		System.out.println("Max expression: " + maximize(m, 0, m.getCols() - 1));
	}
	
	private static Expression maximize(Matrix<Expression> m, int start, int end) {
		if (m.getAt(start, end) != null) {
			return m.getAt(start, end);
		}
		
		int max = Integer.MIN_VALUE;
		Expression maxExpression = null;
		
		for (int i = start; i < end; i++) {
			Expression left = maximize(m, start, i);
			Expression right = maximize(m, i + 1, end);
			int multValue = left.value * right.value;
			int addValue = left.value + right.value;
			
			if (multValue > addValue) {
				if (multValue > max) {
					max = multValue;
					maxExpression = new Mult(max, left, right);
				}
			} else {
				if (addValue > max) {
					max = addValue;
					maxExpression = new Add(max, left, right);
				}
			}
		}
		
		assert maxExpression != null;
		
		m.setAt(start, end, maxExpression);
		
		return maxExpression;
	}
	
	private static class Expression {
		public final int value;

		public Expression(int value) {
			this.value = value;
		}

		@Override
		public String toString() {
			return String.valueOf(value);
		}
		
	};
	
	private static class Mult extends Expression {
		public final Expression left;
		public final Expression right;
		
		public Mult(int value, Expression left, Expression right) {
			super(value);
			this.left = left;
			this.right = right;
		}

		@Override
		public String toString() {
			String leftString = left.toString();
			if (left instanceof Add) {
				leftString = "(" + leftString + ")";
			}
			String rightString = right.toString();
			if (right instanceof Add) {
				rightString = "(" + rightString + ")";
			}
			return leftString + " * " + rightString;
		}
		
	}
	
	private static class Add extends Expression {
		public final Expression left;
		public final Expression right;
		
		public Add(int value, Expression left, Expression right) {
			super(value);
			this.left = left;
			this.right = right;
		}

		@Override
		public String toString() {
			return left + " + " + right;
		}
		
	}

}
