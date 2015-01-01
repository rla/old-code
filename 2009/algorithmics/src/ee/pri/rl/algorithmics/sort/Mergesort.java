package ee.pri.rl.algorithmics.sort;

/**
 * Traditional mergesort with aux array that is used
 * for merging algorithm.
 */
public class Mergesort {
	
	/**
	 * Sorts the whole array with mergesort.
	 */
	public static void sort(int[] array) {
		int[] aux = new int[array.length];
		sort(array, 0, array.length - 1, aux);
	}

	private static void sort(int[] array, int start, int end, int[] aux) {
		if (end > start) {
			int mid = SortUtil.mid(start, end);
			sort(array, start, mid, aux);
			sort(array, mid + 1, end, aux);
			merge(array, start, end, mid, aux);
		}
	}

	private static void merge(int[] array, int start, int end, int mid, int[] aux) {
		
		assert start < end;
		assert start <= mid;
		assert mid <= end;
		
		int i = start;
		int j = mid + 1;
		int k = 0;
		
		// Take elements selectively from left and right areas
		
		while (i <= mid && j <= end) {
			if (array[i] <= array[j]) {
				aux[k] = array[i];
				i++;
			} else {
				aux[k] = array[j];
				j++;
			}
			k++;
		}
		
		// Copy remaining elements from left sorted place
		
		while (i <= mid) {
			aux[k] = array[i];
			i++;
			k++;
		}
		
		// Copy remaining elements from right sorted place
		
		while (j <= end) {
			aux[k] = array[j];
			j++;
			k++;
		}
		
		// Copy merged elements back to original array
		
		for (k = start; k <= end; k++) {
			array[k] = aux[k - start];
		}
	}
}
