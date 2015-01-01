package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.mass.data.dump.DumperException;

/**
 * Vahemälu alusklass.
 * 
 * @author raivo
 */
public abstract class AbstractCache implements Cache {
	private Dumper dumper;

	public AbstractCache(Dumper dumper) {
		this.dumper = dumper;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see ee.pri.rl.indexer.mass.data.cache.Cache#close()
	 */
	public void close() throws CacheException {
		try {
			dump();
			dumper.flush();
			dumper.close();
		} catch (DumperException e) {
			throw new CacheException(
					"Ei õnnestunud vahemälu kirjutajat sulgeda", e);
		}
	}

	protected void dump(Object collection) throws CacheException {
		try {
			dumper.dump(collection);
		} catch (DumperException e) {
			throw new CacheException(
					"Ei õnnestunud vahemälu sisu salvestada faili", e);
		}
	}
	
	protected Dumper getDumper() {
		return dumper;
	}

}
