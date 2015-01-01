package ee.pri.rl.algorithmics.hash;

import java.util.Random;

public class HashTest {

	public static void main(String[] args) {
		int[] counts = new int[13];
		
		Random random = new Random();
		for (int i = 0; i < 1000000; i++) {
			counts[hashFunction(random.nextInt())]++;
		}
		
		for (int i = 0; i < counts.length; i++) {
			System.out.println(i + " " + counts[i]);
		}
	}
	
	private static int hashFunction(int k) {
		int h = (128 * k % 128) >> (7 - 3);
		
		return h < 0 ? -h : h;
	}

}
