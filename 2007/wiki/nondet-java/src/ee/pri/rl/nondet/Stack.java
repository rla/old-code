package ee.pri.rl.nondet;

import java.io.Serializable;

/**
 * Stack for virtual machine.
 */

public class Stack implements Serializable {
	private static final long serialVersionUID = -8839585269379760241L;

	/**
	 * Single stack frame.
	 */
	
	public static class Frame implements Serializable {
		private static final long serialVersionUID = 6214078873019859200L;
		
		public Frame previous;
		public Argument[] arguments;
		public Argument[] working;
		public Frame backtrack;
		public Procedure procedure;
		public Frame caller;
		public int pointer;
		public Frame[] calls;
		public int ID;
	}
	
	private Frame top;
	private int ID = 1;
	
	public void push(Frame stackElement) {
		stackElement.previous = top;
		top = stackElement;
		stackElement.ID = ID++;
	}
	
	public void pop() {
		top = top.previous;
	}
	
	public Frame peek() {
		return top;
	}
	
	public void backtrack(Frame continuation) {
		top = continuation;
	}
	
	public boolean isEmpty() {
		return top == null;
	}
}
