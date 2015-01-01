package ee.pri.rl.algorithmics.regexp;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Stack;

import ee.pri.rl.algorithmics.graph.weighted.Edge;
import ee.pri.rl.algorithmics.graph.weighted.Graph;
import ee.pri.rl.algorithmics.graph.weighted.Node;

public class NFA2DFA {
	public static final String EPSILON = "#eps";
	
	public static Graph<DFAState, String> toDFA(Graph<Integer, String> nfa, Integer start, List<String> labels) {
		Graph<DFAState, String> dfa = new Graph<DFAState, String>();
		DFAState state = new DFAState(getEpsilonStates(nfa, start));
		
		Stack<DFAState> stack = new Stack<DFAState>();
		stack.push(state);
		
		while (!stack.isEmpty()) {
			state = stack.pop();
			
			for (String label : labels) {
				DFAState next = makeState(nfa, state, label);
				if (next != null) {
					if (!dfa.hasNode(next)) {
						stack.push(next);
					}
					dfa.connect(state, next, label);
				}
			}
		}
		
		int stateId = 0;
		
		for (Node<DFAState, String> node : dfa) {
			node.getValue().setReadableName("Q" + stateId++);
		}
		
		return dfa;
	}
	
	private static DFAState makeState(Graph<Integer, String> nfa, DFAState from, String label) {
		Set<Integer> nextNFAStateSet = new HashSet<Integer>();
		
		for (Integer nfaState : from.getNfaStates()) {
			nextNFAStateSet.addAll(getNextStates(nfa, nfaState, label));
		}
		
		for (Integer nfaState : new ArrayList<Integer>(nextNFAStateSet)) {
			nextNFAStateSet.addAll(getEpsilonStates(nfa, nfaState));
		}
		
		if (nextNFAStateSet.isEmpty()) {
			return null;
		} else {
			return new DFAState(nextNFAStateSet);
		}
	}
	
	private static Set<Integer> getNextStates(Graph<Integer, String> nfa, Integer node, String label) {
		Set<Integer> valueSet = new HashSet<Integer>();
		
		for (Edge<Integer, String> edge : nfa.getNode(node)) {
			if (label.equals(edge.data)) {
				valueSet.add(edge.to.getValue());
			}
		}
		
		return valueSet;
	}
	
	private static Set<Integer> getEpsilonStates(Graph<Integer, String> nfa, Integer node) {
		Set<Integer> valueSet = new HashSet<Integer>();
		Stack<Node<Integer, String>> stack = new Stack<Node<Integer, String>>();
		
		valueSet.add(node);
		stack.push(nfa.getNode(node));
		
		while (!stack.isEmpty()) {
			for (Edge<Integer, String> edge : stack.pop()) {
				if (!valueSet.contains(edge.to.getValue())
					&& EPSILON.equals(edge.data)) {
					valueSet.add(edge.to.getValue());
					stack.push(edge.to);
				}
			}
		}
		
		return valueSet;
	}

}
