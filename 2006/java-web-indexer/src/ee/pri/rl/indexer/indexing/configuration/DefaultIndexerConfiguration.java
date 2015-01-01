package ee.pri.rl.indexer.indexing.configuration;

/**
 * Vaikimisi indekseerija seaded.
 * 
 * @author raivo
 */
public class DefaultIndexerConfiguration implements Configuration {
	/**
	 * Ajutiste vahetulemuste salvestamise koht. Linuxi platvormil tavaliselt
	 * "/tmp".
	 */
	private final String temporaryDirectory = "/tmp";

	/**
	 * Siin on määratud, kas tekstifaili indekseeritakse.
	 */
	private final boolean indexText = true;

	/**
	 * Siin on määratud, kas indekseeritakse C tüüpi lähtekoodifaile.
	 */
	private final boolean indexCSource = false;

	/**
	 * Siin on määratud, kas XML tüüpi faile indekseeritakse.
	 */
	private final boolean indexXML = true;

	/**
	 * Siin on määratud, kas Pascal tüüpi keele lähtekoodifaile indekseeritakse.
	 */
	private final boolean indexPascal = false;

	/**
	 * Siin on määratud, kas Basic tüüpi keele lähtekoodifaile indekseeritakse.
	 */
	private final boolean indexBasic = false;
	
	/**
	 * Siin on määratud, kas PDF tüüpi faile indekseeritakse.
	 */
	private final boolean indexPdf = true;
	
	/**
	 * Siin on määratud, kas kasutatakse levinud sõnade väljaeraldamist.
	 */
	private final boolean skipCommonWords = true;
	
	/**
	 * Siin on määratud, kas mitteindekseeritavate failide nimed
	 * kirjutatakse andmebaasi.
	 */
	private final boolean saveAllFileNames = true;

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isSkipCommonWords()
	 */
	public boolean isSkipCommonWords() {
		return skipCommonWords;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isIndexBasic()
	 */
	public boolean isIndexBasic() {
		return indexBasic;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isIndexCSource()
	 */
	public boolean isIndexCSource() {
		return indexCSource;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isIndexPascal()
	 */
	public boolean isIndexPascal() {
		return indexPascal;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isIndexText()
	 */
	public boolean isIndexText() {
		return indexText;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isIndexXML()
	 */
	public boolean isIndexXML() {
		return indexXML;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#getTemporaryDirectory()
	 */
	public String getTemporaryDirectory() {
		return temporaryDirectory;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isTxt(java.lang.String)
	 */
	public boolean isTxt(String extension) {
		return ("txt".equals(extension.toLowerCase()));
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isCSource(java.lang.String)
	 */
	public boolean isCSource(String extension) {
		return ("java".equals(extension.toLowerCase())
				|| "php".equals(extension.toLowerCase())
				|| "c".equals(extension.toLowerCase())
				|| "cpp".equals(extension.toLowerCase()) || "h"
				.equals(extension.toLowerCase()));
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isXML(java.lang.String)
	 */
	public boolean isXML(String extension) {
		return ("xml".equals(extension.toLowerCase())
				|| "htm".equals(extension.toLowerCase()) || "html"
				.equals(extension.toLowerCase()));
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isPascalSource(java.lang.String)
	 */
	public boolean isPascalSource(String extension) {
		return ("pas".equals(extension.toLowerCase()));
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isBasicSource(java.lang.String)
	 */
	public boolean isBasicSource(String extension) {
		return ("bas".equals(extension.toLowerCase()));
	}

	public boolean isIndexPdf() {
		return indexPdf;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isPdf(java.lang.String)
	 */
	public boolean isPdf(String extension) {
		return ("pdf".equals(extension.toLowerCase()));
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.indexing.configuration.Configuration#isSaveAllFileNames()
	 */
	public boolean isSaveAllFileNames() {
		return saveAllFileNames;
	}
}
