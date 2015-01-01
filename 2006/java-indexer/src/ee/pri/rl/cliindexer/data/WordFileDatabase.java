package ee.pri.rl.cliindexer.data;

import ee.pri.rl.btree.Description;
import ee.pri.rl.btree.tree.BTree;
import ee.pri.rl.btree.tree.Node;
import ee.pri.rl.btree.tree.Row;
import ee.pri.rl.common.collection.pair.IntPair;

/**
 * Sõna - faili seost hoidev andmebaas.
 * 
 * @author raivo
 */
public class WordFileDatabase {
	private BTree tree;
	private Description description;
	
	public WordFileDatabase(String filename) {
		description = WordFileDescription.getDescription();
		tree = new BTree(description, filename);
		if (tree.getRoot() == null) {
			System.out.println("Fail oli tühi");
			Node root = new Node(description);
			tree.setRoot(root);
			tree.saveRoot();	
		}
	}
	
	public void saveIntPair(IntPair intPair) {
		Row row = new Row(description);
		row.save("word_id", intPair.first);
		row.save("file_id", intPair.second);
		tree.saveRow(row);
	}
	
	public IntPair getIntPair(int key) {
		IntPair intPair = new IntPair();
		Row row = tree.getRow(key);
		intPair.first = row.getInt("word_id");
		intPair.second = row.getInt("file_id");
		return intPair;
	}
	
}
