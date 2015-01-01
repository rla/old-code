/**
 * 
 */
package ee.pri.rl.indexer.dao;

import ee.pri.rl.indexer.model.Word;

/**
 * Sõnade (Word) salvestamise DAO liides.
 * @author raivo
 */
public interface WordDao {
	/**
	 * Sõna saamine primaarvõtme (id) järgi.
	 */
	public Word get(Long wordId);
	/**
	 * Sõna salvestamine.
	 */
	public void save(Word word);
	/**
	 * Salvestatud sõna uuendamine.
	 */
	public void update(Word word);
	/**
	 * Salvestatud sõna kustutamine.
	 */
	public void delete(Word word);
}
