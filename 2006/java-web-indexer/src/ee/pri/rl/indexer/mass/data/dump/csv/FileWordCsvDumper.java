/**
 * 
 */
package ee.pri.rl.indexer.mass.data.dump.csv;

import java.util.List;

import ee.pri.rl.common.collection.pair.IntPair;
import ee.pri.rl.indexer.mass.data.dump.AbstractFileDumper;
import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.mass.data.dump.DumperException;

/**
 * Faili id - sõna id salvestamine CSV kujul.
 * 
 * @author raivo
 */
public class FileWordCsvDumper extends AbstractFileDumper implements Dumper {

	public FileWordCsvDumper(String filename) throws DumperException {
		super(filename);
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.indexer.mass.data.dump.Dumper#dump(java.lang.Object)
	 */
	@SuppressWarnings("unchecked")
	public void dump(Object object) throws DumperException {
		List<IntPair> intPairs = (List<IntPair>) object;
		for (IntPair intPair : intPairs) {
			write(intPair.first + "" + Csv.DELIMITER  + "" + intPair.second + "\n");
		}
	}

}
