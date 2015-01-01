package ee.pri.rl.benchmark;

/**
 * Kiirustestide algobjekt.
 * 
 * @author raivo
 */
public abstract class Benchmark {
	private String description;

	
	public Benchmark() {
		this("Tundmatu nimega");
	}

	public Benchmark(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	public long cycle() {
		long start = System.currentTimeMillis();
		benchmark();
		return System.currentTimeMillis()-start;
	}
	
	public void run(int n) {
		System.out.println("Käivitan kiirustesti: " + description);
		System.out.println("Tsüklite arv: " + n);
		long sum = 0;
		for (int i = 0; i < n; i++) {
			sum += cycle();
		}
		System.out.println("Aega läks kokku: " + sum + "ms");
		System.out.println("Keskmine aeg: " + (sum/n) + "ms");
		System.out.println("Mälukasutus: " + getMemoryUsage());
	}
	
	public void run() {
		run(1);
	}
	
	public abstract void benchmark();
	
	public long getMemoryUsage() {
		return 0;
	}
	
	public static long memoryUsage() {
		return Runtime.getRuntime().totalMemory() - Runtime.getRuntime().totalMemory();
	}

}
