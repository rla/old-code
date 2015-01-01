package ee.pri.rl.algorithmics.tree;

import java.util.Stack;

public class DepthFirstTraversal<T> {
	private final TreeVisitor<T> visitor;

	public DepthFirstTraversal(TreeVisitor<T> visitor) {
		this.visitor = visitor;
	}

	public void traverse(Tree<T> tree) {
		Stack<Tree<T>> stack = new Stack<Tree<T>>();
		stack.push(tree);
		
		while (!stack.isEmpty()) {
			Tree<T> t = stack.pop();
			
			visitor.visit(t);
			
			for (int i = t.getChildren().size() - 1; i >= 0; i--) {
				stack.push(t.getChildren().get(i));
			}
		}
	}
}
