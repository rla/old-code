package ee.pri.rl.indexer.mass.data.dump;

import java.io.File;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.indexer.mass.data.dump.csv.FileCvsDumper;
import ee.pri.rl.indexer.mass.data.dump.csv.FileWordCsvDumper;
import ee.pri.rl.indexer.mass.data.dump.csv.WordCvsDumper;

/**
 * Dumperite grupi ehitaja. 
 * 
 * @author raivo
 */
public class DumperGroupBuilder {
	private static Log log = LogFactory.getLog(DumperGroupBuilder.class);
	
	public static DumperGroup buildCsvGroup(String directory) throws DumperException {
		log.info("Ehitan uut väljundgruppi kausta " + directory);
		
		DumperGroup group = new DumperGroup();
		
		String fileDumperFilename = directory + "/files.csv";
		String wordDumperFilename = directory + "/words.csv";
		String fileWordDumperFilename = directory + "/filewords.csv";
		
		// Kustutame vanad failid
		new File(fileDumperFilename).delete();
		new File(wordDumperFilename).delete();
		new File(fileWordDumperFilename).delete();
		
		group.fileDumper = new FileCvsDumper(fileDumperFilename);
		group.wordDumper = new WordCvsDumper(wordDumperFilename);
		group.fileWordDumper = new FileWordCsvDumper(fileWordDumperFilename);
		
		return group;
	}
}
