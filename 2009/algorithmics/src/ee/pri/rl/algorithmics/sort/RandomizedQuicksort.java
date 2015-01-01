package ee.pri.rl.algorithmics.sort;

import java.util.Random;

/**
 * Algorithms for in-place quicksort. This version
 * selects random element as pivot.
 */
public class RandomizedQuicksort {
	
	/**
	 * Sorts the array using rightmost element as pivot.
	 */
	public static void sort(int[] array) {
		sort(array, 0, array.length - 1, new Random(System.currentTimeMillis()));
	}
	
	/**
	 * Recursive method that partitions the array and then sorts
	 * both halves.
	 * 
	 * @param array The array to sort.
	 * @param start Start of the sortable area.
	 * @param end End of the sortable area.
	 */
	private static void sort(int[] array, int start, int end, Random random) {
		if (start < end) {
			int i = start + random.nextInt(end - start + 1);
			SortUtil.swap(array, i, end);
			int mid = Quicksort.partition(array, start, end);
			sort(array, start, mid - 1, random);
			sort(array, mid + 1, end, random);
		}
	}
}
