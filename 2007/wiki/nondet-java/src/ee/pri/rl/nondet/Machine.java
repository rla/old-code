package ee.pri.rl.nondet;

import java.io.Serializable;

import ee.pri.rl.nondet.Stack.Frame;

/**
 * Virtual nondeterministic machine.
 */

public class Machine implements Serializable {
	private static final long serialVersionUID = -8783102441602216189L;
	
	private Stack stack;
	
	public Argument[] execute(Procedure procedure, Argument[] arguments) {
		Argument[] ret = new Argument[arguments.length];
		stack = new Stack();
		
		// Prepare the first procedure call and push it into the stack.
		Frame top = prepareInitial(procedure, arguments);
		stack.push(top);
		
		while (!stack.isEmpty()) {
			top = stack.peek();
			
			// The procedure of current stack frame can be null iff
			// there was backtraking into the current call but there
			// are no more alternatives for current procedure.
			// An immediate backtrack must occur.
			
			if (top.procedure == null) {
				
				// If the backtrack is not possible from current call then
				// there is very nothing left to do. The whole program
				// call must be considered completely unfruitful.
				
				// Still, to make wasted resources not totally useless
				// we return last copy of working variables.
				
				if (top.backtrack == null) {
					System.out.println("Cannot backtrack anymore");
					ret = top.working;
					break;
				}
				
				stack.backtrack(prepareBacktrack(top));
				continue;
			}
			
			// In the case of fresh call (body has not been executed)
			// we execute the Java part of the procedure. If the Java
			// part returns false we backtrack.
			
			if (top.pointer == 0) {
				if (!top.procedure.doWorkBefore(top.working)) {
					stack.backtrack(prepareBacktrack(top));
					continue;
				}
			}
			
			if (top.procedure.body != null) {
				
				// If the current procedure has body we firstly check
				// if there is some procedure call to make. If not,
				// we finish up the current call.
				
				if (top.pointer < top.procedure.body.length) {
					if (top.pointer == 0) {
						// Local call accounting. Used for setting up backtracing
						// frames for the body calls of the current procedure.
						top.calls = new Stack.Frame[top.procedure.body.length];
					}
					stack.push(prepareNextSubCall(top));
				} else {
					finishCall(top);
					ret = top.working;
					stack.pop();
				}
			} else {
				
				// If the current procedure had no body besides Java part
				// and the Java part was successful we finish up the call.
				
				finishCall(top);
				ret = top.working;
				stack.pop();
			}
		}
		return ret;
	}
	
	/**
	 * Prepares the first procedure call into the first stack frame.
	 */
	
	private static Stack.Frame prepareInitial(Procedure procedure, Argument[] arguments) {
		Stack.Frame frame = new Stack.Frame();
		frame.procedure = procedure;
		frame.arguments = arguments;
		frame.working = copyArguments(arguments);
		frame.pointer = 0;
		return frame;
	}
	
	/**
	 * Prepare next sub procedure call of current procedure call.
	 * The procedure to be called is selected from the current procedure's
	 * body using the internal pointer of current frame. The state of the arguments for the sub
	 * call is the same as the state of the variables of the current call.
	 */
	
	private static Stack.Frame prepareNextSubCall(Stack.Frame frame) {
		Procedure procedure = frame.procedure.body[frame.pointer];
		Frame call = new Stack.Frame();
		call.arguments = frame.working;
		call.working = copyArguments(frame.working);
		call.caller = frame;
		call.pointer = 0;
		call.procedure = procedure;
		if (frame.pointer > 0) {
			call.backtrack = frame.calls[frame.pointer - 1];
		} else {
			call.backtrack = frame;
		}
		frame.calls[frame.pointer] = call;
		frame.pointer++;
		return call;
	}
	
	/**
	 * Prepare backtrack from current stack frame. Returned stack frame
	 * will serve as complete continuation since it contains everything
	 * necessary for running. In this method we restore the state of
	 * the variables of the procedure call that where we are backtraking to.
	 */
	
	private static Stack.Frame prepareBacktrack(Stack.Frame frame) {
		frame.backtrack.procedure = frame.backtrack.procedure.alterative;
		frame.backtrack.working = copyArguments(frame.backtrack.arguments);
		frame.backtrack.pointer = 0;
		return frame.backtrack;
	}
	
	/**
	 * Finish up the call of procedure. If the current procedure
	 * was called by some other procedure, populate back its
	 * working copy of variables using the state of working
	 * copy of variables reached in the current procedure.
	 */
	
	private static void finishCall(Stack.Frame frame) {
		frame.procedure.doWorkAfter(frame.working);
		if (frame.caller != null) {
			frame.caller.working = frame.working;
		}
	}
	
	/**
	 * Method for copying given input arguments. Depending on implementation
	 * of Argument.copy() this method will perform deep copy or not. By default
	 * only argument itself is copied but it's .next and .data will reference
	 * the same objects that were referenced by the original argument.
	 */
	
	private static Argument[] copyArguments(Argument[] arguments) {
		Argument[] copy = new Argument[arguments.length];
		for (int i = 0; i < arguments.length; i++) {
			if (arguments[i] != null) {
				copy[i] = arguments[i].copy();
			}
		}
		return copy;
	}
	
}
