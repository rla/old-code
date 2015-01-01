package ee.pri.rl.algorithmics.sort;

import junit.framework.TestCase;

public class CountsortTest extends TestCase {
	
	public void testWithUniqueRandom() {
		int count = 1000;
		int[] array = new int[count];
		
		for (int i = 0; i < count; i++) {
			array[i] = i;
		}
		
		RandomPermutation.permute(array, count);
		Countsort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
		assertTrue(SortUtil.isUnique(array));
	}
}
