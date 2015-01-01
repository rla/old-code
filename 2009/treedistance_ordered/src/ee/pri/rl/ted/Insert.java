package ee.pri.rl.ted;

public class Insert extends Edit {
	public final char value;
	public final int at;
	
	public Insert(int at, char value) {
		this.at = at;
		this.value = value;
	}

}
