package ee.pri.rl.tokenizer.reader;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.tokenizer.CharacterClass;
import ee.pri.rl.tokenizer.CharacterClassFactory;
import ee.pri.rl.tokenizer.CharacterClassFactoryException;
import ee.pri.rl.tokenizer.CharacterRule;
import ee.pri.rl.tokenizer.EndRule;
import ee.pri.rl.tokenizer.ErrorRule;
import ee.pri.rl.tokenizer.ImmediateRule;
import ee.pri.rl.tokenizer.Rule;
import ee.pri.rl.tokenizer.State;
import ee.pri.rl.tokenizer.StringRule;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.Tokenizer;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Tokenizer for tokenizing rules. Obviously it must be hard-coded.
 */

public class ReaderTokenizer {
	private static List<Rule> rules;
	private static State start;
	private static State end;

	static {
		CharacterClass whitespace = null;
		CharacterClass identifier = null;
		try {
			whitespace = CharacterClassFactory.getClassForName("whitespace");
			identifier = CharacterClassFactory.getClassForName("identifier");
		} catch (CharacterClassFactoryException e) {
			e.printStackTrace();
		}
		
		rules = new ArrayList<Rule>();

		start = new State("start");
		
		State startState = new State("startState", "startState");
		State endState = new State("endState", "endState");
		State stringTransition = new State("stringTransition", "stringTransition");
		State escapeEscape = new State("escapeEscape", "escapeEscape");
		State escapeQuote = new State("escapeQuote", "escapeQuote");
		State escapeNewline = new State("escapeNewline", "escapeNewline");
		State escapeTab = new State("escapeTab", "escapeTab");
		State escapeReturn = new State("escapeReturn", "escapeReturn");
		State nextState = new State("nextState", "nextState");
		State semanticsIdentifier = new State("semanticsIdentifier", "semanticsIdentifier");
		State semanticsSemantics = new State("semanticsSemantics", "semanticsSemantics");
		State oldState = new State("oldState", "oldState");
		State charTransition = new State("charTransition", "charTransition");
		State endTransition = new State("endTransition", "endTransition");

		State startStateWhitespace = new State("startStateWhitespace");
		State endStateWhitespace = new State("endStateWhitespace");
		State stringTransitionWhitespace = new State("stringTransitionWhitespace");
		State nextStateWhitespace = new State("nextStateWhitespace");
		State semanticsWhitespace = new State("semanticsWhitespace");
		State semanticsIdentifierWhitespace = new State("semanticsIdentifierWhitespace");
		State semanticsSemanticsWhitespace = new State("semanticsSemanticsWhitespace");
		State oldStateWhitespace = new State("oldStateWhitespace");
		State charTransitionWhitespace = new State("charTransitionWhitespace");
		State endTransitionWhitespace = new State("endTransitionWhitespace");
		State error = new State("error");

		end = new State("end");

		rules.add(new ImmediateRule(start, startState));
		rules.add(new CharacterRule(startState, startStateWhitespace, whitespace));
		rules.add(new CharacterRule(startStateWhitespace, endState, identifier));
		rules.add(new CharacterRule(endState, endStateWhitespace, whitespace));
		rules.add(new StringRule(endStateWhitespace, semanticsWhitespace, "S:"));
		rules.add(new CharacterRule(endStateWhitespace, oldState, identifier));
		
		rules.add(new CharacterRule(semanticsWhitespace, semanticsIdentifier, identifier));
		rules.add(new CharacterRule(semanticsIdentifier, semanticsIdentifierWhitespace, whitespace));
		rules.add(new CharacterRule(semanticsIdentifierWhitespace, semanticsSemantics, identifier));
		rules.add(new CharacterRule(semanticsSemantics, semanticsSemanticsWhitespace, whitespace));
		rules.add(new EndRule(semanticsSemantics, end));
		rules.add(new StringRule(semanticsSemanticsWhitespace, semanticsWhitespace, "S:"));
		rules.add(new CharacterRule(semanticsSemanticsWhitespace, oldState, identifier));
		rules.add(new EndRule(semanticsSemanticsWhitespace, end));
		
		rules.add(new CharacterRule(oldState, oldStateWhitespace, whitespace));
		rules.add(new StringRule(oldStateWhitespace, stringTransition, "\""));
		rules.add(new StringRule(oldStateWhitespace, charTransition, "["));
		rules.add(new StringRule(oldStateWhitespace, endTransition, "!"));
		
		rules.add(new StringRule(stringTransition, escapeEscape, "\\\\"));
		rules.add(new StringRule(stringTransition, escapeQuote, "\\\""));
		rules.add(new StringRule(stringTransition, escapeNewline, "\\n"));
		rules.add(new StringRule(stringTransition, escapeReturn, "\\r"));
		rules.add(new StringRule(stringTransition, escapeTab, "\\t"));
		
		rules.add(new ImmediateRule(escapeEscape, stringTransition));
		rules.add(new ImmediateRule(escapeQuote, stringTransition));
		rules.add(new ImmediateRule(escapeNewline, stringTransition));
		rules.add(new ImmediateRule(escapeReturn, stringTransition));
		rules.add(new ImmediateRule(escapeTab, stringTransition));
		
		rules.add(new StringRule(stringTransition, stringTransitionWhitespace, "\""));
		rules.add(new CharacterRule(stringTransitionWhitespace, nextState, identifier));
		
		rules.add(new StringRule(charTransition, charTransitionWhitespace, "]"));
		rules.add(new CharacterRule(charTransitionWhitespace, nextState, identifier));
		
		rules.add(new StringRule(endTransition, endTransitionWhitespace, ""));
		rules.add(new CharacterRule(endTransitionWhitespace, nextState, identifier));
		
		rules.add(new CharacterRule(nextState, nextStateWhitespace, whitespace));
		rules.add(new StringRule(nextStateWhitespace, semanticsWhitespace, "S:"));
		rules.add(new CharacterRule(nextStateWhitespace, oldState, identifier));
		
		rules.add(new EndRule(nextState, end));
		rules.add(new EndRule(nextStateWhitespace, end));
		
		// Additional error handling
		rules.add(new ErrorRule(new StringRule(charTransition, error, "\n"), "Unterminated character class name"));
		rules.add(new ErrorRule(new StringRule(stringTransition, error, "\n"), "Unterminated string value"));
		rules.add(new ErrorRule(new StringRule(endTransitionWhitespace, error, "\n"), "Missing next state name"));
		rules.add(new ErrorRule(new StringRule(charTransitionWhitespace, error, "\n"), "Missing next state name"));
		rules.add(new ErrorRule(new StringRule(stringTransitionWhitespace, error, "\n"), "Missing next state name"));
	}
	
	/**
	 * Tokenize the input string.
	 */
	
	public static List<Token> tokenize(String input) throws TokenizerException {
		return Tokenizer.tokenize(input, rules, start, end);
	}
}
