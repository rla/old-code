/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

import java.util.List;

/**
 * @author raivo
 * Definitsioon ehk produktsiooni parem pool.
 */
public class Definition {
	private List<Word> words;

	public List<Word> getWords() {
		return words;
	}

	public void setWords(List<Word> words) {
		this.words = words;
	}
	
	public String toString() {
		StringBuffer buffer = new StringBuffer();
		for (Word word : words) {
			buffer.append(word.toString() + ".");
		}
		return buffer.toString();
	}
}
