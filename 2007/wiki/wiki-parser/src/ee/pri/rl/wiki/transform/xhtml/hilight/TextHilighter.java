package ee.pri.rl.wiki.transform.xhtml.hilight;

import java.util.LinkedList;
import java.util.List;

/**
 * Very simple and primitive text hilighter.
 */

public class TextHilighter {
	private class StyleEntry {
		private String text;
		private HilighterStyle style;
		
		public StyleEntry(String text, HilighterStyle style) {
			this.text = text;
			this.style = style;
		}

		public HilighterStyle getStyle() {
			return style;
		}

		public String getText() {
			return text;
		}
	}
	private List<StyleEntry> styles;
	
	public TextHilighter() {
		styles = new LinkedList<StyleEntry>();
	}
	
	public void add(String text, HilighterStyle style) {
		styles.add(new StyleEntry(text, style));
	}
	
	public String apply(String input) {
		for (StyleEntry entry : styles) {
			input = input.replace(entry.getText(), entry.getStyle().processContents(entry.getText()));
		}
		return input;
	}
}
