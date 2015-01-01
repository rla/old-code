package ee.pri.rl.algorithmics.sort;

import junit.framework.TestCase;

public class RandomizedQuicksortTest extends TestCase {
	
	public void testWithRandom() {
		int[] array = SortUtil.generateRandomIntArray(1000, 30);
		
		RandomizedQuicksort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
	}
	
	public void testWithUniqueRandom() {
		int count = 1000;
		int[] array = new int[count];
		
		for (int i = 0; i < count; i++) {
			array[i] = i;
		}
		
		RandomPermutation.permute(array, count);
		RandomizedQuicksort.sort(array);
		
		assertTrue(SortUtil.isSorted(array));
		assertTrue(SortUtil.isUnique(array));
	}
}
