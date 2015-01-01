/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.Stack;

import ee.pri.rl.tts.constructor.model.grammar.Word;

/**
 * @author raivo
 */
public class WordStack {
	private Stack<Word> words;
	
	public WordStack() {
		words = new Stack<Word>();
	}
	
	public Word top() {
		if (words.isEmpty()) {
			return null;
		} else {
			return words.peek();
		}
	}
	
	public void push(Word word) {
		words.push(word);
	}
	
	public Word pop() {
		return words.pop();
	}
	
	public String toString() {
		return words.toString();
	}
}
