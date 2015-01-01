package ee.pri.rl.indexer.indexing.pdf;

import java.io.File;
import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.indexer.indexing.IndexingException;
import ee.pri.rl.indexer.indexing.text.TextFileIndexer;
import ee.pri.rl.indexer.mass.data.translator.FileNameTranslator;
import ee.pri.rl.indexer.model.IndexedFile;

/**
 * PDF (Portable Document Format) failide indekseerija.
 * 
 * @author raivo
 */
public class PdfFileIndexer extends TextFileIndexer {
	private static Log log = LogFactory.getLog(PdfFileIndexer.class);
	// Utiili pdftotext asukoht
	public static final String PDFTOTEXT = "/usr/X11R6/bin/pdftotext";
	// Ajutiste failide kausta asukoht
	public static final String TEMPDIR = "/tmp";
	
	@Override
	public IndexedFile index(String filename) throws IndexingException {
		// Konverdime pdf faili tekstiks 
		String[] converter = new String[3];
		String tempname = TEMPDIR + "/pdf_text.txt";
		
		//Kustutame vana faili
		new File(tempname).delete();
		
		converter[0] = PDFTOTEXT;
		converter[1] = filename;
		converter[2] = tempname;
		
		log.info("Konverdime pdf faili " + filename + " tekstifailiks");
		int returnValue = 0;
		try {
			Process process = Runtime.getRuntime().exec(converter);
			returnValue = process.waitFor();
		} catch (IOException e) {
			throw new IndexingException("Ei õnnestunud konverteerida pdf faili tekstiks", e);
		} catch (InterruptedException e) {
			throw new IndexingException("Pdf faili tekstiks konverteerimisel tekkis viga", e);
		}
		
		// Kui tekkis viga, siis loobume antud faili indekseerimisest
		if (returnValue != 0) {
			log.error("Pdf faili " + filename + " ei õnnestunud konverteerida");
			throw new IndexingException("Faili ei õnnestunud indekseerida", null);
		}
		
		// Indekseerime tekstifaili, kasutades tavalist tekstifailide indekseerijat.
		IndexedFile indexedFile = super.index(tempname);
		indexedFile.setName(FileNameTranslator.translate(filename));
		return indexedFile;
	}
	
	
}
