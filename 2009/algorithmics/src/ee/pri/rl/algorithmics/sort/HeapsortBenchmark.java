package ee.pri.rl.algorithmics.sort;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class HeapsortBenchmark {

	public static void main(String[] args) throws IOException {
		File out = new File("data/heapsort.dat");
		
		BufferedWriter writer = new BufferedWriter(new FileWriter(out));
		
		int count = 100;
		
		while (count <= 10 * 1000 * 1000) {
			System.gc();
			int[] array = SortUtil.generateRandomIntArray(count, Integer.MAX_VALUE);
			long start = System.currentTimeMillis();
			
			Heapsort.sort(array);
			
			long endHeapsort = System.currentTimeMillis() - start;
			
			System.gc();
			array = SortUtil.generateSortedIntArray(count, Integer.MAX_VALUE, false);
			start = System.currentTimeMillis();
			
			RandomizedQuicksort.sort(array);
			
			long endRandomizedQuicksort = System.currentTimeMillis() - start; 
			
			if (count >= 1000) {
				writer.append(count + " " + endHeapsort + " " + endRandomizedQuicksort);
				writer.newLine();
			}
			
			System.out.println(count);
			
			count *= 2;
		}
		
		writer.close();
	}

}
