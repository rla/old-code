package ee.pri.rl.algorithmics.sort;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class MergesortBenchmark {

	public static void main(String[] args) throws IOException {
		File out = new File("data/mergesort.dat");
		
		BufferedWriter writer = new BufferedWriter(new FileWriter(out));
		
		int count = 10000;
		
		while (count <= 10 * 1000 * 1000) {
			System.gc();
			int[] array = SortUtil.generateSortedIntArray(count, Integer.MAX_VALUE, false);
			long start = System.currentTimeMillis();
			
			RandomizedQuicksort.sort(array);
			
			long endRandom = System.currentTimeMillis() - start;
			
			System.gc();
			array = SortUtil.generateSortedIntArray(count, Integer.MAX_VALUE, false);
			start = System.currentTimeMillis();
			
			Mergesort.sort(array);
			
			long endSimple = System.currentTimeMillis() - start;
			
			System.gc();
			array = SortUtil.generateSortedIntArray(count, Integer.MAX_VALUE, false);
			start = System.currentTimeMillis();
			
			InPlaceMergesort.sort(array);
			
			long endInPlace = System.currentTimeMillis() - start; 
			
			System.out.println(count + " " + endRandom + " " + endSimple + " " + endInPlace);
			
			if (count >= 1000) {
				writer.append(count + " " + endRandom + " " + endSimple + " " + endInPlace);
				writer.newLine();
			}
			
			count *= 2;
		}
		
		writer.close();
	}

}
