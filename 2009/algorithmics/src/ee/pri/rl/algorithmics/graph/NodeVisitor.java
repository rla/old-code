package ee.pri.rl.algorithmics.graph;

public interface NodeVisitor<T> {
	void visit(Node<T> node, Node<T> from);
}
