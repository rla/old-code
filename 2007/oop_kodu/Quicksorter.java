import java.util.Vector;

/**
 * Kiirsorteerija, mis käivitub eraldi lõimes.
 */

public class Quicksorter<D extends Comparable> implements Runnable {
	private Vector<D> data;
	
	/**
	 * Põhikonstruktor, mis saab ette sorteeritava
	 * järjendi.
	 */
	
	public Quicksorter(Vector<D> data) {
		this.data = data;
	}

	/**
	 * Rakendame sorteerimist kiirmeetodil. Vasakule paigutame
	 * valikuelemendist väiksemad elemendid ja paremale
	 * ülejäänud elemendid.
	 */
	
	@SuppressWarnings("unchecked")
	public void run() {
		
		// baasi kontroll, jada suurusega 1 või väiksem on juba sorteeritud kujul
		
		if (data.size() <= 1) {
			return;
		} else {
			Vector<D> left = new Vector<D>();
			Vector<D> right = new Vector<D>();
			D choose = data.get(0);
			
			data.remove(0);

			// jaga esialgne jada kaheks
			
			for (D element : data) {
				if (element.compareTo((D) choose) < 0) {
					left.add(element);
				} else {
					right.add(element);
				}
			}
			
			// sorteeri mõlemad pooled
			
			Thread leftThread = new Thread(new Quicksorter(left));
			Thread rightThread = new Thread(new Quicksorter(right));
			
			leftThread.start();
			rightThread.start();
			
			// oota kuni mõlemad lõpetavad
			
			try {
				leftThread.join();
				rightThread.join();
			} catch (InterruptedException e) {
				System.out.println("Lõimede sünkroniseerimisel saime erindi: " + e.getMessage());
				return;
			}
			
			// tühjendame esialgse vektori
			
			data.clear();
			
			// lisame sinna vasakpoolsed, keskmise ja parempoolsed elemendid
			
			data.addAll(left);
			data.add(choose);
			data.addAll(right);
			
			// kirjuta välja töö tulemus
			
			printInformation(data);
		}
	}
	
	/**
	 * Sorteerija töö tulemuse väljastaja. Siin on ta realiseeritud
	 * sünkroniseeritud staatilises meetodis, et teised lõimed ei saaks
	 * oma infot vahele kirjutada.
	 */
	
	private synchronized static void printInformation(Vector data) {
		System.out.println("Lõim " + Thread.currentThread() + " lõpetas töö, mille tulemusena saadi sorteeritud järjend: ");
		for (Object object : data) {
			System.out.print(object + " ");
		}
		System.out.println();
	}

}
