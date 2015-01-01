package ee.pri.rl.algorithmics.sort;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class RandomizedQuicksortBenchmark {

	public static void main(String[] args) throws IOException {
		File out = new File("data/rquicksort.dat");
		
		BufferedWriter writer = new BufferedWriter(new FileWriter(out));
		
		int count = 100;
		
		while (count <= 100 * 1000) {
			System.gc();
			int[] array = SortUtil.generateSortedIntArray(count, Integer.MAX_VALUE, false);
			long start = System.currentTimeMillis();
			
			RandomizedQuicksort.sort(array);
			
			long endRandom = System.currentTimeMillis() - start;
			
			System.gc();
			array = SortUtil.generateSortedIntArray(count, Integer.MAX_VALUE, false);
			start = System.currentTimeMillis();
			
			Quicksort.sort(array);
			
			long endSimple = System.currentTimeMillis() - start; 
			
			System.out.println(count + " " + endRandom + " " + endSimple);
			
			if (count >= 1000) {
				writer.append(count + " " + endRandom + " " + endSimple);
				writer.newLine();
			}
			
			count *= 2;
		}
		
		writer.close();
	}

}
