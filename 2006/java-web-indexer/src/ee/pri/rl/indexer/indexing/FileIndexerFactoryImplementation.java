package ee.pri.rl.indexer.indexing;

import ee.pri.rl.indexer.indexing.configuration.Configuration;
import ee.pri.rl.indexer.indexing.configuration.DefaultIndexerConfiguration;
import ee.pri.rl.indexer.indexing.pdf.PdfFileIndexer;
import ee.pri.rl.indexer.indexing.text.TextFileIndexer;

/**
 * Indekseerija factory. Kasutab laiska initsialiseerimist.
 * 
 * @author root
 */
public class FileIndexerFactoryImplementation {
	private static TextFileIndexer textFileIndexer = null;
	private static PdfFileIndexer pdfFileIndexer = null;
	private static Configuration configuration = new DefaultIndexerConfiguration();

	/*
	 * (non-Javadoc)
	 * 
	 * @see ee.pri.rl.indexer.util.FileIndexerFactory#supports(java.lang.String)
	 */
	public static boolean supports(String fileType) {
		if (fileType == null) {
			return false;
		} else {
			return (isTxt(fileType) || isPdf(fileType));
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see ee.pri.rl.indexer.util.FileIndexerFactory#build(java.lang.String)
	 */
	public synchronized static FileIndexer build(String fileType) {
		if (isTxt(fileType)) {
			if (textFileIndexer == null) {
				textFileIndexer = new TextFileIndexer();
			}
			return textFileIndexer;
		} else if (isPdf(fileType)) {
			if (pdfFileIndexer == null) {
				pdfFileIndexer = new PdfFileIndexer();
			}
			return pdfFileIndexer;
		} else {
			return null;
		}
	}
	
	private static boolean isTxt(String extension) {
		return configuration.isTxt(extension);
	}
	
	private static boolean isPdf(String extension) {
		return configuration.isPdf(extension);
	}

}
