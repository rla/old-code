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
 * Lihtne tokenisaator sõne teisendamiseks terminalide listiks.
 * @author raivo
 */
public class SimpleTokenizer implements Tokenizer {
	private Grammar grammar;
	
	public SimpleTokenizer(Grammar grammar) {
		this.grammar = grammar;
	}
	
	/**
	 * Sõne tokeniseerimine. Algoritmi tööpõhimõte:
	 * sõne algusest lisatakse puhvrisse 1 sümbol, kontrollitakse
	 * kas selliselt tähistatud terminal leidub, ja kui
	 * leidub, siis lisatakse tagastatavasse terminalide listi
	 * vastav terminal ning puhver tühjendatakse, kui ei leidu,
	 * siis lisatakse järgmine sümbol.
	 * Tühikuid ja muid vahesümboleid ignoreeritakse.
	 * Identifikaatorid ja konstandid eraldatakse tokeniseerimise käigus.
	 * (Muidu tuleks nad kirjeldada produktsioonide abil)
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
				/*Kontrollime, kas hetke puhvri sisu vastab mingile terminalile.*/
				Terminal terminal = grammar.getTerminal(buffer.toString()); 
				if (terminal != null) {
					System.out.println("Puhvri sisule " + buffer.toString() + " vastab " + terminal);
					buffer.delete(0, buffer.length());
					TokenTerminal tokenTerminal = new TokenTerminal();
					tokenTerminal.setNotation(terminal.getNotation());
					tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()).toString());
					tokens.add(tokenTerminal);
				}
				/* Kas tegemist konstandiga?
				 * Kui hetkel on puhvri esimene sümbol number
				 * ja iga järgmine on number, siis on meil konstant.*/
				if (buffer.length() > 0 && isDigit(buffer.charAt(0))) {
					if (isDigit(ch)) {
						continue;
					} else {
						/* Saime midagi muud peale numbri, eraldame numbri osa
						 * Kontrollime ka, kas grammatika üldse lubab konstante. */
						terminal = grammar.getTerminal("#c#");
						if (terminal == null) {
							/*Huh, grammatika ei toeta konstante*/
							throw new TokenizeException("Etteantud grammatika ei toeta konstante.");
						}
						TokenTerminal tokenTerminal = new TokenTerminal();
						tokenTerminal.setNotation(terminal.getNotation());
						tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()-1).toString());
						tokens.add(tokenTerminal);
						/*Tühjendame puhveri*/
						buffer.delete(0, buffer.length());
					}
				}
				/* Kui puhvri hetke sisu ei vastanud ühelegi terminalile, kontrollime
				 * ega tegemist pole konstandiga */
				if (buffer.length() > 0 && isAlpha(buffer.charAt(0))) {
					System.out.println("isAlpha: " + buffer.charAt(0));
					if (isAlpha(ch) || isDigit(ch)) {
						System.out.println("isAlpha || isDigit: " + ch);
						continue;
					} else {
						System.out.println("ELSE");
						/* Saime midagi muud peale tähe, erldame tähtedest koosneva osa.
						 * Kontrollime, kas grammatika toetab identifikaatoreid. */
						terminal = grammar.getTerminal("#i#");
						if (terminal == null) {
							/*Huh, grammatika ei toeta identifikaatoreid*/
							throw new TokenizeException("Etteantud grammatika ei toeta identifikaatoreid!");
						}
						TokenTerminal tokenTerminal = new TokenTerminal();
						tokenTerminal.setNotation(terminal.getNotation());
						tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()-1).toString());
						tokens.add(tokenTerminal);
						System.out.println("Added " + tokenTerminal);
						buffer.delete(0, buffer.length());
					}
				}
				continue;
			}
			
			System.out.println("Puhver: " + buffer.toString());
			
			/* Kas tegemist konstandiga?
			 * Kui hetkel on puhvri esimene sümbol number
			 * ja iga järgmine on number, siis on meil konstant.*/
			if (buffer.length() > 0 && isDigit(buffer.charAt(0))) {
				if (isDigit(ch)) {
					continue;
				} else {
					/* Saime midagi muud peale numbri, eraldame numbri osa
					 * Kontrollime ka, kas grammatika üldse lubab konstante. */
					Terminal terminal = grammar.getTerminal("#c#");
					if (terminal == null) {
						/*Huh, grammatika ei toeta konstante*/
						throw new TokenizeException("Etteantud grammatika ei toeta konstante.");
					}
					TokenTerminal tokenTerminal = new TokenTerminal();
					tokenTerminal.setNotation(terminal.getNotation());
					tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()-1).toString());
					tokens.add(tokenTerminal);
					/*Tühjendame puhveri*/
					buffer.delete(0, buffer.length());
					/*Lisame sinna esimese mittenumbri*/
					buffer.append(ch);
				}
			}
			
			/*Kontrollime, kas hetke puhvri sisu vastab mingile terminalile.*/
			Terminal terminal = grammar.getTerminal(buffer.toString()); 
			if (terminal != null) {
				System.out.println("Puhvri sisule " + buffer.toString() + " vastab " + terminal);
				buffer.delete(0, buffer.length());
				TokenTerminal tokenTerminal = new TokenTerminal();
				tokenTerminal.setNotation(terminal.getNotation());
				tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()).toString());
				tokens.add(tokenTerminal);
			}
			
			/* Kui puhvri hetke sisu ei vastanud ühelegi terminalile, kontrollime
			 * ega tegemist pole konstandiga */
			if (buffer.length() > 0 && isAlpha(buffer.charAt(0))) {
				System.out.println("isAlpha: " + buffer.charAt(0));
				if (isAlpha(ch) || isDigit(ch)) {
					System.out.println("isAlpha || isDigit: " + ch);
					continue;
				} else {
					System.out.println("ELSE");
					/* Saime midagi muud peale tähe, erldame tähtedest koosneva osa.
					 * Kontrollime, kas grammatika toetab identifikaatoreid. */
					terminal = grammar.getTerminal("#i#");
					if (terminal == null) {
						/*Huh, grammatika ei toeta identifikaatoreid*/
						throw new TokenizeException("Etteantud grammatika ei toeta identifikaatoreid!");
					}
					TokenTerminal tokenTerminal = new TokenTerminal();
					tokenTerminal.setNotation(terminal.getNotation());
					tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()-1).toString());
					tokens.add(tokenTerminal);
					System.out.println("Added " + tokenTerminal);
					buffer.delete(0, buffer.length());			
					buffer.append(ch);
				}
			}
			
			/*Kontrollime, kas hetke puhvri sisu vastab mingile terminalile.*/
			terminal = grammar.getTerminal(buffer.toString()); 
			if (terminal != null) {
				System.out.println("Puhvri sisule " + buffer.toString() + " vastab " + terminal);
				buffer.delete(0, buffer.length());
				TokenTerminal tokenTerminal = new TokenTerminal();
				tokenTerminal.setNotation(terminal.getNotation());
				tokenTerminal.setActualNotation(buffer.substring(0, buffer.length()).toString());
				tokens.add(tokenTerminal);
			}
			
		}
		
		return tokens;
	}
		
	/**
	 * Tagastab true, kui etteantud sümbol on number.
	 */
	private boolean isDigit(char ch) {
		if (ch >= '0' && ch <= '9') {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Tagastab true, kui etteantud sümbol on tähemärk.
	 */
	private boolean isAlpha(char ch) {
		if (ch >= 'a' && ch <= 'z' || ch >= 'A' && ch <= 'Z') {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Loeb sõne failist ja seejärel tokeniseerib ta.
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
