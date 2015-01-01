package ee.pri.rl.indexer.web.thread;

import ee.pri.rl.indexer.IndexerException;
import ee.pri.rl.indexer.indexing.configuration.Configuration;
import ee.pri.rl.indexer.mass.DirectoryIndexer;
import ee.pri.rl.indexer.mass.data.cache.CacheException;
import ee.pri.rl.indexer.mass.data.cache.CacheGroup;
import ee.pri.rl.indexer.mass.data.cache.CacheGroupBuilder;
import ee.pri.rl.indexer.mass.data.cache.IndexerCache;
import ee.pri.rl.indexer.mass.data.cache.implementation.LayeredWordCacheImpl;
import ee.pri.rl.indexer.mass.data.dump.DumperException;
import ee.pri.rl.indexer.mass.data.dump.DumperGroup;
import ee.pri.rl.indexer.mass.data.dump.DumperGroupBuilder;
import ee.pri.rl.indexer.web.service.IndexerService;

/**
 * Monitooritav indekseerimislõim.
 * 
 * @author raivo
 */
public class IndexingThread extends MonitorableThread {
	private IndexerService indexerService;

	private Configuration configuration;

	private String directory;

	public IndexingThread(IndexerService indexerService, Configuration configuration, String directory) {
		this.indexerService = indexerService;
		this.configuration = configuration;
		this.directory = directory;
		setDescription("Kausta " + directory + " indekseerimine");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	public void run() {
		try {
			this.setCurrentTask("Ehitan vahemälu");
			DumperGroup dumperGroup = DumperGroupBuilder
					.buildCsvGroup(configuration.getTemporaryDirectory());
			CacheGroup cacheGroup = CacheGroupBuilder
					.buildCacheGroup(dumperGroup);
			IndexerCache indexerCache = new IndexerCache(cacheGroup);

			// TODO Workaround kihistatud vahemälu määramiseks
			indexerCache.setWordCache(new LayeredWordCacheImpl(dumperGroup.wordDumper));
			
			this.setCurrentTask("Loen sõnad vahemällu");
			// Loeme juba lisatud sõnad vahemällu
			indexerService.readWordsToCache(cacheGroup.wordCache);

			this.setCurrentTask("Loen failid vahemällu");
			// Loeme juba lisatud failid vahemällu
			indexerService.readFilesToCache(cacheGroup.fileCache);

			DirectoryIndexer indexer = new DirectoryIndexer(indexerCache,
					directory);
			this.setCurrentTask("Indekseerin kausta");
			indexer.run();

			this.setCurrentTask("Salvestan andmed andmebaasi");
			// Lõpuks loeme uued andmed andmebaasist sisse
			indexerService.insertFromCvsGroup(dumperGroup);
			this.setCurrentTask("Indekseerimine on edukalt lõppenud");
		} catch (DumperException e) {
		} catch (CacheException e) {
		} catch (IndexerException e) {
		}

	}

}
