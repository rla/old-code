/**
 * 
 */
package ee.pri.rl.tts.tokenizer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.tts.constructor.model.grammar.Grammar;
import ee.pri.rl.tts.constructor.model.grammar.Terminal;
import ee.pri.rl.tts.util.Reader;

/**
 * Tokenisaator, mis ei kasuta sisseehitatud süsteemi
 * identifikaatorite ja konstantide eraldamiseks.
 * @author raivo
 */
public class GeneralTokenizer implements Tokenizer {
	private Grammar grammar;
	
	public GeneralTokenizer(Grammar grammar) {
		this.grammar = grammar;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.tts.tokenizer.Tokenizer#tokenize(java.lang.String)
	 */
	public List<TokenTerminal> tokenize(String input) throws TokenizeException {
		List<TokenTerminal> tokens = new ArrayList<TokenTerminal>();
		StringBuffer buffer = new StringBuffer();
		
		for (int i = 0; i < input.length(); i++) {
			char ch = input.charAt(i);
			/*Vahesümbolite ignoreerimine*/
			if (ch != ' ' && ch != '\t' && ch != '\n' && ch != '\r') {
				buffer.append(ch);
			} else {
				continue;
			}
			
			/*Kontrollime, kas hetke puhvri sisu vastab mingile terminalile.*/
			Terminal terminal = grammar.getTerminal(buffer.toString()); 
			if (terminal != null) {
				buffer.delete(0, buffer.length());
				TokenTerminal tokenTerminal = new TokenTerminal();
				tokenTerminal.setNotation(terminal.getNotation());
				tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()).toString());
				tokens.add(tokenTerminal);
			}
			
		}
		
		return tokens;
	}

	/* (non-Javadoc)
	 * @see ee.pri.rl.tts.tokenizer.Tokenizer#tokenizeFile(java.lang.String)
	 */
	public List<TokenTerminal> tokenizeFile(String filename) throws TokenizeException {
		String string;
		try {
			string = Reader.read(filename);
		} catch (IOException e) {
			throw new TokenizeException("Faili " + filename + " ei leitud!");
		}
		return tokenize(string);
	}

}
