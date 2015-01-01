package ee.pri.rl.indexer.model;

import ee.pri.rl.common.ModelObject;

/**
 * Üks sõna.
 * 
 * @author raivo
 */
public class Word extends ModelObject {
	public static final int MAX_LENGTH = 20;
	public static final int SIZE = 8 + MAX_LENGTH;
	
	private String word;

	public Word(String word) {
		this.word = word;
	}

	public Word() {
		this("undefined");
	}

	public String getWord() {
		return word;
	}

	public void setWord(String word) {
		this.word = word;
	}

	public String toString() {
		return word;
	}

	/**
	 * Võrdlusfunktsioon, kus võrreldakse tegelikult sõnesid.
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Word) {
			return ((Word) obj).getWord().equals(word);
		} else {
			return false;
		}
	}

	/**
	 * Räsi arvutamine sõnast.
	 */
	@Override
	public int hashCode() {
		return word.hashCode();
	}
}
