/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

/**
 * @author raivo
 * Produktsioon, sisaldab ühte mitteterminali ja selle definitsiooni.
 */
public class Production {
	private NonTerminal nonTerminal;
	private Definition definition;
	
	public Definition getDefinition() {
		return definition;
	}
	public void setDefinition(Definition definition) {
		this.definition = definition;
	}
	public NonTerminal getNonTerminal() {
		return nonTerminal;
	}
	public void setNonTerminal(NonTerminal nonTerminal) {
		this.nonTerminal = nonTerminal;
	}
	public String toString() {
		StringBuffer buffer = new StringBuffer();
		buffer.append(nonTerminal.toString() + " -> " + definition.toString());
		return buffer.toString();
	}
}
