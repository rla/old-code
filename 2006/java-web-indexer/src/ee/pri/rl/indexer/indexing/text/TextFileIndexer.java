package ee.pri.rl.indexer.indexing.text;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.indexer.indexing.FileIndexer;
import ee.pri.rl.indexer.indexing.IndexingException;
import ee.pri.rl.indexer.indexing.Wordizer;
import ee.pri.rl.indexer.mass.data.translator.FileNameTranslator;
import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Tekstikujul failide indekseerija.
 * 
 * @author raivo
 */
public class TextFileIndexer implements FileIndexer {
	private static Log log = LogFactory.getLog(TextFileIndexer.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see ee.pri.rl.indexer.util.FileIndexer#index(java.lang.String)
	 */
	public IndexedFile index(String filename) throws IndexingException {
		log.info("Indekseerin faili " + filename);

		IndexedFile indexedFile = new IndexedFile();
		indexedFile.setName(FileNameTranslator.translate(filename));

		BufferedReader reader;
		try {
			reader = new BufferedReader(new FileReader(filename));
		} catch (FileNotFoundException e) {
			throw new IndexingException("Faili ei saa avada", e);
		}
		// String line;
		char[] buffer = new char[(int) new File(filename).length()];
		try {
			reader.read(buffer);
			reader.close();
		} catch (IOException e) {
			throw new IndexingException("Faili ei saa lugeda", e);
		}
		indexedFile.setWords(Wordizer.wordizeString(buffer));
		return indexedFile;
	}

}
