package ee.pri.rl.indexer.indexing;

import java.util.HashSet;
import java.util.Set;

import ee.pri.rl.indexer.model.Word;

/**
 * Mitmesuguse allika sõnadeks jaotaja.
 * 
 * @author raivo
 */
public class Wordizer {

	/**
	 * Kontrollib, kas etteantud tähemärk ch on sõnas lubatud.
	 */
	private static boolean isAllowed(char ch) {
		ch = Character.toLowerCase(ch);
		return (ch == 'a' || ch == 'b' || ch == 'c' || ch == 'd' || ch == 'e'
				|| ch == 'f' || ch == 'g' || ch == 'h' || ch == 'i'
				|| ch == 'j' || ch == 'k' || ch == 'l' || ch == 'm'
				|| ch == 'n' || ch == 'o' || ch == 'p' || ch == 'q'
				|| ch == 'r' || ch == 's' || ch == 't' || ch == 'u'
				|| ch == 'v' || ch == 'w' || ch == 'x' || ch == 'y'
				|| ch == 'z');
		// || ch == 'õ' || ch == 'ä' || ch == 'ö' || ch == 'ü');
	}

	/**
	 * Leiab, kas etteantud tähemärk on eraldaja.
	 */
	private static boolean isSeparator(char ch) {
		return !isAllowed(ch); 
		/*(ch == '\n' || ch == '\r' || ch == '\t' || ch == ':'
				|| ch == ';' || ch == '=' || ch == '(' || ch == ')'
				|| ch == '[' || ch == ']' || ch == '{' || ch == '}'
				|| ch == '_' || ch == '-' || ch == ' ' || ch == '.'
				|| ch == '?' || ch == '!' || ch == '"' || ch == '\''
				|| ch == '#' || ch == '&' || ch == '|' || ch == ','
				|| ch == '/' || ch == '<' || ch == '>' || ch == '*'
				|| ch == '$' || ch == '`' || (ch >= '0' && ch <= '9'));
				*/
	}

	public static Set<Word> wordizeString(char[] buffer) {
		Set<Word> words = new HashSet<Word>();
		char[] word = new char[20];
		int wordPos = 0;
		for (int i = 0; i < buffer.length; i++) {
			char ch = buffer[i];
			if (isSeparator(ch)) {
				if (wordPos >= 3) {
					words.add(new Word(new String(word, 0, wordPos)
							.toLowerCase()));
					wordPos = 0;
				} else {
					wordPos = 0;
				}
			} else {
				if (wordPos < 20) {
					word[wordPos] = ch;
					wordPos++;
				} else {
					wordPos = 0;
				}
			}
		}
		return words;
	}
}
