package ee.pri.rl.wiki.transform.xhtml;

import ee.pri.rl.wiki.transform.StringTransform;
import ee.pri.rl.wiki.transform.StringTransformer;

/**
 * Transforms node tree into XHTML code.
 */

public class WikiXHTMLTransformer extends StringTransformer {
	public WikiXHTMLTransformer() {
		addTransform("nPage", new StringTransform());
		addTransform("tHeading1", new StringTransform("<h1>", "</h1>\n"));
		addTransform("tHeading2", new StringTransform("<h2>", "</h2>\n"));
		addTransform("tHeading3", new StringTransform("<h3>", "</h3>\n"));
		addTransform("nSection", new StringTransform("<p>", "</p>\n"));
		addTransform("tText", new StringTransform(" ", " "));
		addTransform("tItalic", new StringTransform("<i>", "</i>"));
		addTransform("nLink", new StringTransform("<a", "</a>"));
		addTransform("tLink", new StringTransform(" href=\"", "\">"));
		addTransform("tLinkLabel", new StringTransform());
		addTransform("nImage", new StringTransform("<img alt=\"image\"", " />"));
		addTransform("tImage", new StringTransform(" src=\"", "\""));
		addTransform("tImageAlign", new StringTransform(" align=\"", "\""));
		addTransform("tImageCSS", new StringTransform(" class=\"", "\""));
		addTransform("tTex", new StringTransform());
		addTransform("nList", new StringTransform("<ul>", "</ul>\n"));
		addTransform("nListItem", new StringTransform("<li>", "</li>\n"));
		addTransform("tBold", new StringTransform("<b>", "</b>"));
		addTransform("tHorisontalLine", new StringTransform("<hr />", ""));
		addTransform("tPreformatted", new PreNodeStringTransform());
		addTransform("nTable", new StringTransform("<table>\n", "</table>\n"));
		addTransform("nTableRow", new StringTransform("<tr>", "</tr>\n"));
		addTransform("nTableCell", new StringTransform("<td>", "</td>"));
		addTransform("tUnderlined", new StringTransform("<u>", "</u>"));
		addTransform("tStrike", new StringTransform("<span style=\"text-decoration: line-through;\">", "</span>"));
		addTransform("nList2", new StringTransform("\n\t<ul>", "\t</ul>\n"));
		addTransform("nList2Item", new StringTransform("\t<li>", "</li>\n"));
	}
}
