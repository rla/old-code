package ee.pri.rl.algorithmics.tree;

import java.io.PrintStream;

public class PrintVisitor<T> implements TreeVisitor<T> {
	private final PrintStream out;
	
	public PrintVisitor(PrintStream out) {
		this.out = out;
	}

	@Override
	public void visit(Tree<T> tree) {
		out.print(tree.getData());
	}

}
