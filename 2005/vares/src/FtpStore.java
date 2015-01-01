import java.net.*;
import java.io.*;

/**
*Klass ftp serveri hoidlana kasutamiseks.
*@author Kristjan Vedel
*/

class FtpStore extends Hoidla {

	private BufferedOutputStream kirjutaja;
	private BufferedInputStream lugeja;
	private String serverconf; // ftp serveri url

	public FtpStore(String conf, int id) throws HoidlaException {

		this.serverconf=conf;
		this.setId(id); //Hoidla identifikaator, kirjeldatud ülemklassis.

	}

	/**
	*Antakse ette andmeblokk, mille andmed salvestatakse ftp kaudu sobivalt faili.
	*/
	public void pane(Andmeblokk ab) throws HoidlaException {
		
		URL aburl; // andmebloki url
		URLConnection uc; // ühendus andmebloki urli
		
		//Etteantud stringist URL loomine
		try{
			aburl = new URL(serverconf+"/"+ab.toString());
		}
		catch(MalformedURLException e){
			throw new HoidlaException("URL vigane!");
		}
		//Luuakse ühendus
		try {
			uc = aburl.openConnection();
		}
		catch(IOException ioe) {
			throw new HoidlaException("Ei saa serveriga ühendust");
		}
		//Avame uue faili
		try {
			kirjutaja = new BufferedOutputStream(uc.getOutputStream());
		}
		catch (IOException ioe) {
			throw new HoidlaException("Faili ei saa kirjutamiseks avada!");
		}
		//Andmebloki kirjutamine.
		try {
			byte[] buffer=ab.votaAndmed(); 
			kirjutaja.write(buffer, 0, ab.votaSuurus());
		}
		catch (IOException ioe) {
			throw new HoidlaException("Hoidlasse ei saa faile salvestada!");
		}
		//Sulgeme väljundfaili.
		try {
			kirjutaja.close();
		}
		catch (IOException ioe) {
		}
	}

	public void lopeta() {}

	/**
	*Andmebloki lugemine.
	*/
	public Andmeblokk vota(int id) throws HoidlaException {

		System.out.println("FTP lugemine");
	
		Andmeblokk ab=new Andmeblokk(id, true, true, 1000000); //Esialgu fikseeritud suurus
		byte[] puhver=new byte[1000000];
		int size=0;
		int full_size=0;
		int i;
		URL aburl;
		URLConnection uc;
		
		//Etteantud stringist URL loomine
		try{
			aburl=new URL(serverconf+"/"+id+".dbl");
		}
		catch(MalformedURLException e){
			throw new HoidlaException("URL vigane!");
		}
		//Luuakse ühendus
		try {
			uc=aburl.openConnection();
		}
		catch(IOException ioe) {
			throw new HoidlaException("Ei saa ühendust");
		}
				
		//Faili avamine lugemiseks
		try {
			lugeja=new BufferedInputStream(uc.getInputStream());
		}
		catch(IOException ioe) {
			throw new HoidlaException("Faili ei saa lugemiseks avada");
		}
	
		//Loeme ja sisestame andmed andmeblokki

		System.out.println("Lugemise algus");
		
		while (true) {
			
			try { size=lugeja.read(puhver); } catch (IOException ioe) { throw new HoidlaException("Ei saa faili lugeda"); }
			
			if (size<0) break;
		
			for (i=0; i<size; i++) ab.write(puhver[i]);
			full_size+=size;
		
        	}

		//try { size=lugeja.read(puhver); } catch (IOException ioe) { throw new HoidlaException("Ei saa faili lugeda"); }
		//if (size<0) throw new HoidlaException("Viga failist lugemisel!");
		
		System.out.println("Loetud andmebloki suurus=" +full_size);
		
		//System.out.println(new String(puhver));
		
		//for (i=0; i<size; i++) ab.write(puhver[i]);
		ab.setSize(full_size);

		System.out.println("Lugemise lõpp");
		
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
