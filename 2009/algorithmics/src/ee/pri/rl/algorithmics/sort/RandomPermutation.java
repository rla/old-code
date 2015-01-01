package ee.pri.rl.algorithmics.sort;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class RandomPermutation {
	
	public static <T> List<T> randomPermutation(List<T> input, int swaps) {
		List<T> ret = new ArrayList<T>();
		
		for (T e : input) {
			ret.add(e);
		}
		
		Random random = new Random(System.currentTimeMillis());
		for (int i = 0; i < swaps; i++) {
			int i1 = random.nextInt(input.size());
			T e = ret.get(i1);
			int i2 = random.nextInt(input.size());
			ret.set(i1, ret.get(i2));
			ret.set(i2, e);
		}
		
		return ret;
	}
	
	public static void permute(int[] array, int swaps) {
		
		Random random = new Random(System.currentTimeMillis());
		for (int i = 0; i < swaps; i++) {
			int i1 = random.nextInt(array.length);
			int e = array[i1];
			int i2 = random.nextInt(array.length);
			array[i1] = array[i2];
			array[i2] = e;
		}
	}
}
