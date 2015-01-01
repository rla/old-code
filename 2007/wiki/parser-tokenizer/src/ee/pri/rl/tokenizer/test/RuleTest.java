package ee.pri.rl.tokenizer.test;

import junit.framework.TestCase;
import ee.pri.rl.tokenizer.FixedCharacterBuffer;
import ee.pri.rl.tokenizer.Rule;
import ee.pri.rl.tokenizer.State;

/**
 * Tests for rule.
 */

public class RuleTest extends TestCase {
	private class RuleMock extends Rule {
		private static final long serialVersionUID = 6987741744850706967L;
		public RuleMock(State oldState, State newState) {
			super(oldState, newState);
		}
		@Override
		protected boolean applies(FixedCharacterBuffer input) {
			return false;
		}
		@Override
		public FixedCharacterBuffer eat(FixedCharacterBuffer input) {
			return null;
		}	
	}

	public void testRule() {
		Rule rule = new RuleMock(new State("text"), new State("bold"));
		assertTrue(rule.equals(new RuleMock(new State("text"), new State("bold"))));
		assertFalse(rule.equals(new RuleMock(new State("bold"), new State("text"))));
	}
}
