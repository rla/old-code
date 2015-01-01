package ee.pri.rl.algorithmics.fs;

import java.io.File;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Map.Entry;

import ee.pri.rl.algorithmics.tree.DepthFirstTraversal;
import ee.pri.rl.algorithmics.tree.Tree;
import ee.pri.rl.algorithmics.tree.TreeVisitor;

/**
 * Example output:
 * 
 * <pre>
 * Largest directory: ./bin/ee/pri/rl/algorithmics/sort
 * Level	Width
 * 0	1
 * 1	7
 * 2	11
 * 3	2
 * 4	2
 * 5	2
 * 6	8
 * 7	49
 * </pre>
 */
public class RecursiveDirectoryStatisticsReporter {

	public static void main(String[] args) {
		Tree<File> tree = buildTree(new File("."));
		
		MaxDirectorySizeFinder finder = new MaxDirectorySizeFinder();
		new DepthFirstTraversal<File>(finder).traverse(tree);
		
		if (finder.hasFoundMaxDirectory()) {
			System.out.println("Largest directory: " + finder.getMaxDirectory());
		}
		
		SortedMap<Integer, Integer> levelMap = new TreeMap<Integer, Integer>();
		fillLevelMap(levelMap, tree);
		
		System.out.println("Level\tWidth");
		for (Entry<Integer, Integer> entry : levelMap.entrySet()) {
			System.out.println(entry.getKey() + "\t" + entry.getValue());
		}
	}
	
	private static class MaxDirectorySizeFinder implements TreeVisitor<File> {
		private File maxDirectory = null;
		private int maxDirectorySize = Integer.MIN_VALUE;
		
		@Override
		public void visit(Tree<File> tree) {
			if (tree.getData().isDirectory()) {
				int directorySize = tree.getChildren().size();
				if (directorySize > maxDirectorySize) {
					maxDirectorySize = directorySize;
					maxDirectory = tree.getData();
				}
			}
		}
		
		public boolean hasFoundMaxDirectory() {
			return maxDirectory != null;
		}

		public File getMaxDirectory() {
			return maxDirectory;
		}
		
	}
	
	private static void fillLevelMap(Map<Integer, Integer> levelMap, Tree<?> tree) {
		fillLevelMap(levelMap, tree, 0);
	}

	private static void fillLevelMap(Map<Integer, Integer> levelMap, Tree<?> tree, int level) {
		int levelCount = 1;
		
		if (levelMap.containsKey(level)) {
			levelCount = levelMap.get(level) + 1;
		}
		
		levelMap.put(level, levelCount);
		
		for (Tree<?> child : tree) {
			fillLevelMap(levelMap, child, level + 1);
		}
	}

	@SuppressWarnings("unchecked")
	private static Tree<File> buildTree(File root) {
		Tree<File> tree = new Tree<File>(root);
		
		if (root.isDirectory()) {
			for (File child : root.listFiles()) {
				tree.add(buildTree(child));
			}
		}
		
		return tree;
	}

}
