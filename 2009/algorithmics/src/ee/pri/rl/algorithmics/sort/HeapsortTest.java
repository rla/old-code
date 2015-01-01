package ee.pri.rl.algorithmics.sort;

import java.util.Arrays;

import junit.framework.TestCase;

public class HeapsortTest extends TestCase {
	
	public void testMaxHeapify() {
		// "Introduction to Algorithms" page 131
		
		int[] array  = new int[] {16,  4, 10, 14, 7, 9, 3, 2, 8, 1};
		int[] result = new int[] {16, 14, 10,  8, 7, 9, 3, 2, 4, 1};
		
		Heapsort.maxHeapify(array, 1, 0, array.length - 1);
		
		assertTrue(Arrays.equals(array, result));
		assertTrue(Heapsort.isMaxHeap(array));
	}
	
	public void testLeftRight() {
		assertEquals(1, Heapsort.left(0));
		assertEquals(2, Heapsort.right(0));
		
		assertEquals(3, Heapsort.left(1));
		assertEquals(4, Heapsort.right(1));
		
		assertEquals(5, Heapsort.left(2));
		assertEquals(6, Heapsort.right(2));
	}
	
	public void testWithUniqueRandom() {
		int count = 1000;
		int[] array = new int[count];
		
		for (int i = 0; i < count; i++) {
			array[i] = i;
		}
		
		RandomPermutation.permute(array, count);
		Heapsort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
		assertTrue(SortUtil.isUnique(array));
	}
}
