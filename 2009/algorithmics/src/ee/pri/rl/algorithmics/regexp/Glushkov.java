package ee.pri.rl.algorithmics.regexp;

import java.util.ArrayList;
import java.util.List;

import ee.pri.rl.algorithmics.graph.weighted.Graph;

/**
 * <pre>
 * [0] -(a)-> [1, 4]
 * [2, 3, 5, 8] -(a)-> [1, 3, 4, 6, 7]
 * [2, 3, 5, 8] -(b)-> [5]
 * [1, 3, 4, 6, 7] -(b)-> [2, 3, 5, 7, 8]
 * [1, 3, 4, 6, 7] -(a)-> [1, 4, 7]
 * [5] -(a)-> [6]
 * [2, 3] -(b)-> [5]
 * [2, 3] -(a)-> [1, 3, 4, 7]
 * [1, 4] -(b)-> [2, 3]
 * [6] -(b)-> [7]
 * [7] -(a)-> [7]
 * [7] -(b)-> [5, 8]
 * [2, 3, 5, 7, 8] -(a)-> [1, 3, 4, 6, 7]
 * [2, 3, 5, 7, 8] -(b)-> [5, 8]
 * [1, 4, 7] -(b)-> [2, 3, 5, 8]
 * [1, 4, 7] -(a)-> [7]
 * [5, 8] -(a)-> [6]
 * [1, 3, 4, 7] -(b)-> [2, 3, 5, 8]
 * [1, 3, 4, 7] -(a)-> [1, 4, 7]
 * </pre>
 */
public class Glushkov {

	public static void main(String[] args) {
		Graph<Integer, String> nfa = new Graph<Integer, String>();
		
		nfa.connect(0, 1, "a");
		nfa.connect(0, 4, "a");
		nfa.connect(1, 2, "b");
		nfa.connect(2, 3, "a");
		nfa.connect(3, 1, "a");
		nfa.connect(3, 4, "a");
		nfa.connect(3, 5, "b");
		nfa.connect(3, 7, "a");
		nfa.connect(4, 3, "b");
		nfa.connect(5, 6, "a");
		nfa.connect(6, 7, "b");
		nfa.connect(7, 5, "b");
		nfa.connect(7, 8, "b");
		nfa.connect(7, 7, "a");
		
		List<String> labels = new ArrayList<String>();
		labels.add("a");
		labels.add("b");
		
		Graph<DFAState, String> dfa = NFA2DFA.toDFA(nfa, 0, labels);
		
		System.out.println(dfa);
	}

}
