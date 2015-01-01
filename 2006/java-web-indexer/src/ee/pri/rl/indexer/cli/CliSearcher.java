package ee.pri.rl.indexer.cli;

import java.util.Set;

import ee.pri.rl.indexer.model.IndexedFile;
import ee.pri.rl.indexer.web.service.IndexerService;
import ee.pri.rl.indexer.web.service.ServiceException;
import ee.pri.rl.indexer.web.service.query.QueryException;

/**
 * Käsurealt failide otsimist võimaldav vahend.
 * 
 * @author raivo
 */
public class CliSearcher {

	public static void main(String[] args) throws QueryException, ServiceException {
		if (args.length == 0) {
			System.out.println("Sisesta otsingusõne argumendina");
		} else {
			IndexerService service = new IndexerService();
			Set<IndexedFile> files = service.search(args[0]);
			for (IndexedFile file: files) {
				System.out.println(file.getName());
			}
		}
	}

}
