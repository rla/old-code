package ee.pri.rl.indexer.web.controller.beans;

import java.io.File;

/**
 * Uba, mis sisaldab infot hetkel indekseeritava kausta kohta.
 * 
 * @author raivo
 */
public class IndexingBean {
	public File directory;
	public File[] files;

	public File[] getFiles() {
		return files;
	}

	public void setFiles(File[] files) {
		this.files = files;
	}

	public File getDirectory() {
		return directory;
	}

	public void setDirectory(File directory) {
		this.directory = directory;
		this.files = directory.listFiles();
	}
}
