package ee.pri.rl.ted;

import java.util.HashMap;
import java.util.Map;

public class EditDistance {

	public static void main(String[] args) {
		Map<Key, Integer> map = new HashMap<Key, Integer>();
		
		Node F = new Node('a',
			new Node('a'),
			new Node('b',
				new Node('c'),
				new Node('d')
			)
		);
		
		Node G = new Node('a',
			new Node('b',
				new Node('c'),
				new Node('d')
			),
			new Node('a')
		);
		
		numberPostOrder(F, 0);
		numberPostOrder(G, 0);
		
		System.out.println(ted(new Forest(F), new Forest(G), map));
	}
	
	private static int ted(Forest F, Forest G, Map<Key, Integer> map) {
		Key key = new Key(F, G);
		Integer value = map.get(key);
		
		if (value != null) {
			System.out.println(key + " -> " + value); 
			return value;
		}
		
		if (G.roots.length == 0) {
			if (F.roots.length == 0) {
				System.out.println(key + " -> " + 0); 
				return 0;
			} else {
				value = ted(deleteLeftmostRoot(F), G, map) + 1;
				map.put(key, value);
				
				System.out.println(key + " -> " + value); 
				
				return value;
			}
		} else {
			if (F.roots.length == 0) {
				value = ted(F, deleteLeftmostRoot(G), map) + 1;
				map.put(key, value);
				
				System.out.println(key + " -> " + value); 
				
				return value;
			} else {
				int deleteFLeft = ted(deleteLeftmostRoot(F), G, map) + 1;
				int deleteGLeft = ted(F, deleteLeftmostRoot(G), map) + 1;
				int deleteLeftTrees =
					ted(new Forest(F.roots[0].nodes), new Forest(G.roots[0].nodes), map)
					+ ted(deleteLeftmostTree(F), deleteLeftmostTree(G), map)
					+ (F.roots[0].value == G.roots[0].value ? 0 : 1); 

				value = Math.min(
					deleteFLeft,
					Math.min(
						deleteGLeft,
						deleteLeftTrees
					)
				);
				map.put(key, value);
				
				System.out.println(key + " -> " + value);
				
				return value;
			}
		}
	}
	
	private static Forest deleteLeftmostTree(Forest F) {
		Node[] nodes = new Node[F.roots.length - 1];
		System.arraycopy(F.roots, 1, nodes, 0, F.roots.length - 1);
		
		return new Forest(nodes);
	}
	
	private static Forest deleteLeftmostRoot(Forest F) {
		if (F.roots[0].isEmpty()) {
			return Forest.EMPTY_FOREST;
		}
		
		Node[] nodes = new Node[F.roots[0].nodes.length + F.roots.length - 1];
		System.arraycopy(F.roots[0].nodes, 0, nodes, 0, F.roots[0].nodes.length);
		System.arraycopy(F.roots, 1, nodes, F.roots[0].nodes.length, F.roots.length - 1);
		
		return new Forest(nodes);
	}
	
	private static int numberPostOrder(Node root, int id) {
		if (root.isEmpty()) {
			root.setId(id);
			id++;
			
			return id;
		}
		for (Node node : root.nodes) {
			id = numberPostOrder(node, id);
		}
		
		root.setId(id);
		
		id++;
		return id;
	}

}
