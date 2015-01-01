package ee.pri.rl.algorithmics.regexp;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.algorithmics.graph.weighted.Graph;

/**
 * <pre>
 * [3, 7, 11, 12, 16, 17, 18, 19] -(a)-> [11, 12, 16, 17, 18, 19]
 * [3, 7, 11, 12, 16, 17, 18, 19] -(b)-> [1, 2, 4, 6, 8, 9, 10, 11, 12, 13, 16, 19, 20]
 * [13, 20] -(a)-> [14]
 * [11, 12, 16, 17, 18, 19] -(b)-> [13, 20]
 * [11, 12, 16, 17, 18, 19] -(a)-> [11, 12, 16, 17, 18, 19]
 * [0, 1, 2, 6, 10, 11, 12, 16, 19] -(a)-> [3, 7, 11, 12, 16, 17, 18, 19]
 * [0, 1, 2, 6, 10, 11, 12, 16, 19] -(b)-> [13, 20]
 * [1, 2, 4, 6, 8, 9, 10, 11, 12, 13, 16, 19, 20] -(b)-> [13, 20]
 * [1, 2, 4, 6, 8, 9, 10, 11, 12, 13, 16, 19, 20] -(a)-> [1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 14, 16, 17, 18, 19]
 * [1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 14, 16, 17, 18, 19] -(a)-> [3, 7, 11, 12, 16, 17, 18, 19]
 * [1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 14, 16, 17, 18, 19] -(b)-> [1, 2, 4, 6, 8, 9, 10, 11, 12, 13, 15, 16, 18, 19, 20]
 * [11, 12, 15, 16, 18, 19] -(b)-> [13, 20]
 * [11, 12, 15, 16, 18, 19] -(a)-> [11, 12, 16, 17, 18, 19]
 * [14] -(b)-> [11, 12, 15, 16, 18, 19]
 * [1, 2, 4, 6, 8, 9, 10, 11, 12, 13, 15, 16, 18, 19, 20] -(b)-> [13, 20]
 * [1, 2, 4, 6, 8, 9, 10, 11, 12, 13, 15, 16, 18, 19, 20] -(a)-> [1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 14, 16, 17, 18, 19]
 * </pre>
 */
public class Thompson {

	public static void main(String[] args) {
		Graph<Integer, String> nfa = new Graph<Integer, String>();
		
		nfa.connect( 0,  1, NFA2DFA.EPSILON);
		nfa.connect( 0, 10, NFA2DFA.EPSILON);
		nfa.connect( 1,  2, NFA2DFA.EPSILON);
		nfa.connect( 1,  6, NFA2DFA.EPSILON);
		nfa.connect( 2,  3, "a");
		nfa.connect( 3,  4, "b");
		nfa.connect( 4,  5, "a");
		nfa.connect( 5,  9, NFA2DFA.EPSILON);
		nfa.connect( 6,  7, "a");
		nfa.connect( 7,  8, "b");
		nfa.connect( 8,  9, NFA2DFA.EPSILON);
		nfa.connect( 9,  1, NFA2DFA.EPSILON);
		nfa.connect( 9, 10, NFA2DFA.EPSILON);
		nfa.connect(10, 11, NFA2DFA.EPSILON);
		nfa.connect(10, 19, NFA2DFA.EPSILON);
		nfa.connect(11, 12, NFA2DFA.EPSILON);
		nfa.connect(11, 16, NFA2DFA.EPSILON);
		nfa.connect(12, 13, "b");
		nfa.connect(13, 14, "a");
		nfa.connect(14, 15, "b");
		nfa.connect(15, 18, NFA2DFA.EPSILON);
		nfa.connect(16, 17, "a");
		nfa.connect(17, 18, NFA2DFA.EPSILON);
		nfa.connect(18, 11, NFA2DFA.EPSILON);
		nfa.connect(18, 19, NFA2DFA.EPSILON);
		nfa.connect(19, 20, "b");
		
		List<String> labels = new ArrayList<String>();
		labels.add("a");
		labels.add("b");
		
		Graph<DFAState, String> dfa = NFA2DFA.toDFA(nfa, 0, labels);
		
		System.out.println(dfa);
	}

}
