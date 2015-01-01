package ee.pri.rl.indexer.mass.data.cache;

/**
 * Vahemälu baasliides.
 * 
 * @author raivo
 */
public interface Cache {
	/**
	 * Vahemälu kettale kirjutamine.
	 */
	public void dump() throws CacheException;

	/**
	 * Kirjutaja sulgemine.
	 */
	public void close() throws CacheException;
}
