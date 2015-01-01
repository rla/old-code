package ee.pri.rl.wiki.transform.xhtml.hilight;

import ee.pri.rl.wiki.transform.StringTransform;

/**
 * Style class for hilighting string part with xhtml.
 */

public class HilighterStyle extends StringTransform {
	
	public HilighterStyle(String textBefore, String textAfter) {
		super(textBefore, textAfter);
	}

	@Override
	public String processContents(String contents) {
		return textBefore + contents + textAfter;
	}
	
	
}
