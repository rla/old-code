package ee.pri.rl.wiki.transform.pre;

import ee.pri.rl.parser.Node;

/**
 * Transformer that transforms certain node.
 */

public interface NodeTransformer {

	Node transform(Node node) throws Exception;
}
