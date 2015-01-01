/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

import java.util.HashSet;
import java.util.Set;

/**
 * @author raivo
 * Mitteterminaal ehk mõiste ehk produktsiooni vasak pool.
 * Eraldatakse märgistuse abil.
 */
public class NonTerminal extends Word {
	private Set<Word> leftmost;
	private Set<Word> rightmost;
	
	public NonTerminal() {
		leftmost = new HashSet<Word>();
		rightmost = new HashSet<Word>();
	}
	
	public Set<Word> getLeftmost() {
		return leftmost;
	}
	public void setLeftmost(Set<Word> leftmost) {
		this.leftmost = leftmost;
	}
	public Set<Word> getRightmost() {
		return rightmost;
	}
	public void setRightmost(Set<Word> rightmost) {
		this.rightmost = rightmost;
	}
}
