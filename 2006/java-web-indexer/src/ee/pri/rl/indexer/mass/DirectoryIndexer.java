package ee.pri.rl.indexer.mass;

import java.io.File;
import java.io.IOException;
import java.util.HashSet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.common.util.FileUtil;
import ee.pri.rl.indexer.IndexerException;
import ee.pri.rl.indexer.indexing.FileIndexerFactoryImplementation;
import ee.pri.rl.indexer.indexing.IndexingException;
import ee.pri.rl.indexer.mass.data.cache.IndexerCache;
import ee.pri.rl.indexer.mass.data.translator.FileNameTranslator;
import ee.pri.rl.indexer.model.IndexedFile;
import ee.pri.rl.indexer.model.Word;

/**
 * Threadimata kausta failide indekseerija.
 * 
 * @author raivo
 */
public class DirectoryIndexer {
	private static Log log = LogFactory.getLog(DirectoryIndexer.class);

	private IndexerCache indexerCache;

	private String directory;

	public DirectoryIndexer(IndexerCache indexerCache, String directory) {
		this.indexerCache = indexerCache;
		this.directory = directory;
	}

	/**
	 * Indekseerija käivitamine. Indekseerija käivitub eraldi lõimena.
	 */
	public void run() throws IndexerException {
		indexDirectory(new File(directory));
		indexerCache.close();
	}

	/**
	 * Kausta indekseerimine, käivitatakse rekursiivselt alamkataloogide
	 * leidumisel.
	 */
	private void indexDirectory(File directory) throws IndexerException {
		log.debug("Indekseerin kausta " + directory.getAbsolutePath());
		for (File file : directory.listFiles()) {
			try {
				if (file.isDirectory()
						&& file.getAbsolutePath().equals(file.getCanonicalPath())) {
					indexDirectory(file);
				} else if (file.isFile() && file.canRead()) {
					String extension = FileUtil.getExtension(file);
					if (FileIndexerFactoryImplementation.supports(extension)) {
						try {
							IndexedFile indexedFile = FileIndexerFactoryImplementation
									.build(extension).index(
											file.getAbsolutePath());
							indexerCache.saveIndexedFile(indexedFile);
						} catch (IndexingException e) {
							log.info("Faili " + file
									+ " ei õnnestunud indekseerida: "
									+ e.getMessage());
						}
					} else {
						// Paigutame faili ikkagi andmebaasi, aga ei indekseeri
						// tema sisu.
						IndexedFile indexedFile = new IndexedFile(FileNameTranslator.translate(file
								.getAbsolutePath()));
						indexedFile.setWords(new HashSet<Word>());
						indexerCache.saveIndexedFile(indexedFile);
					}
				}
			} catch (IOException e) {
				log.error("Kausta " + directory.getAbsolutePath() + " indekseerimisel tekkis viga: " + e.getMessage());
			}
		}
	}

}
