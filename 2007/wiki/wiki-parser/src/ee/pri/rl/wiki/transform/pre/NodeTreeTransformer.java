package ee.pri.rl.wiki.transform.pre;

import java.util.HashMap;

import ee.pri.rl.parser.Node;

/**
 * Applies node transformations.
 */

public class NodeTreeTransformer {
	private HashMap<String, NodeTransformer> transformers;
	
	public NodeTreeTransformer() {
		transformers = new HashMap<String, NodeTransformer>();
	}
	
	public Node apply(Node root) throws Exception {
		NodeTransformer transformer = transformers.get(root.getName());
		if (transformer != null) {
			return transformer.transform(root);
		} else {
			Node newRoot = new Node(root.getName());
			newRoot.setContents(root.getContents());
			for (Node node : root.getNodes()) {
				newRoot.addNode(apply(node));
			}
			return newRoot;
		}
	}
	
	public void addTransformer(String nodeName, NodeTransformer transformer) {
		transformers.put(nodeName, transformer);
	}
}
