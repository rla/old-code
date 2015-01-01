package ee.pri.rl.indexer.util.text;

import java.io.File;
import java.io.FileWriter;

import junit.framework.TestCase;
import ee.pri.rl.indexer.indexing.text.TextFileIndexer;
import ee.pri.rl.indexer.model.IndexedFile;
import ee.pri.rl.indexer.model.Word;

/**
 * Tekstifaili indekseerija testimine.
 * 
 * @author raivo
 */
public class TextFileIndexerTest extends TestCase {

	/**
	 * Testjuhtumi eeltöö, salvestatakse fail.
	 */
	@Override
	protected void setUp() throws Exception {
		super.setUp();
		FileWriter writer = new FileWriter("temp.txt");
		writer.write("Tere tere! Mina olen arvuti nimega Tere.");
		writer.close();
	}
	
	/**
	 * Testimine faili indekseerimist.
	 */
	public void testIndex() throws Exception {
		TextFileIndexer indexer = new TextFileIndexer();
		IndexedFile indexedFile = indexer.index("temp.txt");
		assertTrue(indexedFile.getWords().contains(new Word("tere")));
		assertFalse(indexedFile.getWords().contains(new Word("mina2")));
	}

	/**
	 * Testjuhtumi järeltöö, kustutatakse fail.
	 */
	@Override
	protected void tearDown() throws Exception {
		File file = new File("temp.txt");
		file.delete();
		super.tearDown();
	}

}
