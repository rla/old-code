import java.io.*;
/**
*Tegevuste logiraamatu kirjutaja.
*/
class Logija {

	/**
	*Tegevuste logija.
	*/

	private PrintWriter kirjutaja;

	/**
	*Ette anda tuleb andmeruumi nimi.
	*Log fail salvestatakse samasse kausta.
	*/
	public Logija(String ar) {

		String koht=".";
		File kaust=new File(ar);

		if (kaust.getParent()!=null) koht=kaust.getParent();

		try {

			kirjutaja=new PrintWriter(new FileWriter(koht +"/" +kaust.getName() +".log", true));

		} catch (Exception ioe) {

			kirjutaja=null;
			System.out.println("Kirjutaja ei tööta!");

		}

	}

	public void sulge() {

		if (kirjutaja==null) return;

		try {

			kirjutaja.close();

		} catch (Exception ioe) {}
		
		kirjutaja=null;

	}

	public void logi(String s) {

		if (kirjutaja!=null) kirjutaja.println(s);

	}

}
