package ee.pri.rl.cliindexer.data;

import ee.pri.rl.btree.ColumnDescription;
import ee.pri.rl.btree.Description;

/**
 * @author raivo
 *
 */
public class WordFileDescription {
	public static Description getDescription() {
		Description description = new Description(30);
		ColumnDescription key = new ColumnDescription("word_id");
		description.addColumnDescription(key);
		description.setKey(key);
		description.addColumnDescription(new ColumnDescription("file_id"));
		return description;
	}
}
