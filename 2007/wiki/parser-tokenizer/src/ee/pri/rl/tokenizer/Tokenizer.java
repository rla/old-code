package ee.pri.rl.tokenizer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


/**
 * General tokenizer.
 */

public class Tokenizer {
	private static final State STATE_ERROR;
	
	static {
		STATE_ERROR = new State("error");
	}
	
	/**
	 * Class for speeding up rule lookup by start state. It
	 * partions rules into disjoint lists. There are as many
	 * lists as there are states.
	 */
	
	private static class RuleMapping {
		private Map<State, List<Rule>> ruleMapping;
		
		public RuleMapping(List<Rule> rules) {
			ruleMapping = new HashMap<State, List<Rule>>();
			for (Rule rule : rules) {
				List<Rule> stateRules = ruleMapping.get(rule.getOldState());
				if (stateRules == null) {
					stateRules = new LinkedList<Rule>();
					ruleMapping.put(rule.getOldState(), stateRules);
				}
				stateRules.add(rule);
			}
		}
		
		public List<Rule> getRulesForState(State state) {
			return ruleMapping.get(state);
		}
	}

	public static List<Token> tokenize(
			String input,
			List<Rule> rules,
			State start,
			State end) throws TokenizerException {
		return tokenize(
				new FixedCharacterBuffer(input),
				rules,
				start,
				end
				);
	}
	
	private static List<Token> tokenize(
			FixedCharacterBuffer input,
			List<Rule> rules,
			State start,
			State end) throws TokenizerException {
		
		RuleMapping ruleMapping = new RuleMapping(rules);
		int lineNumber = 1;
		FixedCharacterAccumulator accumulator = new FixedCharacterAccumulator(input.length());
		List<Token> tokens = new ArrayList<Token>();
		while (true) {
			boolean ruleApplied = false;
			if (input.length() == 0) {
				Token token = makeToken(start, accumulator, lineNumber);
				if (token != null) {
					tokens.add(token);
				}
				Rule endRule = null;
				// Check for immediate rules
				for (Rule rule : ruleMapping.getRulesForState(start)) {
					if (rule instanceof ImmediateRule && ((ImmediateRule) rule).applies(input, start)) {
						endRule = rule;
						break;
					}
				}
				if (endRule != null) {
					start = endRule.getNewState();
					accumulator.clear();
					continue;
				}
				// If there was no immediate rule, try
				// to find end rule
				for (Rule rule : ruleMapping.getRulesForState(start)) {
					if (rule instanceof EndRule && ((EndRule) rule).applies(input, start)) {
						endRule = rule;
						break;
					}
				}
				if (endRule != null) {
					// If the end rule new state equals end state
					// then we are done. Return tokens found this far.
					if (endRule.getNewState().equals(end)) {
						token = makeToken(end, accumulator, lineNumber);
						if (token != null) {
							tokens.add(token);
						}
						return tokens;
					} else {
						start = endRule.getNewState();
						accumulator.clear();
						continue;
					}
				} else {
					// Now, we have found no immediate rule, neither any
					// end rule, therefore it must be syntax error.
					throw new TokenizerUnexpectedEndOfInputException("Unexpected end of input", start, accumulator.toString());
				}
			} else {
				for (Rule rule : ruleMapping.getRulesForState(start)) {
					if (rule.applies(input, start)) {
						FixedCharacterBuffer eaten = rule.eat(input);
						
						if (rule.getNewState().equals(STATE_ERROR) && rule instanceof ErrorRule) {
							throw new TokenizerErrorStateException("Error state was reached", start, lineNumber, accumulator.toString(), ((ErrorRule) rule).getMessage());
						}
						
						lineNumber += countLineEnds(eaten);
						Token token = makeToken(start, accumulator, lineNumber);
						if (token != null) {
							tokens.add(token);
						}
						start = rule.getNewState();
						accumulator.clear();
						ruleApplied = true;
						break;
					}
				}
				if (ruleApplied) {
					continue;
				}
				// We have found no rule to apply in current state for
				// current input. Append head character onto accumulator
				// and increase line number if necessary.
				char ch = input.charAt(0);
				input.deletePrefix(1);
				lineNumber = ch == '\n' ? lineNumber + 1 : lineNumber;
				accumulator.appendCharacter(ch);
			}
		}
	}
	
	private static Token makeToken(State state, FixedCharacterAccumulator accumulator, int lineNumber) {
		return state.hasSemantics() ? new Token(state.getSemantics(), accumulator.toString(), lineNumber) : null;
	}
	
	private static int countLineEnds(FixedCharacterBuffer input) {
		int count = 0;
		for (int i = 0; i < input.length(); i++) {
			if (input.charAt(i) == '\n') {
				count++;
			}
		}
		return count;
	}
}
