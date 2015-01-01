package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Failiinfo vahemälu.
 * 
 * @author raivo
 */
public interface FileCache extends Cache {
	/**
	 * Faili lisamine vahemällu.
	 */
	public long addIndexedFile(IndexedFile indexedFile) throws CacheException;
	/**
	 * Failide identifikaatorite baasväärtuse määramine.
	 */
	public void setLastId(long lastId);
}
