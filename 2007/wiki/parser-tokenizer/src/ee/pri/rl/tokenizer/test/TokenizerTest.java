package ee.pri.rl.tokenizer.test;

import java.util.ArrayList;
import java.util.List;

import junit.framework.TestCase;
import ee.pri.rl.tokenizer.EndRule;
import ee.pri.rl.tokenizer.ImmediateRule;
import ee.pri.rl.tokenizer.Rule;
import ee.pri.rl.tokenizer.State;
import ee.pri.rl.tokenizer.StringRule;
import ee.pri.rl.tokenizer.Token;
import ee.pri.rl.tokenizer.Tokenizer;
import ee.pri.rl.tokenizer.TokenizerException;

/**
 * Tests for tokenizer.
 */

public class TokenizerTest extends TestCase {
	private List<Rule> rules;
	private State end;
	private State text;
	private State boldBegin;
	private State bold;
	private State boldEnd;

	@Override
	protected void setUp() throws Exception {
		rules = new ArrayList<Rule>();
		text = new State("text", "text");
		end = new State("end");
		boldBegin = new State("boldBegin");
		bold = new State("bold", "bold");
		boldEnd = new State("boldEnd");
		rules.add(new StringRule(text, boldBegin, "**"));
		rules.add(new ImmediateRule(boldBegin, bold));
		rules.add(new StringRule(bold, boldEnd, "**"));
		rules.add(new ImmediateRule(boldEnd, text));
		rules.add(new EndRule(text, end));
	}
	
	public void testCorrectTokenizing() throws TokenizerException {
		List<Token> tokens = Tokenizer.tokenize("test **boldie** thing", rules, text, end);
		assertTrue(tokens.contains(new Token("text", "test ", 0)));
		assertTrue(tokens.contains(new Token("text", " thing", 0)));
		assertTrue(tokens.contains(new Token("bold", "boldie", 0)));
	}
	
	public void testErrorHandling() {
		try {
			Tokenizer.tokenize("test **boldie thing", rules, text, end);
		} catch (TokenizerException e) {
			return;
		}
		fail();
	}
}
