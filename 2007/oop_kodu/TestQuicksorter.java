import java.util.Vector;

/**
 * Kiirsorteerija testklass
 */

public class TestQuicksorter {
	
	public static void main(String[] args) {
		
		// tee esialgne jada ja väljasta see
		
		System.out.println("Esialgne jada: ");
		
		Vector<Integer> data = new Vector<Integer>();
		for (int i = 0; i < 1000; i++) {
			Integer integer = new Integer((int)(Math.random() * 1000));
			data.add(integer);
			System.out.print(integer + " ");
		}
		
		System.out.println();
		
		// sorteeri
		
		Quicksorter<Integer> quicksorter = new Quicksorter<Integer>(data);
		Thread thread = new Thread(quicksorter);
		thread.start();
		try {
			thread.join();
		} catch (InterruptedException e) {
			System.out.println("Lõimede sünkroniseerimisel saime erindi: " + e.getMessage());
		}
		
		System.out.println("Järjend sorteeritud kujul on järgmine:");
		for (Integer integer : data) {
			System.out.print(integer + " ");
		}
		System.out.println();
	}
}
