package ee.pri.rl.algorithmics.sort;

/**
 * Mergesort that does not use additional space
 * for merging part.
 * 
 * Ideas: J.Katajainen, T.Pasanen, J.Teuhola, "Practical in-place mergesort"
 */
public class InPlaceMergesort {

	/**
	 * Sorts the whole array with in-place mergesort.
	 */
	public static void sort(int[] array) {
		sortMerge(array, 0, array.length, array.length);
	}
	
	/**
	 * Primary sorting method.
	 * 
	 * @param array Array to be sorted.
	 * @param start Atart of the area to sort.
	 * @param end End of the are to sort.
	 * @param sorted Start of the area that is already sorted.
	 */
	private static void sortMerge(int[] array, int start, int end, int sorted) {
		
		assert start <= end;
		assert sorted <= end;
		assert start >= 0;
		assert end <= array.length;
		
		if (sorted - start > 1) {
			
			// Split the area to be sorted into two
			int mid = SortUtil.mid(start, sorted);
			
			assert mid - start <= sorted - mid;
			
			// Sort the left side (P1')
			sortMerge(array, start, mid, mid);
			
			assert SortUtil.isSorted(array, start, mid);
			
			// Merge P1' with the already sorted elements (Q')
			merge(array, start, end, mid, sorted);
			
			// Sort and merge the remaining part (P2'')
			sortMerge(array, start, end, sorted - (mid - start));
			
			assert SortUtil.isSorted(array, start, end);
			
		} else if (sorted - start == 1) {
			// Merge leftmost element (from last working area) to the sorted array
			int left = array[start];
			for (int i = end - 1; i > start; i--) {
				if (array[i] < left) {
					for (int j = start; j < i; j++) {
						array[j] = array[j + 1];
					}
					array[i] = left;
					break;
				}
			}
		}
	}
	
	/**
	 * Merges two sorted areas using the work space on the same array.
	 * 
	 * @param array Base array.
	 * @param start Start of sortable area.
	 * @param end End of sortable area.
	 * @param working Start of work area.
	 * @param sorted Start of sorted area.
	 */
	public static void merge(int[] array, int start, int end, int working, int sorted) {		
		int i = start;                                            // position in left sorted area
		int sorted1 = end - ((end - sorted) + (working - start)); // position from which the new sorted area will start
		int j = sorted1;                                          // position to put next element into
		int k = sorted;                                           // position in right sorted area
		
		assert SortUtil.isSorted(array, start, working);
		assert SortUtil.isSorted(array, sorted, end);
		
		while (j < end) {
			
			assert j >= start;
			assert j < end;
			
			if (i < working && k < end && array[i] < array[k]) {
				// Take element from left area
				SortUtil.swap(array, i, j);
				i++;
			} else if (i < working && k < end && array[i] >= array[k]) {
				// Take element from right area
				SortUtil.swap(array, k, j);
				k++;
			} else if (i >= working) {
				
				// Out of elements on left
				// Just take element from right
				
				assert k < end;
				assert k >= sorted;
				
				SortUtil.swap(array, k, j);
				k++;
			} else if (k >= end) {
				
				// Out of element on right
				// Just take element from left
				
				assert i < working;
				assert i >= start;
				
				SortUtil.swap(array, i, j);
				i++;
			} else {
				throw new RuntimeException("Algorithm error");
			}
			j++;
		}
		
		assert SortUtil.isSorted(array, sorted1, end);
	}

}