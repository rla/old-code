package ee.pri.rl.algorithmics.sort;

import java.util.Arrays;

import junit.framework.TestCase;

public class InPlaceMergesortTest extends TestCase {

	public void testMerge1() {
		
		int[] a = new int[] {1, 8, 9, 4, 6, 5, 2, 3, 7, 7};
		InPlaceMergesort.merge(a, 0, 10, 3, 6);
		
		assertTrue(Arrays.equals(new int[] {4, 6, 5, 1, 2, 3, 7, 7, 8, 9}, a));
	}
	
	public void testMerge2() {
		
		int[] a = new int[] {1, 8};
		InPlaceMergesort.merge(a, 0, 2, 0, 1);
		
		assertTrue(Arrays.equals(new int[] {1, 8}, a));
	}
	
	public void testMerge3() {
		
		int[] a = new int[] {1};
		InPlaceMergesort.merge(a, 0, 1, 0, 1);
		
		assertTrue(Arrays.equals(new int[] {1}, a));
	}
	
	public void testMerge4() {
		
		int[] a = new int[] {1, 8};
		InPlaceMergesort.merge(a, 0, 2, 1, 2);
		
		assertTrue(Arrays.equals(new int[] {8, 1}, a));
	}
	
	public void testWithUniqueRandom() {
		int count = 1000;
		int[] array = new int[count];
		
		for (int i = 0; i < count; i++) {
			array[i] = i;
		}
		
		RandomPermutation.permute(array, count);
		InPlaceMergesort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
		assertTrue(SortUtil.isUnique(array));
	}
	
}
