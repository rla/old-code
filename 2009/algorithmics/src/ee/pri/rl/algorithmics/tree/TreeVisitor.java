package ee.pri.rl.algorithmics.tree;

public interface TreeVisitor<T> {
	void visit(Tree<T> tree);
}
