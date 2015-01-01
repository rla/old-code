/**
 * 
 */
package ee.pri.rl.tts.constructor.util;

import java.util.HashMap;
import java.util.Set;

import ee.pri.rl.tts.constructor.model.grammar.Word;

/**
 * @author raivo
 * Sõnade maatriks. Maatriks, mille veeru- ja
 * reaindeksiteks on sõnad. Kasutatakse eelnevusmaatriksi,
 * leftmost ja rightmost jt. hulkade leidmiseks. 
 */
public class WordMatrix {
	private HashMap<Word, HashMap<Word, Object>> data;

	public WordMatrix() {
		data = new HashMap<Word, HashMap<Word, Object>>();
	}
	
	public void set(Word i, Word j, Object value) {
		HashMap row = data.get(i);
		if (row == null) {
			row = new HashMap<Word, Object>();
			row.put(j, value);
			data.put(i, row);
		} else {
			row.put(j, value);
		}
	}
	
	public Object get(Word i, Word j) {
		HashMap<Word, Object> row = getRow(i);
		if (row == null) {
			return null;
		} else {
			return row.get(j);
		}
	}
	
	/**
	 * Reaindeksiga i rea saamine.
	 */
	public HashMap<Word, Object> getRow(Word i) {
		return data.get(i);
	}
	
	/**
	 * Reaindeksite hulga saamine.
	 */
	public Set<Word> getRowIndexes() {
		return data.keySet();
	}
}
