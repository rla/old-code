import java.io.*;

/**
*Klass kohaliku failisüsteemi hoidlana kasutamiseks.
*@author Raivo Laanemets
*/

class FileSystemStore extends Hoidla {

	private File kaust; //ühenduspunkt
	private BufferedOutputStream kirjutaja;

	public FileSystemStore(String conf, int id) throws HoidlaException {

		kaust=new File(conf);
		if (!kaust.isDirectory()) throw new HoidlaException("Hoidla konfiguratsioon on vigane!");
		this.setId(id); //Hoidla identifikaator, kirjeldatud ülemklassis.

	}

	/**
	*Antakse ette andmeblokk, mille andmed salvestatakse sobivalt faili.
	*/
	public void pane(Andmeblokk ab) throws HoidlaException {

		//Avame uue faili.
		try {
		
			kirjutaja=new BufferedOutputStream(new FileOutputStream(kaust +"/" +ab.toString()));
			
		} catch (IOException ioe) {
		
			throw new HoidlaException("Hoidlasse ei saa faile salvestada!");
		
		}

		//Andmebloki kirjutamine.
		try {

			byte[] buffer=ab.votaAndmed(); 
			kirjutaja.write(buffer, 0, ab.votaSuurus());

		} catch (IOException ioe) {

			throw new HoidlaException("Hoidlasse ei saa faile salvestada!");

		}

		//Sulgeme väljundfaili.
		try {

			kirjutaja.close();

		} catch (IOException ioe) {
		}

	}

	public void lopeta() {}

	/**
	*Andmebloki lugemine.
	*/
	public Andmeblokk vota(int id) throws HoidlaException {
	
		Andmeblokk ab=new Andmeblokk(id, true, true, 1000000); //Esialgu fikseeritud suurus
		BufferedInputStream lugeja;
		byte[] puhver=new byte[1000000];
		int size=0;
		int i;
		
		//Avame lugeja
		try { lugeja=new BufferedInputStream(new FileInputStream(kaust+"/" +id +".dbl")); } catch (IOException ioe) { throw new HoidlaException("Faili ei saa avada"); }
	
		//Loeme ja sisestame andmed andmeblokki

		try { size=lugeja.read(puhver); } catch (IOException ioe) {}
		if (size<0) throw new HoidlaException("Viga failist lugemisel!");
		for (i=0; i<size; i++) ab.write(puhver[i]);
		ab.setSize(size);
		
		//Sulgeme lugeja
		try { lugeja.close(); } catch (IOException ioe) {}
		return ab;

	}
	
	/**
	*Hoidla käivitusoperatsioon. Failisüsteemi korral
	*pole tarvis midagi teha.
	*/
	public boolean kaivita() { return true; }

}
