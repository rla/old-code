package ee.pri.rl.algorithmics.rpc;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

/**
 * Calculates expressions from standard input.
 * 
 * Example:
 * <pre>
 * 1 2 +
 * 3.0
 * 1 2 + 3 *
 * 9.0
 * </pre>
 */
public class ReversePolishCalculator {
	private static final String operators = "+-*/";

	public static void main(String[] args) throws IOException {
		String input = null;
		
		BufferedReader inputReader = new BufferedReader(new InputStreamReader(System.in));
		
		while (!"q".equals(input = inputReader.readLine())) {
			if (!input.isEmpty()) {
				System.out.println(calculate(tokenize(input)));
			}
		}
	}
	
	private static Double calculate(List<Object> tokens) {
		Stack<Object> stack = new Stack<Object>();
		
		for (Object token : tokens) {
			if (token instanceof Character) {
				Character op = (Character) token;
				Double left = (Double) stack.pop();
				Double right = (Double) stack.pop();
				
				if (op == '+') {
					stack.push(left + right);
				} else if (op == '-') {
					stack.push(left - right);
				} else if (op == '*') {
					stack.push(left * right);
				} else {
					stack.push(left / right);
				}
			} else {
				stack.push(token);
			}
		}
		
		return (Double) stack.pop();
	}
	
	private static List<Object> tokenize(String line) {
		List<Object> tokens = new LinkedList<Object>();
		
		StringBuilder number = new StringBuilder();
		for (char ch : line.toCharArray()) {			
			if (Character.isDigit(ch)) {
				number.append(ch);
			} else if (operators.indexOf(ch) >= 0) {
				if (number.length() > 0) {
					tokens.add(Double.valueOf(number.toString()));
					number = new StringBuilder();
				}
				tokens.add(ch);
			} else if (ch == ' ') {
				if (number.length() > 0) {
					tokens.add(Double.valueOf(number.toString()));
					number = new StringBuilder();
				}
			} else {
				throw new RuntimeException("Unexpected character: " + ch);
			}
		}
		
		return tokens;
	}

}
