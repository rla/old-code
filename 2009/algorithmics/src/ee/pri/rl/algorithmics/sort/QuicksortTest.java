package ee.pri.rl.algorithmics.sort;

import junit.framework.TestCase;

public class QuicksortTest extends TestCase {
	
	public void testPartition1() {
		int[] array = new int[] {2, 3};
		Quicksort.partition(array, 0, 1);
		
		assertEquals(2, array[0]);
		assertEquals(3, array[1]);
	}
	
	public void testPartition2() {
		int[] array = new int[] {3, 2};
		Quicksort.partition(array, 0, 1);
		
		assertEquals(2, array[0]);
		assertEquals(3, array[1]);
	}
	
	public void testWithRandom() {
		int[] array = SortUtil.generateRandomIntArray(1000, 30);
		
		Quicksort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
	}
	
	public void testWithSorted() {
		int[] array = SortUtil.generateSortedIntArray(1000, 3, false);
		
		Quicksort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
	}
	
	public void testWithUniqueRandom() {
		int count = 1000;
		int[] array = new int[count];
		
		for (int i = 0; i < count; i++) {
			array[i] = i;
		}
		
		RandomPermutation.permute(array, count);
		Quicksort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
		assertTrue(SortUtil.isUnique(array));
	}
}
