package ee.pri.rl.algorithmics.sort;

public class Countsort {
	
	public static void sort(int[] array) {
		int min = Integer.MAX_VALUE;
		int max = Integer.MIN_VALUE;
		
		for (int i : array) {
			if (i < min) {
				min = i;
			}
			if (i > max) {
				max = i;
			}
		}
		
		int[] counts = new int[max - min + 1];
		
		for (int i = 0; i < counts.length; i++) {
			counts[i] = 0;
		}
		
		for (int i : array) {
			counts[i - min]++;
		}
		
		int j = 0;
		for (int i = 0; i < counts.length; i++) {
			for (int k = 0; k < counts[i]; k++) {
				array[j] = min + i;
				j++;
			}
		}
	}
}
