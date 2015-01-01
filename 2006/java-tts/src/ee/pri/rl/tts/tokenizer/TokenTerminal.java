/**
 * 
 */
package ee.pri.rl.tts.tokenizer;

import ee.pri.rl.tts.constructor.model.grammar.Terminal;

/**
 * Tokeniseermise järel saadud terminalide listi element.
 * Sisaldab lisaks terminaalile ka selle tegelikku tähistust
 * (identifikaator-identifikaatori nimi) - actualNotation.
 * @author raivo
 */
public class TokenTerminal extends Terminal {
	private String actualNotation;

	public String getActualNotation() {
		return actualNotation;
	}

	public void setActualNotation(String actualNotation) {
		this.actualNotation = actualNotation;
	}
}
