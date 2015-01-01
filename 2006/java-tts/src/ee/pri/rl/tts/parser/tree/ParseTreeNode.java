/**
 * 
 */
package ee.pri.rl.tts.parser.tree;

import ee.pri.rl.tts.constructor.model.grammar.Word;

/**
 * Analüüsipuu tipp.
 * 
 * @author raivo
 */
public class ParseTreeNode {
	/* Tipuga seotud sümbol */
	private Word word;

	/* Alampuu juur */
	private ParseTreeNode down;

	/* Ülemine tipp */
	private ParseTreeNode up;

	/* Parempoolne naaber */
	private ParseTreeNode right;
	
	public ParseTreeNode() {
		word = null;
		down = null;
		up = null;
		right = null;
	}

	public ParseTreeNode getDown() {
		return down;
	}

	public void setDown(ParseTreeNode down) {
		this.down = down;
	}

	public ParseTreeNode getRight() {
		return right;
	}

	public void setRight(ParseTreeNode right) {
		this.right = right;
	}

	public ParseTreeNode getUp() {
		return up;
	}

	public void setUp(ParseTreeNode up) {
		this.up = up;
	}

	public Word getWord() {
		return word;
	}

	public void setWord(Word word) {
		this.word = word;
	}
}
