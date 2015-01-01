package ee.pri.rl.tokenizer;

import java.io.Serializable;

/**
 * Token that represents part of the text.
 */

public class Token implements Serializable {
	private static final long serialVersionUID = 6385492404936132412L;
	
	private String name;
	private String contents;
	private int lineNumber;
	
	public Token(String name, String contents, int lineNumber) {
		this.name = name;
		this.contents = contents;
		this.lineNumber = lineNumber;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public int getLineNumber() {
		return lineNumber;
	}

	public void setLineNumber(int lineNumber) {
		this.lineNumber = lineNumber;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Token) {
			Token other = (Token) obj;
			return other.getName().equals(name) && (other.getContents() == null ? contents == null : other.getContents().equals(contents));
		}
		return false;
	}

	@Override
	public String toString() {
		return name + ":" + contents + ":" + lineNumber;
	}
}
