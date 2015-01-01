/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

/**
 * @author raivo
 * Keele G sõna. Kuulub terminalide ja mitteterminalide ühishulka.
 * Erldatakse märgendiga.
 */
public abstract class Word implements Comparable {
	private String notation;

	public String getNotation() {
		return notation;
	}

	public void setNotation(String notation) {
		this.notation = notation;
	}
	
	public String toString() {
		return notation;
	}

	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof Word)) {
			return false;
		} else {
			return notation.equals(((Word)obj).getNotation());
		}
		
	}

	public int compareTo(Object o) {
		if (!(o instanceof Word)) {
			return -1;
		} else {
			return notation.compareTo(((Word)o).getNotation());
		}
	}

	@Override
	public int hashCode() {
		return notation.hashCode();
	}
}
