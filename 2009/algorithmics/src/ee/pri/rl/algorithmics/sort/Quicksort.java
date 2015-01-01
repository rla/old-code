package ee.pri.rl.algorithmics.sort;

/**
 * Algorithms for in-place quicksort. This version always
 * selects the last element as pivot.
 */
public class Quicksort {
	
	/**
	 * Sorts the array using rightmost element as pivot.
	 */
	public static void sort(int[] array) {
		sort(array, 0, array.length - 1);
	}
	
	/**
	 * Recursive method that partitions the array and then sorts
	 * both halves.
	 * 
	 * @param array The array to sort.
	 * @param start Start of the sortable area.
	 * @param end End of the sortable area.
	 */
	private static void sort(int[] array, int start, int end) {
		if (start < end) {
			int mid = partition(array, start, end);
			sort(array, start, mid - 1);
			sort(array, mid + 1, end);
		}
	}
	
	/**
	 * Partition the array around the element that is given by its index.
	 * Taken from "Introduction to Algorithms" book.
	 * 
	 * @param array The array to be partitioned.
	 * @param start Start of the area.
	 * @param end End of the area.
	 * @return Index of middle element.
	 */
	public static int partition(int[] array, int start, int end) {
		
		assert end > start;
		
		int x = array[end];
		int i = start - 1;
		
		for (int j = start; j <= end - 1; j++) {
			if (array[j] <= x) {
				i++;
				SortUtil.swap(array, i, j);
			}
		}
		
		SortUtil.swap(array, i + 1, end);
		
		return i + 1;
	}
}
