package ee.pri.rl.algorithmics.tree;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Tree<T> implements Iterable<Tree<T>> {
	private final T data;
	private final List<Tree<T>> children;
	
	public Tree(T data) {
		this.data = data;
		this.children = new ArrayList<Tree<T>>();
	}

	public T getData() {
		return data;
	}
	
	public Tree<T> add(Tree<T>... trees) {
		for (Tree<T> tree : trees) {
			children.add(tree);
		}
		
		return this;
	}

	public List<Tree<T>> getChildren() {
		return children;
	}

	@Override
	public Iterator<Tree<T>> iterator() {
		return children.iterator();
	}

}
