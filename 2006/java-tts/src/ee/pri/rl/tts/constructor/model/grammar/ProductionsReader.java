/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import ee.pri.rl.tts.util.Reader;

/**
 * @author raivo
 * Loeb failist produktsioonid, tagastab produktsioonide hulga.
 */
public class ProductionsReader {
	
	/*Produktsioonide hulga lugemiseks vajalikud olekud*/
	
    private static final int START = 0;            //algolek
    private static final int LITERAL_TERM = 3;     //literaal kujul `midagi', termi osas
    private static final int LITERAL_TERM_END = 4; //termi literaali lõpp
    private static final int RIGHT_ARROW = 5;      //nool ->
    private static final int DEFINITION = 6;       //nool on lõppenud
    private static final int DEFINITION_END = 7;   //definitsioon on lõppenud (reavahetusega)
    
    /*Produktsiooni parema poole lugemiseks vajalikud olekud*/
    
	private static final int NON_TERMINAL = 8;
	private static final int TERMINAL = 9;
    
	public static Set<Production> read(String filename) throws GrammarException {
		
		try {
			return parse(Reader.read(filename));
		} catch (IOException e) {
			throw new GrammarException(e);
		}

	}
	
	/**
	 * Sõnena antud produktsioonide parsimine
	 * sisemisele kujule.
	 */
	private static Set<Production> parse(String input) {
		Set<Production> productions = new HashSet<Production>();
	
		/*Algolek*/
        int state = START;
        StringBuffer buffer = new StringBuffer();
        /*Hetkel parsitav produktsioon*/
        Production currentProduction = null;
        
        for (int i = 0; i < input.length(); i++)  {
            char ch = input.charAt(i);
            switch (state) {
            case START: {
                if (ch == '`') {
                    state = LITERAL_TERM;
                }
                continue;
            }
            case LITERAL_TERM: {
                if (ch == '\'') {
                    currentProduction = new Production();
                    NonTerminal nonTerminal = new NonTerminal();
                    nonTerminal.setNotation(buffer.toString());
                    currentProduction.setNonTerminal(nonTerminal);
                    buffer.delete(0, buffer.length());
                    state = LITERAL_TERM_END;
                } else {
                    buffer.append(ch);
                }
                continue;
            }
            case LITERAL_TERM_END: {
                if (ch == '-') {
                    state = RIGHT_ARROW;
                }
                continue;
            }
            case RIGHT_ARROW: {
                if (ch == '>') {
                    state = DEFINITION;
                }
                continue;
            }
            case DEFINITION: {
                if (ch == '\n') {
                	Definition definition = new Definition();
                	definition.setWords(parseWords(buffer.toString().trim()));
                    currentProduction.setDefinition(definition);
                    
                    productions.add(currentProduction);
                    
                    NonTerminal currentNonTerminal = currentProduction.getNonTerminal();
                    currentProduction = new Production();
                    currentProduction.setNonTerminal(currentNonTerminal);
                    currentProduction.setDefinition(null);
                    
                    buffer.delete(0, buffer.length());
                    state = DEFINITION_END;
                } else {
                    buffer.append(ch);
                }
                continue;
            }
            case DEFINITION_END: {
                if (ch == '`') {
                	if (currentProduction.getDefinition() != null) {
                		productions.add(currentProduction);
                	}
                    state = LITERAL_TERM;
                } else if (ch == '-') {
                    state = RIGHT_ARROW;
                }
                continue;
            }
            }
        }
        
        if (state == DEFINITION_END) {
        	if (currentProduction.getDefinition() != null) {
        		productions.add(currentProduction);
        	}
        }
		
		return productions;
	}
	
	/**
	 * Parsib vasaku poole sõnadeks.
	 * 24.03.06 - Optimeeritud - piisab vaid kahest olekust.
	 */
	private static List<Word> parseWords(String input) {
		List<Word> words = new ArrayList<Word>();
		StringBuffer buffer = new StringBuffer();
		int state = TERMINAL;
		for (int i = 0; i < input.length(); i++) {
			char ch = input.charAt(i);
			switch (state) {
			case NON_TERMINAL: {
				if (ch == '\'') {
					state = TERMINAL;
					Word word = new NonTerminal();
					word.setNotation(buffer.toString());
					words.add(word);
					buffer.delete(0, buffer.length());
				} else {
					buffer.append(ch);
				}
				continue;
			}
			case TERMINAL: {
				if (ch == '`') {
					state = NON_TERMINAL;
					if (buffer.length() > 0) {
						Word word = new Terminal();
						word.setNotation(buffer.toString());
						words.add(word);
						buffer.delete(0, buffer.length());
					}
				} else if (ch == ' ') {
					if (buffer.length() > 0) {
						Word word = new Terminal();
						word.setNotation(buffer.toString());
						words.add(word);
						buffer.delete(0, buffer.length());
					}
				} else {
					buffer.append(ch);
				}
				continue;
			}
			}
		}
		
		if ((state == START || state == TERMINAL ) && buffer.length() > 0) {
			Word word = new Terminal();
			word.setNotation(buffer.toString());
			words.add(word);
		}
		
		return words;
	}

}
