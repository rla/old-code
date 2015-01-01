package ee.pri.rl.indexer.mass.data.dump.csv;

import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import ee.pri.rl.common.util.StringUtil;
import ee.pri.rl.indexer.mass.data.dump.AbstractFileDumper;
import ee.pri.rl.indexer.mass.data.dump.Dumper;
import ee.pri.rl.indexer.mass.data.dump.DumperException;
import ee.pri.rl.indexer.model.IndexedFile;

/**
 * Failide vahemälu kettale kirjutamine csv kujul.
 * 
 * @author raivo
 */
public class FileCvsDumper extends AbstractFileDumper implements Dumper {
	private static final Log log = LogFactory.getLog(FileCvsDumper.class);

	public FileCvsDumper(String filename) throws DumperException {
		super(filename);
	}

	/**
	 * Indekseeritud failide info kirjutamine kõvakettale. Faili formaat:
	 * id,faili nimi\n
	 */
	@SuppressWarnings("unchecked")
	public void dump(Object object) throws DumperException {
		log.info("Kirjutan faile kettale");
		for (IndexedFile indexedFile : (Set<IndexedFile>)object) {
			write(indexedFile.getId().toString() + Csv.DELIMITER + StringUtil.stripChar(indexedFile.getName(), Csv.DELIMITER) + "\n");
		}
	}
	
}
