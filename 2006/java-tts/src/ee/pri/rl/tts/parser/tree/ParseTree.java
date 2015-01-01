/**
 * 
 */
package ee.pri.rl.tts.parser.tree;

/**
 * Programmiteksti analüüsil saadab analüüsipuu.
 * @author raivo
 */
public class ParseTree {
	/*Analüüsipuu juur*/
	private ParseTreeNode root;
	
	public ParseTree() {
		root = null;
	}

	public ParseTreeNode getRoot() {
		return root;
	}

	public void setRoot(ParseTreeNode root) {
		this.root = root;
	}
}
