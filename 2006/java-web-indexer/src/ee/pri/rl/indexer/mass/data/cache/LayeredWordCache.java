package ee.pri.rl.indexer.mass.data.cache;

import ee.pri.rl.indexer.web.service.IndexerService;

/**
 * Vahemälu, mis kasutab tavalist vahemälu,
 * aga hoiab sõnu, mis esinesid ainult ühes
 * failis, andmebaasis. Niimoodi väheneb mälukasutus
 * oluliselt. Üks kord esinevaid sõnasid on umbes 60%.
 * 
 * @author raivo
 */
public interface LayeredWordCache extends WordCache {
	/**
	 * Indekseerija teenuse fassaadi määramine.
	 * Selle kaudu käib 1x esinenud sõnade võtmine.
	 */
	public void setIndexerService(IndexerService indexerService);
}
