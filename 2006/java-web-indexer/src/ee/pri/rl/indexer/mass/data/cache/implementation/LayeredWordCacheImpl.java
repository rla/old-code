package ee.pri.rl.indexer.mass.data.cache.implementation;

import ee.pri.rl.indexer.mass.data.cache.LayeredWordCache;
import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.web.service.IndexerService;
import ee.pri.rl.indexer.web.service.ServiceException;

/**
 * Kihistatud WordCache implementatsioon.
 * 
 * @author raivo
 */
public class LayeredWordCacheImpl extends WordHashMapCache implements
		LayeredWordCache {
	private IndexerService indexerService;

	public LayeredWordCacheImpl(Dumper dumper) {
		super(dumper);
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.mass.data.cache.LayeredWordCache#setIndexerService(ee.pri.rl.indexer.web.service.IndexerService)
	 */
	public void setIndexerService(IndexerService indexerService) {
		this.indexerService = indexerService;
	}

	@Override
	public int getId(String word) {
		Integer id = getWords().get(word);
		if (id == null) {
			// Esimene variant, otsime andmebaasist
			try {
				id = indexerService.getWordId(word);
				return id;
			} catch (ServiceException e) {
				// Andmebaasist ei saanud, teeme uue sõna
				setLastId(getLastId()+1);
				getWords().put(word, new Integer(getLastId()));
				return getLastId();
			}
		} else {
			return id.intValue();
		}
	}

}
