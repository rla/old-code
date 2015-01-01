package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.indexer.IndexerException;

/**
 * Vahemälu erind.
 * 
 * @author raivo
 */
public class CacheException extends IndexerException {
	private static final long serialVersionUID = 4298476827769044304L;

	public CacheException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}
}
