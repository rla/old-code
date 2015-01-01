package ee.pri.rl.common;

import java.io.IOException;

/**
 * Utilities for command line aplications.
 */

public class CommandLineUtils {
	
	/**
	 * Get command line argument by name.
	 */

	public static String getArgument(String[] args, String name) {
		for (int i = 0; i < args.length-1; i++) {
			if (args[i].equals(name)) {
				return args[i+1];
			}
		}
		return null;
	}
	
	/**
	 * Get command line argument by name. One can specify
	 * default value here.
	 */
	
	public static String getArgument(String[] args, String name, String defaultValue) {
		String value = getArgument(args, name);
		return value == null ? defaultValue : value;
	}
	
	/**
	 * Returns true if given input option is set.
	 */
	
	public static boolean isOptionSet(String[] args, String name) {
		for (int i = 0; i < args.length; i++) {
			if (args[i].equals(name)) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Read standard input into string.
	 */
	
	public static String readInput() throws IOException {
		return FileUtils.readInputStream(System.in);
	}
}
