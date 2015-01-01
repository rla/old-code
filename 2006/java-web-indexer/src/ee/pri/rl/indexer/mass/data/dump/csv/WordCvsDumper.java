package ee.pri.rl.indexer.mass.data.dump.csv;

import java.util.Map;

import ee.pri.rl.indexer.mass.data.dump.AbstractFileDumper;
import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.mass.data.dump.DumperException;

/**
 * Sõnade kirjutaja CSV faili.
 * 
 * @author raivo
 */
public class WordCvsDumper extends AbstractFileDumper implements Dumper {
	private int dumpFrom = 0;

	public WordCvsDumper(String filename) throws DumperException {
		super(filename);
	}

	/**
	 * Kirjutab sõnade - id vahemälu CSV faili kujul: id,sõna\n
	 */
	@SuppressWarnings("unchecked")
	public void dump(Object object) throws DumperException {
		Map<String, Integer> words = (Map<String, Integer>) object;
		for (String word : words.keySet()) {
			Integer id = words.get(word);
			if (id >= dumpFrom) {
				write(id.toString() + Csv.DELIMITER + word.toString() + "\n");
			}
		}
	}

	public void setDumpFrom(int dumpFrom) {
		this.dumpFrom = dumpFrom;
	}

}
