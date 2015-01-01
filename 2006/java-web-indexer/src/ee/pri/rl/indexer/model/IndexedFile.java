/**
 * 
 */
package ee.pri.rl.indexer.model;

import java.util.Set;

import ee.pri.rl.common.ModelObject;

/**
 * Indekseeritav fail. Koosneb sõnadest (Word).
 * @author raivo
 */
public class IndexedFile extends ModelObject {
	public Set<Word> words;
	public String name;

	public IndexedFile(String name) {
		this.name = name;
	}

	public IndexedFile() {
		this(null);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Set<Word> getWords() {
		return words;
	}

	public void setWords(Set<Word> words) {
		this.words = words;
	}
	
	public String toString() {
		return name;
	}

	@Override
	public boolean equals(Object arg0) {
		if (arg0 instanceof IndexedFile) {
			return ((IndexedFile)arg0).getName().equals(name);
		} else {
			return false;
		}
	}

	@Override
	public int hashCode() {
		return name.hashCode();
	}
	
	
}
