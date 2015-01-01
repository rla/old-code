/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.Stack;

import ee.pri.rl.tts.constructor.model.grammar.PrecedenceRelation;

/**
 * @author raivo
 */
public class RelationStack {
	private Stack<PrecedenceRelation> relations;
	
	public RelationStack() {
		relations = new Stack<PrecedenceRelation>();
	}
	
	public PrecedenceRelation top() {
		if (relations.isEmpty()) {
			return null;
		} else {
			return relations.peek();
		}
	}
	
	public void push(PrecedenceRelation relation) {
		relations.push(relation);
	}
	
	public PrecedenceRelation pop() {
		return relations.pop();
	}
	
	public String toString() {
		return relations.toString();
	}
}
