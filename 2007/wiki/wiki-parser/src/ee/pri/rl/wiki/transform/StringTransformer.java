package ee.pri.rl.wiki.transform;

import java.util.HashMap;

import ee.pri.rl.parser.Node;

/**
 * Very simple transformer that transforms abstract
 * syntax tree into String.
 */

public class StringTransformer {
	private HashMap<String, StringTransform> transformers;
	
	public StringTransformer() {
		transformers = new HashMap<String, StringTransform>();
	}
	
	public void addTransform(String nodeName, StringTransform transform) {
		transformers.put(nodeName, transform);
	}
	
	public String apply(Node root) throws Exception {
		StringBuilder builder = new StringBuilder();
		apply(root, builder);
		return builder.toString();
	}

	private void apply(Node root, StringBuilder builder) throws Exception {
		StringTransform transform = transformers.get(root.getName());
		if (transform == null) {
			throw new Exception("Cannot find transformer for node " + root.getName());
		}
		String contents = root.getContents();
		builder.append(transform.getTextBefore());
		builder.append(contents == null ? "" : transform.processContents(contents));
		for (Node node : root.getNodes()) {
			apply(node, builder);
		}
		builder.append(transform.getTextAfter());
	}
}
