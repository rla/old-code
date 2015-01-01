/**
 * 
 */
package ee.pri.rl.tts.parser;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.Stack;

import ee.pri.rl.tts.constructor.model.grammar.Grammar;
import ee.pri.rl.tts.constructor.model.grammar.NonTerminal;
import ee.pri.rl.tts.constructor.model.grammar.PrecedenceRelation;
import ee.pri.rl.tts.constructor.model.grammar.Word;
import ee.pri.rl.tts.parser.tree.ParseTree;
import ee.pri.rl.tts.tokenizer.TokenTerminal;

/**
 * BRC(1,1) redutseeritava grammatika parser.
 * 
 * @author raivo
 */
public class BRCParser implements Parser {

	private Grammar grammar;

	public BRCParser(Grammar grammar) {
		this.grammar = grammar;
	}

	public void parse2(List<TokenTerminal> tokens) throws ParserException {
		WordStack words = new WordStack();
		RelationStack relations = new RelationStack();
		PrecedenceRelation dummyRelation = new PrecedenceRelation();
		dummyRelation.setPreceeds(true);
		relations.push(dummyRelation);
		int i = 0;
		while (true) {
			Word token = tokens.get(i);
			if (words.top() != null) {
				PrecedenceRelation relation = (PrecedenceRelation) grammar.getPrecedenceMatrix().get(words.top(), token);
				if (relation == null) {
					System.out.println("Mittekokkusobivad elemendid: " + words.top() + " ja " + token);
				}
				if (relation.isTimes()) {
					if (token.getNotation().equals("#")) {
						System.out.println("end");
						break;
					} else {
						words.push(token);
						relations.push(relation);
						i++;
					}
				} else if (relation.isPreceeds()) {
					words.push(token);
					relations.push(relation);
					i++;
				} else if (relation.isFollows()) {
					List<Word> base = new ArrayList<Word>();
					while (true) {
						PrecedenceRelation poppedRelation = relations.pop();
						Word poppedWord = words.pop();
						base.add(poppedWord);
						if (poppedRelation.isPreceeds()) {
							Collections.reverse(base);
							NonTerminal result = reduce(words.top(), base, token);
							PrecedenceRelation newRelation = (PrecedenceRelation) grammar.getPrecedenceMatrix().get(words.top(),
									result);
							words.push(result);
							relations.push(newRelation);
							System.out.println("top=" + words.top() + " result=" + result + " newRelation=" + newRelation);
							System.out.println(base + " -> " + result);
							break;
						}
					}
				}
			} else {
				words.push(token);
				i++;
			}
		}
		System.out.println("Words " + words);
	}

	public NonTerminal reduce(Word left, List<Word> base, Word right) {
		System.out.println("Reducing " + left + " | " + base + " | " + right);
		List<NonTerminal> results = grammar.getReduceResults(base);
		if (results.size() == 0) {
			return null;
		} else if (results.size() == 1) {
			return results.get(0);
		} else {
			if (left != null && right != null) {
				for (NonTerminal nonTerminal : results) {
					Set<Word> leftContext = grammar.getLeftContextOf(nonTerminal);
					Set<Word> rightContext = grammar.getRightContextOf(nonTerminal);
					if (leftContext.contains(left) && rightContext.contains(right)) {
						return nonTerminal;
					}
				}
			}
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see ee.pri.rl.tts.parser.Parser#parse(java.util.List)
	 */
	public ParseTree parse(List<TokenTerminal> tokens) throws ParserException {
		/* Sümbolite magasin */
		Stack<Word> wordStack = new Stack<Word>();
		/* Relatsioonide magasin */
		Stack<PrecedenceRelation> relationStack = new Stack<PrecedenceRelation>();

		int i = 0;

		/* Paneme algussümboli magasini */
		wordStack.add(tokens.get(i));
		System.out.println("Panime sümboli " + tokens.get(i) + " magasini.");
		System.out.println("Magasini sisu: " + wordStack);
		while (true) {
			/* Suurendame i-d ühe võrra */
			i++;
			/* Võtame sõna token kohalt i */
			TokenTerminal token = tokens.get(i);
			/*
			 * Kontrollime relatsiooni magasini suurima elemendi ja token'i
			 * vahel
			 */
			PrecedenceRelation relation = (PrecedenceRelation) (grammar.getPrecedenceMatrix().get(wordStack.peek(), token));
			System.out.println("Kontrollime relatsiooni sümbolite " + wordStack.peek() + " ja " + token + " vahel.");
			System.out.println("Relatsioon on " + relation);
			/* Kui relatsioon puudub, lõpetame veateatega */
			if (relation == null) {
				// TODO: kirjutada normaalne veateade.
				throw new ParserException("Kohakuti mittesobivad elemendid!");
				/* Kui relatsioon on "ajastub".. */
			} else if (relation.isTimes()) {
				/* ..ja sümbol on lõpu sümbol */
				if (token.getNotation().equals("#")) {
					System.out.println("parsimise lõpp");
					break;
				} else {
					/* Paneme sõna ja relatsiooni vastvatesse magasinidesse */
					wordStack.push(token);
					System.out.println("Panime sümboli " + token + " magasini.");
					System.out.println("Magasini sisu: " + wordStack);
					relationStack.push(relation);
					System.out.println("Panime relatsiooni " + relation + " magasini.");
					System.out.println("Magasini sisu: " + relationStack);
				}
				/* Kui relatsioon on "eelneb" */
			} else if (relation.isPreceeds()) {
				/* Paneme token'i magasini */
				wordStack.push(token);
				System.out.println("Panime sümboli " + token + " magasini.");
				System.out.println("Magasini sisu: " + wordStack);
				/* Paneme relatsiooni magasini */
				relationStack.push(relation);
				System.out.println("Panime relatsiooni " + relation + " magasini.");
				System.out.println("Magasini sisu: " + relationStack);
				/* Kui relatsioon on "järgneb" */
			} else if (relation.isFollows()) {
				/*
				 * Liigume tagasi mööda magasine, kuni jõuame relatsioonini
				 * "eelneb", paneme kirja vahepealsed sõnad.
				 */
				List<Word> list = new ArrayList<Word>();
				List<PrecedenceRelation> relations = new ArrayList<PrecedenceRelation>();
				while (true) {
					Word poppedWord = wordStack.pop();
					System.out.println("Võtsime masininist sümboli " + poppedWord);
					System.out.println("Magasini sisu: " + wordStack);
					PrecedenceRelation poppedRelation = relationStack.pop();
					System.out.println("Võtsime magasinist relatsiooni " + poppedRelation);
					System.out.println("Magasini sisu: " + relationStack);
					relations.add(relation);
					list.add(poppedWord);
					if (poppedRelation.isPreceeds()) {
						/*
						 * Leiame produktsiooni vasaku poole, mille paremale
						 * poolele vastab hetkel saadud järjend. NB! Siin on
						 * järjend tagurpidi, sellepärast pöörame ta ümber.
						 */
						Collections.reverse(list);
						Collections.reverse(relations);
						/* Listi tegemine sõneks silumise eesmärgil */
						StringBuffer buffer = new StringBuffer();
						for (Word word : list) {
							buffer.append(word.toString());
						}
						buffer.append(" | ");
						for (PrecedenceRelation relation1 : relations) {
							buffer.append(relation1.toString());
						}
						String base = buffer.toString();
						// System.out.println("Leitud lausevormi baas " + base +
						// " rel magasin: " + relationStack.toString());
						/*
						 * Leiame mitteterminalide listi, mille parem pool
						 * vastab leitud baasile.
						 */
						List<NonTerminal> results = grammar.getReduceResults(list);
						if (results.size() == 0) {
							/*
							 * Kui ei leidu mitteterminali, milleks saab antud
							 * baasi redutseerida, anda veateade.
							 */
							throw new ParserException("Leidub mitteredutseeritav baas " + base);
						} else if (results.size() == 1) {
							/*
							 * Leidub täpselt üks vastav mitteterminal,
							 * redutseerime
							 */
							NonTerminal nonTerminal = results.get(0);
							System.out.println("Redutseerisime lausevormi baasi mitteterminaliks " + nonTerminal);
							/* Leiame uue relatsiooni */
							relation = (PrecedenceRelation) (grammar.getPrecedenceMatrix().get(wordStack.peek(), nonTerminal));
							if (relation == null) {
								/*
								 * Redutseerimise tulemusena saadud sõna ja
								 * eelmise magasini elemendi vahel puudub
								 * relatsioon - viga.
								 */
								throw new ParserException("Kohakuti mittesobivad elemendid: " + wordStack.peek() + " ja "
										+ nonTerminal + "!");
							}
							/* Paneme token'i magasini */
							wordStack.push(nonTerminal);
							System.out.println("Panime sümboli " + nonTerminal + " magasini.");
							System.out.println("Magasini sisu: " + wordStack);
							/* Paneme relatsiooni magasini */
							relationStack.push(relation);
							System.out.println("Panime relatsiooni " + relation + " magasini.");
							System.out.println("Magasini sisu: " + relationStack);
							/*
							 * Lähme ühe sammu võrra tagasi, et viimase sõna
							 * (üks sõna pärast baasi) kontroll toimuks uuesti
							 * pärast redutseerimist.
							 */
							i--;
							break;
						} else {
							/*
							 * Leidsime mitu mitteterminali, milleks saame antud
							 * baasi redutseerida.
							 */
							System.out.println("Leitud mitu mitteterminali, milleks saab antud baasi redutseerida:");
							for (NonTerminal nonTerminal : results) {
								System.out.println("  " + nonTerminal);
							}
							/* Leiame vasakpoolse elemendi left */
							Word left = wordStack.peek();
							System.out.println("Vasakpoolne element on " + left);
							List<NonTerminal> results2 = new ArrayList<NonTerminal>();
							/*
							 * Leiame mitteterminalide listi results2, mille
							 * vasaku konteksti hulgas leidub element left.
							 */
							for (NonTerminal nonTerminal : results) {
								Set<Word> leftContext = grammar.getLeftContextOf(nonTerminal);
								if (leftContext.contains(left)) {
									results2.add(nonTerminal);
								}
							}
							if (results2.size() == 0) {
								/* Sobivat mitteterminali ei leidunud. */
								throw new ParserException("Leidub mitteredutseeritav baas " + base);
							} else if (results2.size() == 1) {
								/*
								 * Leidub täpselt üks selline mitteterminal,
								 * mille vasaku konteksti hulgas on left.
								 */
								NonTerminal result = results2.get(0);
								System.out.println("Redutseerisime lausevormi baasi mitteterminaliks " + result);
								/* Leiame uue relatsiooni */
								relation = (PrecedenceRelation) (grammar.getPrecedenceMatrix().get(wordStack.peek(), result));
								if (relation == null) {
									/*
									 * Redutseerimise tulemusena saadud sõna ja
									 * eelmise magasini elemendi vahel puudub
									 * relatsioon - viga.
									 */
									throw new ParserException("Kohakuti mittesobivad elemendid: " + wordStack.peek() + " ja "
											+ result + "!");
								}
								wordStack.push(result);
								relationStack.push(relation);
								/*
								 * Lähme ühe sammu võrra tagasi, et viimase sõna
								 * (üks sõna pärast baasi) kontroll toimuks
								 * uuesti pärast redutseerimist.
								 */
								i--;
								break;
							} else {
								/* Peame kasutama paremat konteksti */
								System.out.println("Vasakust kontekstist ei piisa");
								/* Võtame parempoolse sõna */
								Word right = token;
								System.out.println("Parempoolne sõna on " + right);
								List<NonTerminal> results3 = new ArrayList<NonTerminal>();
								/*
								 * Leiame mitteterminali nonTerminal, mille
								 * parema konteksti hulgas leidub element right.
								 */
								for (NonTerminal nonTerminal : results2) {
									Set<Word> rightContext = grammar.getRightContextOf(nonTerminal);
									if (rightContext.contains(right)) {
										results3.add(nonTerminal);
									}
								}
								if (results3.size() == 0) {
									/* Üheselt mitteredutseeritav baas */
									throw new ParserException("Üheselt mitteredutseeritav baas!");
								} else if (results3.size() == 1) {
									/*
									 * Leidub täpselt üks selline mitteterminal,
									 * mille parema konteksti hulgas on right.
									 */
									NonTerminal result = results3.get(0);
									System.out.println("Redutseerisime lausevormi baasi mitteterminaliks " + result);
									/* Leiame uue relatsiooni */
									relation = (PrecedenceRelation) (grammar.getPrecedenceMatrix().get(wordStack.peek(), result));
									if (relation == null) {
										/*
										 * Redutseerimise tulemusena saadud sõna
										 * ja eelmise magasini elemendi vahel
										 * puudub relatsioon - viga.
										 */
										throw new ParserException("Kohakuti mittesobivad elemendid: " + wordStack.peek() + " ja "
												+ result + "!");
									}
									wordStack.push(result);
									System.out.println("Paigutasime sõna " + result + " sõnade magasini.");
									relationStack.push(relation);
									System.out.println("Paigutasime relatsiooni " + relation + " relatsioonide magasini.");
									/*
									 * Lähme ühe sammu võrra tagasi, et viimase
									 * sõna (üks sõna pärast baasi) kontroll
									 * toimuks uuesti pärast redutseerimist.
									 */
									i--;
									break;
								} else {
									throw new ParserException(
											"Leitud mitu mitteterminali, mille vasak ega parem kontekst ei eristu!");
								}
							}
						}
					}
				}
			}
		}
		return null;
	}
}
