/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Stack;

import ee.pri.rl.tts.constructor.model.grammar.Grammar;
import ee.pri.rl.tts.constructor.model.grammar.NonTerminal;
import ee.pri.rl.tts.constructor.model.grammar.PrecedenceRelation;
import ee.pri.rl.tts.constructor.model.grammar.Word;
import ee.pri.rl.tts.parser.tree.ParseTree;
import ee.pri.rl.tts.tokenizer.TokenTerminal;

/**
 * Lihtne pööratava eelnevusgrammatika parser.
 * Hetkel veel analüüsipuud ei koostata.
 * Analüsaator ei tööta, kui grammatika produktsioonide hulgas
 * leidub kaks erinevat produktsiooni, millel on ühesugune parem pool.
 * @author raivo
 */
public class SimplePrecedenceParser implements Parser {
	private Grammar grammar;
	
	public SimplePrecedenceParser(Grammar grammar) {
		this.grammar = grammar;
	}
	
	public ParseTree parse(List<TokenTerminal> tokens) throws ParserException {
		/*Sümbolite magasin*/
		Stack<Word> wordStack = new Stack<Word>();
		/*Relatsioonide magasin*/
		Stack<PrecedenceRelation> relationStack = new Stack<PrecedenceRelation>();
		
		int i = 0;
		
		/*Paneme algussümboli magasini*/
		wordStack.add(tokens.get(i));
		
		boolean ready = false;
		while (!ready) {
			/*Suurendame i-d ühe võrra*/
			i++;
			/*Võtame sõna token kohalt i*/
			TokenTerminal token = tokens.get(i);
			/*Kontrollime relatsiooni magasini suurima elemendi ja token'i vahel*/
			PrecedenceRelation relation = (PrecedenceRelation)(grammar.getPrecedenceMatrix().get(wordStack.peek(), token));
			System.out.println("Kontrollime relatsiooni sümbolite " + wordStack.peek() + " ja " + token + " vahel.");
			System.out.println("Relatsioon on " + relation);
			/*Kui relatsioon puudub, lõpetame veateatega*/
			if (relation == null) {
				//TODO: kirjutada normaalne veateade.
				throw new ParserException("Kohakuti mittesobivad elemendid!");
			/*Kui relatsioon on "ajastub"..*/
			} else if (relation.isTimes()) {
				/*..ja sümbol on lõpu sümbol*/
				if (token.getNotation().equals("#")) {
					System.out.println("parsimise lõpp");
					break;
				} else {
					/*Paneme sõna ja relatsiooni vastvatesse magasinidesse*/
					wordStack.push(token);
					relationStack.push(relation);
				}
			/*Kui relatsioon on "eelneb"*/
			} else if (relation.isPreceeds()) {
				/*Paneme token'i magasini*/
				wordStack.push(token);
				/*Paneme relatsiooni magasini*/
				relationStack.push(relation);
			/*Kui relatsioon on "järgneb"*/
			} else if (relation.isFollows()) {
				/* Liigume tagasi mööda magasine, kuni jõuame relatsioonini "eelneb",
				 * paneme kirja vahepealsed sõnad. */
				List<Word> list = new ArrayList<Word>();
				while (true) {
					Word poppedWord = wordStack.pop();
					System.out.println("poppedWord " + poppedWord);
					PrecedenceRelation poppedRelation = relationStack.pop();
					System.out.println("poppedRelation " + poppedRelation);
					list.add(poppedWord);
					if (poppedRelation.isPreceeds()) {
						/* Leiame produktsiooni vasaku poole, mille paremale poolele
						 * vastab hetkel saadud järjend. NB! Siin on järjend tagurpidi,
						 * sellepärast pöörame ta ümber. */
						Collections.reverse(list);
						/*Listi tegemine sõneks silumise eesmärgil*/
						StringBuffer buffer = new StringBuffer();
						for (Word word : list) {
							buffer.append(word.toString());
						}
						String base = buffer.toString();
						NonTerminal nonTerminal = grammar.getNonTerminal(list);
						if (nonTerminal == null) {
							/*Ei õnnestunud redutseerida*/
							System.out.println("Magasini sisu:");
							while (!wordStack.empty()) {
								System.out.print(wordStack.pop());
							}
							throw new ParserException("Lausevormi baasi " + base + " ei õnnestunud redutseerida!");
						} else {
							System.out.println("Redutseerisime lausevormi baasi " + base.toString() + " mitteterminaliks " + nonTerminal);
						}
						/*Leiame uue relatsiooni*/
						relation = (PrecedenceRelation)(grammar.getPrecedenceMatrix().get(wordStack.peek(), nonTerminal));
						if (relation == null) {
							/* Redutseerimise tulemusena saadud sõna ja eelmise magasini
							 * elemendi vahel puudub relatsioon - viga. */
							throw new ParserException("Kohakuti mittesobivad elemendid: " + wordStack.peek() + " ja " + nonTerminal + "!");
						}
						wordStack.push(nonTerminal);
						relationStack.push(relation);
						/* Lähme ühe sammu võrra tagasi, et viimase sõna
						 * kontroll toimuks uuesti pärast redutseerimist. */
						i--;
						break;
					}
				}
			}
			
		}
		
		return null;
	}
	
}
