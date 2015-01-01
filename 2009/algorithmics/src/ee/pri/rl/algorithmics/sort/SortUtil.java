package ee.pri.rl.algorithmics.sort;

import java.util.Random;

public class SortUtil {
	
	public static int[] generateRandomIntArray(int size, int high) {
		Random random = new Random(System.currentTimeMillis());
		
		int[] array = new int[size];
		for (int i = 0; i < size; i++) {
			array[i] = random.nextInt(high);
		}
		
		return array;
	}
	
	public static int[] generateSortedIntArray(int size, int high, boolean reverse) {
		int[] array = new int[size];
		for (int i = 0; i < size; i++) {
			array[i] = reverse ? size - i : i;
		}
		
		return array;
	}
	
	public static boolean isSorted(int[] a) {
		return isSorted(a, 0, a.length);
	}
	
	public static boolean isSorted(int[] a, int s, int e) {
		for (int i = s; i < e - 1; i++) {
			if (a[i] > a[i + 1]) {
				return false;
			}
		}
		
		return true;
	}
	
	public static int[] subarray(int[] a, int s, int e) {
		int[] sub = new int[e - s];
		
		for (int i = s; i < e; i++) {
			sub[i - s] = a[i];
		}
		
		return sub;
	}
	
	public static boolean isUnique(int[] a) {
		for (int i = 0; i < a.length; i++) {
			for (int j = 0; j < a.length; j++) {
				if (j != i && a[i] == a[j]) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public static void swap(int[] a, int i, int j) {
		int t = a[i];
		a[i] = a[j];
		a[j] = t;
	}
	
	public static int mid(int i, int j) {
		return (i + j) / 2;
	}
}
