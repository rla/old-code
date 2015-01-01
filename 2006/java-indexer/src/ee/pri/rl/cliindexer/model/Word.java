package ee.pri.rl.cliindexer.model;

/**
 * Sõnade klass.
 * 
 * @author raivo
 */
public class Word {
	private int count;
	private int id;
	private String contents;
	
	public Word(String contents, int id, int count) {
		this.count = count;
		this.id = id;
		this.contents = contents;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String toString() {
		return contents;
	}
	
}
