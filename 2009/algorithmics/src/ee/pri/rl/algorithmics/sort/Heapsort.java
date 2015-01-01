package ee.pri.rl.algorithmics.sort;

public class Heapsort {
	
	public static void sort(int[] array) {
		buildMaxHeap(array);
		int end = array.length - 1;
		
		// array[0] is largest element (root of whole heap)
		// Elements from end are in correct position (disgarded from the heap)
		for (int i = array.length - 1; i >= 1; i--) {
			SortUtil.swap(array, 0, end);
			end--;
			// Restore max-heap property at array[0]
			maxHeapify(array, 0, 0, end);
		}
	}
	
	/**
	 * Helper procedure to convert the given array
	 * into max-heap. Runs in O(n).
	 */
	public static void buildMaxHeap(int[] array) {
		// Loop invariant: i+1, i+2, ..., n are max-heap roots
		for (int i = (array.length - 1) / 2; i >= 0 ; i--) {
			maxHeapify(array, i, 0, array.length - 1);
		}
	}

	/**
	 * Helper procedure to fix the max-heap at index i.
	 * 
	 * Assumes that trees rooted at left(i) and right(i)
	 * are already max-heaps.
	 * 
	 * @param array The array that contains the heap.
	 * @param i Position of the root that needs to be fixed.
	 * @param start The start of the heap area.
	 * @param end The end of the heap area. (index of last element)
	 */
	public static void maxHeapify(int[] array, int i, int start, int end) {
		int l = left(i);
		int r = right(i);
		
		int largest = i;
		if (l >= start && l <= end && array[l] > array[i]) {
			largest = l;
		}
		if (r <= end && r <= end && array[r] > array[largest]) {
			largest = r;
		}
		if (largest != i) {
			
			// Needs fixing
			SortUtil.swap(array, i, largest);
			
			// Fix at largest too
			maxHeapify(array, largest, start, end);
		}
	}
	
	public static int parent(int i) {
		return (i - 1) / 2;
	}
	
	public static int left(int i) {
		return 2 * i + 1;
	}
	
	public static int right(int i) {
		return 2 * i + 2;
	}
	
	/**
	 * Helper procedure to check max-heap property inside
	 * the given array.
	 */
	public static boolean isMaxHeap(int[] array) {
		for (int i = 0; i < array.length; i++) {
			if (array[parent(i)] < array[i]) {
				return false;
			}
		}
		
		return true;
	}
}
