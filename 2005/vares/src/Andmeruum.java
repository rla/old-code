/*
    This file is part of Vares.

    Vares is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Vares is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Vares; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

import java.io.*;
import java.util.*;

/**
*Andmeruumi konfiguratsioonifaili lugemine
*või uue konfiguratsiooni loomine.
*
*@author Raivo Laanemets
*/
	
class Andmeruum {

	private int maht;       //andmeruumi maht MB
	private String nimi;    //andmeruumi nimi
	private Vector failid;  //salvestatavate failide nimekiri
	private Vector hoidlad; //hoidlate massiiv
	private Logija logija;  //Tegevuste logi.
	private int lastid;     //Andmebloki id (salvestamisel jms. toimingutel erinevate andmeblokkide unikaalseks identifitseerimiseks)..
	private String failinimi;
	private String voti;    //Andmeruumi lahtikrüpeerimise võti

	/**
	*Loeb failist sisse andmeruumi seadistused, vajadusel
	*teeb uue faili. Samuti antakse ette logija.
	*/
	Andmeruum(String failinimi, boolean uus, Logija logija) throws AndmeException {

		nimi="";

		hoidlad=new Vector();
		failid=new Vector();
		this.logija=logija;
		lastid=0;

		if (!uus) try {

			logija.logi("Andmeruumi lugemine failist " +failinimi);
			loeFailist(failinimi);

		} catch (AndmeException ae) {

			throw ae;

		}
		
		this.failinimi=failinimi;

	}

	Andmeruum() throws AndmeException {

		/*
		Selle konstruktori kasutamise korral
		peab tekitama erindi.
		*/

	}
	
	/**
	*Tagastab andmeruumi nime.
	*/
	public String getNimi() {
	
		return nimi;
	
	}

	/**
	*Loeb lahti hoidla konfiguratsiooni ja
	*lisab vastava hoidla hoidlate massiivi.
	*/
	private void ParseHoidla(String rida) {

		String tyyp=""; //Hoidla tüüp.
		String conf=""; //Hoidla konfiguratsioon.
		int id=0;       //Hoidla id.
		char ch;
		int state=0;
		int lastpart=0;
		int size=0;
		Hoidla h=null;

		for (int i=0; i<rida.length(); i++) {

			ch=rida.charAt(i);
			if (ch==';' && state==0) {
			
				id=Integer.parseInt(rida.substring(0, i));
				lastpart=i;
				state++;
			
			}
			else if (ch==';' && state==1) {

				tyyp=rida.substring(lastpart+1, i);
				lastpart=i;
				state++;

			} else if (ch==';' && state==2) {

				conf=rida.substring(lastpart+1, i);
				lastpart=i;
				state++;

			} else if (ch==';' && state==3) {
			
				size=Integer.parseInt(rida.substring(lastpart+1, i));
				lastpart=i;
				state++;
			
			}

		}

		//Hoidla lisamine vastavalt tüübile.
		if ("FS".equals(tyyp)) {

			try {

				h=new FileSystemStore(conf, id);

			} catch (Exception he) {

				System.out.println("Hoidla ühendamine ei õnnestunud!\r\n" +he.getMessage());
				return;

			}
		

		} else if ("FTP".equals(tyyp)) {

			try {

				h=new FtpStore(conf, id);
			
			}

			catch (Exception he) {

				System.out.println("Hoidla ühendamine ei õnnestunud!\r\n" +he.getMessage());
				return;
			}
		}
		
		h.setMaxSize(size);
		hoidlad.add(h);
	

	}

	private void loeFailist(String failinimi) throws AndmeException {

		BufferedReader lugeja;
		String rida;
		int koht=0;  //parseri asukoht
		int count=0; //ridade loendur
		
		/*
		Kõigepealt üritame avada faili.
		*/

		try {
		
			lugeja=new BufferedReader(new FileReader(failinimi));

		} catch (FileNotFoundException fnof) {

			throw new AndmeException("Andmeruumi faili ei suudetud avada.");

		}
		
		/*
		Andmete lugemine.
		*/
		
		while (true) {
		
			try {
			
				rida=lugeja.readLine();
				if (rida==null) break;
			
			} catch (IOException ioe) {
				
				break;
				
			}
			
			if ("***".equals(rida)) {
				koht++;
				continue;
			}
			
			if (koht==0 && count==3) {
			
				nimi=rida;
			
			}

			if (koht==1) {

				//Loeme hoidlate osa.
				ParseHoidla(rida);

			}

			if (koht==2) {

				//Lisame faili. Kui tegemist on kaustaga, siis
				//lisame terve kaustatäie faile.
				
				KaustaFailid kf=new KaustaFailid(rida);
				Iterator it=kf.iterator();
				
				while (it.hasNext()) {
					failid.add(new KohalikFail((String)it.next()));
				}

			}
			
			//System.out.println(rida);
			count++;
		
		}
		
		/*
		Faili sulgemine.
		*/
		
		try {
		
			lugeja.close();
		
		} catch(IOException ioe) {
		
			throw new AndmeException("Andmeruumi faili ei saanud sulgeda.");
		
		}

	}

	public Vector votaFailid() {

		return failid;

	}

	public Vector votaHoidlad() {

		return hoidlad;

	}
	
	public int getLastId() {
	
		return lastid;
	
	}
	
	public void setLastId(int id) {
	
		lastid=id;
	
	}
	
	public void salvesta() throws AndmeException {
	
		PrintWriter kirjutaja;
		
		try {
		
			kirjutaja=new PrintWriter(new FileWriter(failinimi+".failid"));
		
		} catch (IOException ioe) {
		
			throw new AndmeException("Faili seoseid ei õnnestunud salvestada.");
		
		}
		
		//Esialgu salvestame erinevasse faili
		//salvestatud failide nimekirja.
		
		Iterator it=failid.iterator();
		KohalikFail h;
		String ab_str="";
		
		while (it.hasNext()) {
		
			ab_str="";
			h=(KohalikFail)it.next();
			Iterator it2=h.andmeblokid().iterator();
			while (it2.hasNext()) ab_str+=":" +((Integer)it2.next()).intValue();
			kirjutaja.println(h.votaNimi() +":" +h.votaAlgus() +":" +h.votaAlgusbait() +":" +h.votaLopp() +":" +h.votaLoppbait() +ab_str);
		}
		
		kirjutaja.close();
		
		try {
		
			kirjutaja=new PrintWriter(new FileWriter(failinimi+".andmeblokid"));
		
		} catch (IOException ioe) {
		
			throw new AndmeException("Andmeblokkide seoseid ei õnnestunud salvestada.");
		
		}
		
		//Esialgu salvestame erinevasse faili
		//salvestatud andmeblokkide nimekirja.
		
		it=hoidlad.iterator();
		Hoidla h_1;
		ab_str="";
		
		while (it.hasNext()) {
		
			ab_str="";
			h_1=(Hoidla)it.next();
			ab_str="" +h_1.getId();
			Iterator it2=h_1.getAndmeblokid().iterator();
			while (it2.hasNext()) ab_str+=":" +((Integer)it2.next()).intValue();
			kirjutaja.println(ab_str);
		}
		
		kirjutaja.close();
	
	}
	
	/**
	*Antud identifikaatoriga hoidla võtmine.
	*/
	public synchronized Hoidla votaHoidla(int id) throws AndmeException {
	
		Iterator it=hoidlad.iterator();
		Hoidla h;
		while (it.hasNext()) {
		
			h=(Hoidla)(it.next());
			if (h.getId()==id) return h;
		
		}
		
		return null;
	
	}
	
	/**
	*Võtme seadmine.
	*/
	public void setKey(String voti) {
	
		this.voti=voti;
	
	}
	
	/**
	*Võtme saamine.
	*/
	public String getKey() {
	
		return voti;
	
	}

}
