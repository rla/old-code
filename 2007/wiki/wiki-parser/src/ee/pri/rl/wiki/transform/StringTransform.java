package ee.pri.rl.wiki.transform;

public class StringTransform {
	private static final String EMPTY_STRING = "";
	
	protected String textBefore;
	protected String textAfter;
	
	public StringTransform() {
		this(null, null);
	}
	
	public StringTransform(String textBefore, String textAfter) {
		this.textBefore = textBefore;
		this.textAfter = textAfter;
	}

	public String getTextAfter() {
		return textAfter == null ? EMPTY_STRING : textAfter;
	}

	public void setTextAfter(String textAfter) {
		this.textAfter = textAfter;
	}

	public String getTextBefore() {
		return textBefore == null ? EMPTY_STRING : textBefore;
	}

	public void setTextBefore(String textBefore) {
		this.textBefore = textBefore;
	}
	
	/**
	 * Process node's string contents.
	 */
	
	public String processContents(String contents) {
		return contents;
	}
}
