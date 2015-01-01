package ee.pri.rl.indexer.cli;

import ee.pri.rl.indexer.IndexerException;
import ee.pri.rl.indexer.mass.DirectoryIndexer;
import ee.pri.rl.indexer.mass.data.cache.CacheGroup;
import ee.pri.rl.indexer.mass.data.cache.CacheGroupBuilder;
import ee.pri.rl.indexer.mass.data.cache.IndexerCache;
import ee.pri.rl.indexer.mass.data.dump.DumperException;
import ee.pri.rl.indexer.mass.data.dump.DumperGroup;
import ee.pri.rl.indexer.mass.data.dump.DumperGroupBuilder;
import ee.pri.rl.indexer.web.service.IndexerService;

/**
 * Lihtne test uue indekseerija katsetamiseks.
 * 
 * @author raivo
 */
public class CliDirectoryIndexer {

	public static void main(String[] args) throws IndexerException {
		if (args.length == 0) {
			System.out
					.println("Kasutamine: esimese argumendina anna indekseeritava kausta nimi!");
		} else {
			try {
				// Käivitame indekseerija teenuse ab ühenduse saamiseks
				IndexerService service = new IndexerService();
				DumperGroup dumperGroup = DumperGroupBuilder.buildCsvGroup("/arhiiv2/indexer");
				CacheGroup cacheGroup = CacheGroupBuilder.buildCacheGroup(dumperGroup);
				IndexerCache indexerCache = new IndexerCache(cacheGroup);
				
				// Loeme juba lisatud sõnad vahemällu
				service.readWordsToCache(cacheGroup.wordCache);
				
				// Loeme juba lisatud failid vahemällu
				service.readFilesToCache(cacheGroup.fileCache);
				
				DirectoryIndexer indexer = new DirectoryIndexer(indexerCache, args[0]);
				indexer.run();
				
				// Lõpuks loeme uued andmed andmebaasist sisse
				service.insertFromCvsGroup(dumperGroup);
				
			} catch (DumperException e) {
				e.printStackTrace();
			} 
		}

	}

}
