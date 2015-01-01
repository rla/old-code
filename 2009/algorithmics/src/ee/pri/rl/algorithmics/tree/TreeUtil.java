package ee.pri.rl.algorithmics.tree;


public class TreeUtil {
	
	public static <T> int treeSize(Tree<T> tree) {
		int size = 1;
		for (Tree<T> child : tree) {
			size += treeSize(child);
		}
		
		return size;
	}
}
