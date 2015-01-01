package ee.pri.rl.nondet;

import java.io.Serializable;

/**
 * Procedure's argument.
 */

public class Argument<T> implements Serializable {
	private static final long serialVersionUID = -4302739078596997598L;
	
	public Argument<T> next;
	public T data;
	
	public Argument() {
		this(null, null);
	}

	public Argument(T data) {
		this(data, null);
	}

	public Argument(T data, Argument<T> next) {
		this.next = next;
		this.data = data;
	}

	@Override
	public String toString() {
		if (data != null) {
			return data.toString();
		} else {
			return "[]";
		}
	}

	@SuppressWarnings("unchecked")
	public Argument copy() {
		Argument<T> copy = new Argument<T>();
		copy.data = data;
		copy.next = next;
		return copy;
	}
	
	public void print() {
		
	}

}
