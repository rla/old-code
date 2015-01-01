package ee.pri.rl.wiki.transform.xhtml;

import ee.pri.rl.wiki.transform.StringTransform;
import ee.pri.rl.wiki.transform.xhtml.hilight.HilighterStyle;
import ee.pri.rl.wiki.transform.xhtml.hilight.TextHilighter;

/**
 * Transform for processing pre node of wiki text.
 */

public class PreNodeStringTransform extends StringTransform {
	private TextHilighter textHilighter;
	
	public PreNodeStringTransform() {
		super("<pre>", "</pre>");
		textHilighter = new TextHilighter();
		HilighterStyle bold = new HilighterStyle("<b>", "</b>");
		HilighterStyle italic = new HilighterStyle("<i>", "</i>");
		HilighterStyle blue = new HilighterStyle("<span style=\"color: blue\">", "</span>");
		HilighterStyle green = new HilighterStyle("<span style=\"color: green\">", "</span>");
		HilighterStyle red = new HilighterStyle("<span style=\"color: red; font-weight: bold\">", "</span>");
		textHilighter.add("+", blue);
		textHilighter.add("-", blue);
		textHilighter.add("*", blue);
		textHilighter.add("\\", blue);
		textHilighter.add("%", blue);
		textHilighter.add("if", bold);
		textHilighter.add("then", bold);
		textHilighter.add("else", bold);
		textHilighter.add("begin", bold);
		textHilighter.add("end;", bold);
		textHilighter.add("throw", bold);
		textHilighter.add("error", red);
		textHilighter.add("return", bold);
		textHilighter.add("procedure", bold);
		textHilighter.add("function", bold);
		textHilighter.add("Input:", italic);
		textHilighter.add("Output:", italic);
		textHilighter.add("==", green);
		textHilighter.add("=>", green);
		textHilighter.add("<=", green);
		textHilighter.add("!=", green);
		textHilighter.add("\\=", green);
		textHilighter.add("/=", green);
		textHilighter.add("=/=", green);
		textHilighter.add("=\\=", green);
		textHilighter.add("<>", green);
		textHilighter.add(":=", red);
	}

	@Override
	public String processContents(String contents) {
		return textHilighter.apply(contents).replace("\t", "  ");
	}
}
