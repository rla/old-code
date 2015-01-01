package ee.pri.rl.algorithmics.sort;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class CountsortBenchmark {

	public static void main(String[] args) throws IOException {
		File out = new File("data/countsort.dat");
		
		BufferedWriter writer = new BufferedWriter(new FileWriter(out));
		
		int count = 100;
		
		while (count <= 10 * 1000 * 1000) {
			System.gc();
			int[] array = SortUtil.generateRandomIntArray(count, 10000000);
			long start = System.currentTimeMillis();
			
			Countsort.sort(array);
			
			long endCountsort = System.currentTimeMillis() - start;
			
			System.gc();
			array = SortUtil.generateSortedIntArray(count, 10000000, false);
			start = System.currentTimeMillis();
			
			RandomizedQuicksort.sort(array);
			
			long endRandomizedQuicksort = System.currentTimeMillis() - start; 
			
			if (count >= 1000) {
				writer.append(count + " " + endCountsort + " " + endRandomizedQuicksort);
				writer.newLine();
			}
			
			System.out.println(count);
			
			count *= 2;
		}
		
		writer.close();
	}

}
