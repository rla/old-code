package ee.pri.rl.algorithmics.sort;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class QuicksortBenchmark {

	public static void main(String[] args) throws IOException {
		File out = new File("data/quicksort.dat");
		
		BufferedWriter writer = new BufferedWriter(new FileWriter(out));
		
		int count = 10000;
		
		while (count <= 100 * 1000 * 1000) {
			System.gc();
			int[] array = SortUtil.generateRandomIntArray(count, Integer.MAX_VALUE);
			long start = System.currentTimeMillis();
			
			Quicksort.sort(array);
			System.out.println(count + " " + (System.currentTimeMillis() - start));
			
			if (count >= 1000) {
				writer.append(count + " " + (System.currentTimeMillis() - start));
				writer.newLine();
			}
			
			count *= 2;
		}
		
		writer.close();
	}

}
