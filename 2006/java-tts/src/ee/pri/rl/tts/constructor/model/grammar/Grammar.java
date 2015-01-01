/**
 * 
 */
package ee.pri.rl.tts.constructor.model.grammar;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import ee.pri.rl.tts.constructor.util.WordMatrix;

/**
 * Grammatika, koosneb produktsioonidest.
 * @author raivo
 */
public class Grammar {
	private Set<Production> productions;

	private Production axiom;

	private Set<Terminal> terminals;

	private Set<NonTerminal> nonTerminals;

	private WordMatrix leftmostSet;

	private WordMatrix rightmostSet;

	private WordMatrix precedenceMatrix;

	private Set<Word> words;
	/*Sõnade vasaku konteksti hulgad*/
	private Map<NonTerminal, Set<Word>> leftContext;
	/*Sõnade parema konteksti hulgad*/
	private Map<NonTerminal, Set<Word>> rightContext;
	/*Kas tegemist on eelnevusgrammatikaga*/
	private boolean isPrecedenceGrammar;

	public Map<NonTerminal, Set<Word>> getLeftContext() {
		return leftContext;
	}

	public Set<NonTerminal> getNonTerminals() {
		return nonTerminals;
	}

	public Set<Terminal> getTerminals() {
		return terminals;
	}

	public Production getAxiom() {
		return axiom;
	}

	public static Grammar read(String filename) throws GrammarException {
		Grammar grammar = new Grammar();
		Set<Production> productions = ProductionsReader.read(filename);
		grammar.setProductions(productions);
		return grammar;
	}
	
	/**
	 * Leitakse mitteterminalide list, milleks võib
	 * etteantud lausevormi baasi redutseerida.
	 * Kasutatakse BRC analüsaatori töös.
	 */
	public List<NonTerminal> getReduceResults(List<Word> base) {
		List<NonTerminal> results = new ArrayList<NonTerminal>();
		for (Production production : productions) {
			Definition definition = production.getDefinition();
			List<Word> defWords = definition.getWords();
			/* Kui produktsiooni paremad pooled on erineva sõnade
			 * arvuga, siis pole enam mõtet edasi uurida. */
			if (base.size() != defWords.size()) {
				continue;
			}
			boolean equal = true;
			for (int i = 0; i < base.size(); i++) {
				if (!base.get(i).equals(defWords.get(i))) {
					equal = false;
				}
			}
			if (equal) {
				results.add(production.getNonTerminal());
			}
		}
		return results;
	}
	
	/**
	 * Leiab, kas tegemist on eelnevusgrammatikaga.
	 * Grammatikat nimetatakse eelnevusgrammatikaks, kui iga kahe
	 * sõna a,b \in V jaoks kehtib ainult üks eelnevusrelatsioon
	 * a ja b vahel.
	 * Algoritmi saab rakendada pärast eelnevusmaatriksi leidmist.
	 */
	private void findIsPrecedenceGrammar() {
		isPrecedenceGrammar = true;
		for (Word word1 : words) {
			for (Word word2 : words) {
				PrecedenceRelation relation = (PrecedenceRelation)precedenceMatrix.get(word1, word2);
				if (relation != null) {
					if (!(
							(
									relation.isFollows() && !relation.isPreceeds() && !relation.isTimes()
							)
							|| 
							(
									relation.isPreceeds() && !relation.isTimes() && !relation.isFollows()
							)
							||
							(
									relation.isTimes() && !relation.isFollows() && !relation.isPreceeds()
							)
						)) {
						isPrecedenceGrammar = false;
						System.out.println("PROBLEEM EELNEVUSTEGA: " + word1 + " ja " + word2);
						System.out.println("word1, word2 follows: " + relation.isFollows());
						System.out.println("word1, word2 preceeds: " + relation.isPreceeds());
						System.out.println("word1, word2 times: " + relation.isTimes());
						return;
					}
				}
			}
		}
	}

	/**
	 * Produktsioonide hulgast aksioomi leidmine. Aksioom on produktsioon kujul
	 * A -> #.Mitteterminal.
	 */
	private void findAxiom() {
		for (Production production : productions) {
			Definition definition = production.getDefinition();
			if (definition.getWords().size() < 2) {
				continue;
			}
			Word first = definition.getWords().get(0);
			Word second = definition.getWords().get(1);
			if (first.getNotation().equals("#") && (second instanceof NonTerminal)) {
				axiom = production;
				break;
			}
		}
		axiom = null;
	}

	/**
	 * Terminalide ja mitteterminalide hulkade leidmine. Vaadatakse läbi kõik
	 * produktsioonid ja lisatakse terminalid ja mitteterminalid vastavatesse
	 * hulkadesse.
	 */
	private void findTerminalsAndNonTerminals() {
		terminals = new HashSet<Terminal>();
		nonTerminals = new HashSet<NonTerminal>();
		for (Production production : productions) {
			Definition definition = production.getDefinition();
			nonTerminals.add(production.getNonTerminal());
			for (Word word : definition.getWords()) {
				if (word instanceof NonTerminal) {
					nonTerminals.add((NonTerminal) word);
				} else if (word instanceof Terminal) {
					terminals.add((Terminal) word);
				}
			}
		}
	}

	/**
	 * Etteantud mitteterminali leftmost hulga leidmine.
	 */
	public Set<Word> getLeftmostOf(NonTerminal nonTerminal) {
		HashMap<Word, Object> map = leftmostSet.getRow(nonTerminal);
		if (map != null) {
			return map.keySet();
		} else {
			return null;
		}
	}

	/**
	 * Etteantud mitteterminali rightmost hulga leidmine.
	 */
	public Set<Word> getRightmostOf(NonTerminal nonTerminal) {
		HashMap<Word, Object> map = rightmostSet.getRow(nonTerminal);
		if (map != null) {
			return map.keySet();
		} else {
			return null;
		}
	}

	/**
	 * Leftmost ja rightmost hulkade leidmine. Algoritm koosneb kahest osast:
	 * Esimeses osas lisatakse leftmost hulka definitsiooni algussümbolid ja
	 * rightmost hulka lisatakse definitsiooni lõpusümbolid. Teise läbivaatluse
	 * käigus lisatakse iga mitteterminali A left(right)most hulka iga
	 * mitteterminali B \in L(A) (B \in R(A)) left(right)most hulga element.
	 * Seda osa korratakse kuni ühtegi lisamist enam ei ole.
	 */
	private void findLeftmostRightmostSets() {
		leftmostSet = new WordMatrix();
		rightmostSet = new WordMatrix();
		boolean lisatud;

		/* Esimene läbimine */
		for (Production production : productions) {
			Definition definition = production.getDefinition();
			/* words - produktsiooni kogu parem pool */
			List<Word> words = definition.getWords();
			/* first - produktsiooni parema poole algussõna */
			Word first = words.get(0);
			/* last - produktsiooni parema poole lõpusõna */
			Word last = words.get(words.size() - 1);
			leftmostSet.set(production.getNonTerminal(), first, new Boolean(true));
			rightmostSet.set(production.getNonTerminal(), last, new Boolean(true));
		}

		/*
		 * Teine läbimine leftmost hulga jaoks. Vaata allpool olevaid
		 * kommentaare rightmost hulga leidmise kohta.
		 */
		lisatud = true;
		while (lisatud) {
			lisatud = false;
			for (Word word : new HashSet<Word>(leftmostSet.getRowIndexes())) {
				Set<Word> leftmost = new HashSet<Word>(getLeftmostOf((NonTerminal) word));
				if (leftmost == null) {
					continue;
				}
				for (Word leftword : leftmost) {
					if (leftword instanceof NonTerminal) {
						Set<Word> leftmost1 = getLeftmostOf((NonTerminal) leftword);
						if (leftmost1 == null) {
							continue;
						}
						for (Word leftword1 : leftmost1) {
							if (leftmostSet.get(word, leftword1) == null) {
								lisatud = true;
								leftmostSet.set(word, leftword1, new Boolean(true));
							}

						}
					}
				}
			}
		}

		/* Teine läbimine rightmost hulga jaoks */
		lisatud = true;
		while (lisatud) {
			lisatud = false;
			/* Iga mitteterminali A jaoks .. */
			for (Word word : new HashSet<Word>(rightmostSet.getRowIndexes())) {
				/* .. võtame tema rightmost hulga R(A) .. */
				Set<Word> rightmost = new HashSet<Word>(getRightmostOf((NonTerminal) word));
				if (rightmost == null) {
					continue;
				}
				/* .. ning iga selle hulga mitteterminali B \in R(A) jaoks .. */
				for (Word rightword : rightmost) {
					if (rightword instanceof NonTerminal) {
						Set<Word> rightmost1 = getRightmostOf((NonTerminal) rightword);
						/*
						 * .. vaatame läbi selle mitteterminali rightmost hulga
						 * R(B) ..
						 */
						if (rightmost1 == null) {
							continue;
						}
						for (Word rightword1 : rightmost1) {
							/* .. kui element a \in R(B) ei olnud hulgas R(A) .. */
							if (rightmostSet.get(word, rightword1) == null) {
								lisatud = true;
								/* .. siis lisame ta sinna. */
								rightmostSet.set(word, rightword1, new Boolean(true));
							}
						}
					}
				}
			}
		}
	}

	public Set<Production> getProductions() {
		return productions;
	}

	/**
	 * Eelnevusrelatsioonide maatriksi moodustamine.
	 */
	private void generatePrecedenceMatrix() {

		/*
		 * Ajastumisrelatsioonide leidmine X ajastub Y = {(X, Y) | A -> uXYv \in
		 * P} st. leidub produktsioon kujul A -> uXYv
		 */
		precedenceMatrix = new WordMatrix();

		/* Terminalide ja mitteterminalide ühishulk */
		words = new HashSet<Word>(terminals);
		words.addAll(nonTerminals);

		for (Word X : words) {
			for (Word Y : words) {
				/* Otsime produktsiooni, kus X ja Y on kõrvuti */
				for (Production production : productions) {
					List<Word> definitionWords = production.getDefinition().getWords();
					/* Käime läbi iga kaks järjestikku definitsiooni sõna */
					for (int i = 0; i < definitionWords.size() - 1; i++) {
						Word definitionX = definitionWords.get(i);
						Word definitionY = definitionWords.get(i + 1);
						if (X.equals(definitionX) && Y.equals(definitionY)) {
							PrecedenceRelation relation = new PrecedenceRelation();
							relation.setTimes(true);
							precedenceMatrix.set(X, Y, relation);
						}
					}
				}
			}
		}

		/*
		 * Eelnevusrelatsioonide leidmine. X eelneb Y = {(X, Y) | A -> uXBv \in
		 * P & Y \in L(B)}.
		 */
		for (Word X : words) {
			for (Word Y : words) {
				/* Otsime relatsiooni, kus on kõrvuti X ja mingi mitteterminal */
				for (Production production : productions) {
					List<Word> definitionWords = production.getDefinition().getWords();
					/* Käime läbi iga kaks järjestikku definitsiooni sõna */
					for (int i = 0; i < definitionWords.size() - 1; i++) {
						Word definitionX = definitionWords.get(i);
						Word B = definitionWords.get(i + 1);
						if (B instanceof NonTerminal && X.equals(definitionX)) {
							/* Kontrollime, kas Y \in L(B) */
							Set<Word> LB = getLeftmostOf((NonTerminal) B);
							if (LB != null && LB.contains(Y)) {
								/* Leiame praeguse relatsiooni */
								PrecedenceRelation relation = (PrecedenceRelation) precedenceMatrix.get(X, Y);
								if (relation == null) {
									/* Loome uue relatsiooni */
									relation = new PrecedenceRelation();
									precedenceMatrix.set(X, Y, relation);
								}
								relation.setPreceeds(true);
							}
						}
					}
				}
			}
		}

		/*
		 * Järgnevusrelatsioonide leidmine. X järgneb Y = { (X, Y) | [A -> uBYv
		 * \in P & X \in R(B)] v [A -> uBCv \in P & X \in R(B) & Y \in L(C)] }
		 */

		for (Word X : words) {
			for (Word Y : words) {
				for (Production production : productions) {
					List<Word> definitionWords = production.getDefinition().getWords();
					/*
					 * Otsime produktioonide hulgast produktsiooni,
					 * kus on kõrvuti kaks mitteterminali.
					 */
					for (int i = 0; i < definitionWords.size() - 1; i++) {
						Word B = definitionWords.get(i);
						Word C = definitionWords.get(i + 1);
						if (B instanceof NonTerminal) {
							/* Kontrollime, kas X \in R(B) */
							Set<Word> rightmost = getRightmostOf((NonTerminal) B);
							if (rightmost != null && rightmost.contains(X)) {
								/* Kontrollime, kas Y=C */
								if (Y.equals(C)) {
									/* Võtame olemasoleva relatsiooni */
									PrecedenceRelation relation = (PrecedenceRelation) precedenceMatrix.get(X, Y);
									if (relation == null) {
										/* Teeme uue relatsiooni */
										relation = new PrecedenceRelation();
										precedenceMatrix.set(X, Y, relation);
									}
									relation.setFollows(true);
								} else {
									/* Kui Y != C, kontrollime, kas Y \in L(C) */
									if (C instanceof NonTerminal) {
										Set<Word> leftmost = getLeftmostOf((NonTerminal) C);
										if (leftmost != null && leftmost.contains(Y)) {
											PrecedenceRelation relation = (PrecedenceRelation) precedenceMatrix.get(X, Y);
											if (relation == null) {
												relation = new PrecedenceRelation();
												precedenceMatrix.set(X, Y, relation);
											}
											relation.setFollows(true);
										}
									}
								}
							}
						}
					}
				}
			}
		}

	}

	/**
	 * Grammatika produktsioonide seadmine. Sellele järgneb vahetult aksioomi,
	 * mitteterminalide ja leftmost, rightmost hulkade jm. leidmine.
	 */
	public void setProductions(Set<Production> productions) {
		this.productions = productions;
		/*Aksioomi leidmine*/
		findAxiom();
		/*Terminalide ja mitteterminalide hulkade leidmine*/
		findTerminalsAndNonTerminals();
		/*Leftmost ja rightmost hulkade leidmine*/
		findLeftmostRightmostSets();
		/*Eelnevusmaatriksi tekitamine*/
		generatePrecedenceMatrix();
		/*Leiame, kas grammatika on eelnevusgrammatika*/
		findIsPrecedenceGrammar();
		/*Parema ja vasaku konteksti hulkade leidmine*/
		findLeftRightContext();
	}
	
	/**
	 * Tagastab terminaali, mille sõneline tähistus
	 * langeb kokku etteantud sõnega. Kui sellist
	 * terminaali ei leidu, siis tagastatakse null.
	 */
	public Terminal getTerminal(String input) {
		for (Terminal terminal : terminals) {
			if (terminal.getNotation().equals(input)) {
				return terminal;
			}
		}
		return null;
	}
	
	/**
	 * Tagastab mitteterminali A, kui leidub produktsioon
	 * kujul A -> uXYv, kus uXYv moodustub etteantud
	 * mitteterminalide ja terminalide listist. 
	 */
	public NonTerminal getNonTerminal(List<Word> words) {
		for (Production production : productions) {
			Definition definition = production.getDefinition();
			List<Word> defWords = definition.getWords();
			/* Kui produktsiooni paremad pooled on erineva sõnade
			 * arvuga, siis pole enam mõtet edasi uurida. */
			if (words.size() != defWords.size()) {
				continue;
			}
			boolean equal = true;
			for (int i = 0; i < words.size(); i++) {
				if (!words.get(i).equals(defWords.get(i))) {
					equal = false;
				}
			}
			if (equal) {
				return production.getNonTerminal();
			}
		}
		return null;
	}
	
	/**
	 * Vasaku ja parema konteksti hulkade leidmine.
	 * A vasaku konteksti hulk: LC(A) = { x \in V | x < A V x = A }.
	 * A parema konteksti hulk: RC(A) = { x \in V_T | A < x V A = x V A > x }.
	 * Konteksti hulki saab leida alles pärast eelnevus-
	 * maatriksi koostamist.
	 */
	private void findLeftRightContext() {
		leftContext = new HashMap<NonTerminal, Set<Word>>();
		rightContext = new HashMap<NonTerminal, Set<Word>>();
		for (NonTerminal A : nonTerminals) {
			Set<Word> leftSet = new HashSet<Word>();
			Set<Word> rightSet = new HashSet<Word>();
			for (Word x : words) {
				PrecedenceRelation relation = (PrecedenceRelation)precedenceMatrix.get(x, A);
				if (relation != null) {
					if (relation.isPreceeds() || relation.isTimes()) {
						leftSet.add(x);
					}
				}
				relation = (PrecedenceRelation)precedenceMatrix.get(A, x);
				if (relation != null && x instanceof Terminal) {
					if (relation.isFollows() || relation.isPreceeds() || relation.isTimes()) {
						rightSet.add(x);
					}
				}
			}
			leftContext.put(A, leftSet);
			rightContext.put(A, rightSet);
		}
	}
	
	/**
	 * Etteantud sõna vasaku konteksti saamine.
	 */
	public Set<Word> getLeftContextOf(NonTerminal word) {
		return leftContext.get(word);
	}
	
	/**
	 * Etteantud sõna parema konteksti saamine.
	 */
	public Set<Word> getRightContextOf(NonTerminal word) {
		return rightContext.get(word);
	}

	public String toString() {
		StringBuffer buffer = new StringBuffer();
		buffer.append("Grammatika \n-----------------------------\n");
		for (Production production : productions) {
			buffer.append("  " + production.toString() + "\n");
		}
		buffer.append("-----------------------------\n");
		buffer.append("Mitteterminaalse tähestiku elemendid:\n");
		for (NonTerminal nonTerminal : nonTerminals) {
			buffer.append(nonTerminal.toString() + ", L = { ");
			Set<Word> leftmost = getLeftmostOf(nonTerminal);
			if (leftmost == null) {
				continue;
			}
			for (Word word : leftmost) {
				buffer.append(word + " ");
			}
			buffer.append("}, R = {");
			for (Word word : getRightmostOf(nonTerminal)) {
				buffer.append(word + " ");
			}
			buffer.append("}\n");
		}
		buffer.append("-----------------------------\n");
		buffer.append("Terminaalse tähestiku elemendid:\n");
		for (Terminal terminal : terminals) {
			buffer.append(terminal.toString() + "\n");
		}
		buffer.append("-----------------------------\n");
		buffer.append("Eelnevusrelatsioonid\n");

		for (Word word : words) {
			buffer.append(word + " : ");
			HashMap<Word, Object> row = precedenceMatrix.getRow(word);
			if (row != null) {
				for (Word x : row.keySet()) {
					PrecedenceRelation relation = (PrecedenceRelation) row.get(x);
					if (relation != null) {
						buffer.append(relation.toString() + "*" + x + " ");
					}
				}
			}
			buffer.append("\n");
		}
		
		buffer.append("-----------------------------\n");
		if (isPrecedenceGrammar) {
			buffer.append("Grammatika ON eelnevusgrammatika.\n");
		} else {
			buffer.append("Grammatika EI OLE eelnevusgrammatika.\n");
		}
		
		buffer.append("-----------------------------\n");
		buffer.append("Vasaku konteksti hulgad\n");
		for (NonTerminal A : nonTerminals) {
			buffer.append("LC(" + A + ") = { ");
			Set<Word> words = getLeftContextOf(A);
			for (Word word : words) {
				buffer.append(word + ", ");
			}
			buffer.append("}\n");
		}
		buffer.append("-----------------------------\n");
		buffer.append("Parema konteksti hulgad\n");
		for (NonTerminal A : nonTerminals) {
			buffer.append("RC(" + A + ") = { ");
			Set<Word> words = getRightContextOf(A);
			for (Word word : words) {
				buffer.append(word + ", ");
			}
			buffer.append("}\n");
		}
		return buffer.toString();
	}

	public WordMatrix getLeftmostSet() {
		return leftmostSet;
	}

	public WordMatrix getRightmostSet() {
		return rightmostSet;
	}

	public WordMatrix getPrecedenceMatrix() {
		return precedenceMatrix;
	}
}
