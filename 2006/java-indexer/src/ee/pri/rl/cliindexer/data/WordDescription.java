package ee.pri.rl.cliindexer.data;

import ee.pri.rl.btree.ColumnDescription;
import ee.pri.rl.btree.Description;

/**
 * Sõnade andmebaasi kirjeldus.
 * 
 * @author raivo
 */
public class WordDescription {
	public static Description getDescription() {
		Description description = new Description(30);
		ColumnDescription key = new ColumnDescription("contents", ColumnDescription.TYPE_STRING, 30);
		description.addColumnDescription(key);
		description.setKey(key);
		description.addColumnDescription(new ColumnDescription("id"));
		description.addColumnDescription(new ColumnDescription("count"));
		return description;
	}
}
