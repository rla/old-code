package ee.pri.rl.indexer.model;

import java.util.Set;

/**
 * Otsingusõne, kasutatakse otsimiskontrolleris.
 * 
 * @author raivo
 */
public class Search {
	public static final int TYPE_CONTENTS = 1;
	public static final int TYPE_NAME = 2;
	
	private String searchString;
	private Set<IndexedFile> files;
	private long time;
	private int type;

	public long getTime() {
		return time;
	}

	public void setTime(long time) {
		this.time = time;
	}

	public Set<IndexedFile> getFiles() {
		return files;
	}

	public void setFiles(Set<IndexedFile> files) {
		this.files = files;
	}

	public String getSearchString() {
		return searchString;
	}

	public void setSearchString(String searchString) {
		this.searchString = searchString;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}
}
