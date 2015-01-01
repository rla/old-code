/**
 * 
 */
package ee.pri.rl.indexer.dao;

import java.util.List;

import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Indekseeritava faili (IndexedFile) salvestamise
 * ja laadimise liides.
 * @author raivo
 */
public interface IndexedFileDao {
	/**
	 * Indekseeritud faili kustutamine.
	 */
	public IndexedFile get(Long indexedFileId);
	/**
	 * Indekseeritud faili salvestamine.
	 */
	public void save(IndexedFile indexedFile);
	/**
	 * Indekseeritud faili uuendamine.
	 */
	public void update(IndexedFile indexedFile);
	/**
	 * Indekseeritud faili kustutamine.
	 */
	public void delete(IndexedFile indexedFile);
	/**
	 * Indekseeritud failide hulgast nende leidmine,
	 * mis sisaldavad etteantud sõnu.
	 */
	public List<IndexedFile> search(String[] words);
}
