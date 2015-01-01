package ee.pri.rl.cliindexer.data;

import ee.pri.rl.btree.Description;
import ee.pri.rl.btree.tree.BTree;
import ee.pri.rl.btree.tree.EchoCallback;
import ee.pri.rl.btree.tree.Node;
import ee.pri.rl.btree.tree.Row;
import ee.pri.rl.cliindexer.model.Word;

/**
 * Sõnade andmebaas.
 * 
 * @author raivo
 */
public class WordDatabase {
	private BTree tree;
	private Description description;

	public WordDatabase(String filename) {
		description = WordDescription.getDescription();
		tree = new BTree(description, filename);
		if (tree.getRoot() == null) {
			System.out.println("Fail oli tühi");
			Node root = new Node(description);
			tree.setRoot(root);
			tree.saveRoot();	
		}
	}
	
	public void saveWord(Word word) {
		Row row = new Row(description);
		row.save("contents", word.getContents());
		row.save("id", word.getId());
		row.save("count", word.getCount());
		tree.saveRow(row);
	}
	
	public Word getWord(String key) {
		Row row = tree.getRow(key);
		if (row == null) {
			return null;
		} else {
			Word word = new Word(row.getString("contents"), row.getInt("id"), row.getInt("count"));
			return word;
		}
	}

	public void dump() {
		EchoCallback echo = new EchoCallback(description);
		tree.traverseTree(echo);
	}
	
}
