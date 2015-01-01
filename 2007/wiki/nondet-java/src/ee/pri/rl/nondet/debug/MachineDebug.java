package ee.pri.rl.nondet.debug;

import ee.pri.rl.nondet.Argument;

/**
 * Static methods that help to debug virtual machine.
 */

public class MachineDebug {

	/**
	 * Print all top values of given arguments.
	 */
	
	public static void printArguments(Argument[] arguments) {
		System.out.println("ARGUMENTS :");
		for (Argument argument : arguments) {
			System.out.println(argument);
		}
		System.out.println("---");
	}
	
	/**
	 * Print all arguments of argument list i.
	 */
	
	public static void printArguments(Argument[] arguments, int i) {
		System.out.println("ARGUMENTS " + i + ":");
		Argument argument = arguments[i];
		while (argument != null) {
			System.out.println(argument.data);
			argument = argument.next;
		}
		System.out.println("---");
	}
	
	/*
	public static String frameAsString(Stack.Frame frame) {
		StringBuilder builder = new StringBuilder();
		builder.append("------- STACK FRAME -------\n");
		builder.append("FRAME ID: " + ID + "\n");
		if (procedure != null) {
			builder.append("PROC NAME: " + procedure.description + "\n");
		} else {
			builder.append("IMMEDIATE BACKTRACK\n");
		}
		writeFrameBody(builder);
		writeArguments(builder);
		writeWorking(builder);
		builder.append("CALL POINTER: " + pointer + "\n");
		if (backtrack != null) {
			builder.append("BACKTRACK TO: " + backtrack.ID + " (" + backtrack.procedure.description + ")" + "\n");
		}
		builder.append("-------  FRAME END  -------\n");
		return builder.toString();
	}
	private void writeWorking(StringBuilder builder) {
		for (int i = 0; i < working.length; i++) {
			Argument argument = working[i];
			builder.append("WORKING DATA[" + i + "]: ");
			while (argument != null) {
				builder.append(argument.toString() + "  ");
				argument = argument.next;
			}
			builder.append("\n");
		}
	}
	private void writeArguments(StringBuilder builder) {
		for (int i = 0; i < arguments.length; i++) {
			Argument argument = arguments[i];
			builder.append("INPUT ARGUMENTS[" + i + "]: ");
			while (argument != null) {
				builder.append(argument.toString() + "  ");
				argument = argument.next;
			}
			builder.append("\n");
		}
	}
	private void writeFrameBody(StringBuilder builder) {
		if (procedure != null && procedure.body != null) {
			for (int i = 0; i < procedure.body.length; i++) {
				if (i == pointer) {
					builder.append(" -> " + procedure.body[i].description + "\n");
				} else {
					builder.append("    " + procedure.body[i].description + "\n");
				}
			}
		}
	}
	}*/
	
	/*
	 	public void printStack() {
		System.out.print('[');
		Frame current = top;
		if (current == null) {
			System.out.println(']');
			return;
		}
		if (current.procedure == null) {
			System.out.println(']');
			return;
		}
		System.out.print(current.procedure.description);
		current = current.previous;
		while (current != null) {
			System.out.print(", " + current.procedure.description);
			current = current.previous;
		}
		System.out.println(']');
	}
	 */
}
