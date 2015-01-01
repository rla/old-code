package ee.pri.rl.algorithmics.graph.matrix;

import ee.pri.rl.algorithmics.graph.matrix.op.Operation;

public class Matrix<T> {
	private final int rows;
	private final int cols;
	private final T[] data;
	
	@SuppressWarnings("unchecked")
	public Matrix(int rows, int cols, T initialValue) {
		this.rows = rows;
		this.cols = cols;
		this.data = (T[]) new Object[rows * cols];
		
		for (int i = 0; i < this.data.length; i++) {
			this.data[i] = initialValue;
		}
	}
	
	@SuppressWarnings("unchecked")
	public Matrix(T[][] data) {
		this.rows = data.length;
		this.cols = data[0].length;
		this.data = (T[]) new Object[rows * cols];
		
		for (int r = 0; r < rows; r++) {
			for (int c = 0; c < cols; c++) {
				setAt(r, c, data[r][c]);
			}
		}
	}
	
	public Matrix<T> exponentation(
			Operation<T> sum,
			Operation<T> mult,
			T initialValue,
			int e) {
		
		assert e >= 1;
		
		if (e <= 1) {
			return this;
		} else if (e % 2 == 0) {
			Matrix<T> factor = exponentation(sum, mult, initialValue, e / 2);
			return factor.multiply(sum, mult, factor, initialValue);
		} else {
			return this.multiply(sum, mult, exponentation(sum, mult, initialValue, e - 1), initialValue);
		}
	}
	
	/**
	 * Multiplies this matrix with another matrix.
	 * 
	 * @param add Operation for summing elements.
	 * @param mult Operation for multiplying elements. 
	 */
	public Matrix<T> multiply(Operation<T> sum, Operation<T> mult, Matrix<T> matrix, T initialValue) {
		Matrix<T> A = this;
		Matrix<T> B = matrix;
		Matrix<T> AB = new Matrix<T>(A.getRows(), B.getCols(), initialValue);
		
		for (int r = 0; r < AB.getRows(); r++) {
			for (int c = 0; c < AB.getCols(); c++) {
				AB.setAt(r, c, initialValue);
				for (int k = 0; k < A.getCols(); k++) {
					AB.setAt(r, c, sum.apply(AB.getAt(r, c), mult.apply(A.getAt(r, k), B.getAt(k, c))));
				}
			}
		}
		
		return AB;
	}
	
	public T getAt(int row, int col) {
		return data[row * cols + col];
	}
	
	public void setAt(int row, int col, T value) {
		data[row * cols + col] = value;
	}

	public int getRows() {
		return rows;
	}

	public int getCols() {
		return cols;
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		
		for (int r = 0; r < rows; r++) {
			for (int c = 0; c < cols; c++) {
				builder.append(getAt(r, c));
				if (c < cols - 1) {
					builder.append('\t');
				}
			}
			builder.append("\n");
		}
		
		return builder.toString();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Matrix) {
			Matrix<?> other = (Matrix<?>) obj;
			if (rows == other.getRows() && cols == other.getCols()) {
				for (int r = 0; r < rows; r++) {
					for (int c = 0; c < cols; c++) {
						if (!getAt(r, c).equals(other.getAt(r, c))) {
							return false;
						}
					}
				}
				
				return true;
			}
		}
		
		return false;
	}
	
}
