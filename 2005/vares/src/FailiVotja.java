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

/**
*Ühe faili võtmine hoidlast.
*@author Raivo Laanemets
*/

class FailiVotja {


	/**
	*Ette antakse faili nimi, mida soovitakse kätte saada.
	*/
	public FailiVotja(String failinimi, String kuhu, String ar_nimi, Logija logija, Andmeruum ar) {
	
		//Avame seostefaili.
		
		BufferedReader lugeja;
		BufferedOutputStream kirjutaja;
		String rida;
		int i;
		char ch;
		int state=0;
		String fnimi="";
		int lastpos=0;
		boolean leitud=false;
		int v_hoidla=-1; //viimati kasutatud hoidla.
		int v_blokk=-1;  //viimati võetud blokk.
		Hoidla h=null;
		int hoidla_id=0;
		Andmeblokk ab=null;
		int[] f_kirje; //faili parameetrid (algusblokk, algusbait, lõppblokk, lõppbait)
		
		try {
		
			lugeja=new BufferedReader(new FileReader(ar_nimi +".failid"));
		
		} catch (IOException ioe) {
		
			logija.logi("Seostefaili ei õnnestunud avada.");
			return;
		
		}
		
		//Leiame soovitud faili asukoha andmeblokkide suhtes.
		
		Failid fa;		
		try { fa=new Failid(ar_nimi +".failid"); } catch (AndmeException ae) { logija.logi(ae.getMessage()); return; }
		
		//Vaatame, kas soovitud fail on olemas andmeruumis.
		if (!fa.includes(failinimi)) { logija.logi("Sobivat faili ei leitud andmeruumist!"); return; }
		
		//Võtame faili moodustavate andmeblokkide nimekirja.
		int[] blokid=fa.votaBlokid(failinimi);
			
		//Avame tulemusfaili.
			
		try {
		
			kirjutaja=new BufferedOutputStream(new FileOutputStream(kuhu));
		
		} catch (IOException ioe) {
		
			logija.logi("Tulemusfaili ei õnnestunud avada.");
			return;
		
		}
		
		//Avame andmeblokkide-hoidlate seosed.
		
		Andmeblokid abh;
		try { abh=new Andmeblokid(ar_nimi +".andmeblokid"); } catch (AndmeException ae) { logija.logi(ae.getMessage()); return; }
		
		//Andmete saamine hoidlatest ja salvestamine kohalikku faili.
		
		for (i=0; i<blokid.length; i++) {
		
			//Kontrollime, kas blokk on juba võetud. Blokid on naturaalse järjestusega,
			//aga võivad korduda (probleemid vastava faili loomisel vt. Salvestaja.java).
			if (blokid[i]==v_blokk) continue;
			
			//Võtame bloki hoidla
			hoidla_id=abh.hoidlaId(blokid[i]);
			if (hoidla_id==-1) { logija.logi("Puudub hoidla faili moodustavale andmeblokile"); return; }
			
			System.out.println("Hoidla: " +hoidla_id);
			
			//Võtame kasutusele uue hoidla.
			if (hoidla_id!=v_hoidla) {
			
				//Leiame antud identifikaatoriga hoidla.
				try { h=ar.votaHoidla(hoidla_id); } catch (AndmeException ae) { logija.logi(ae.getMessage()); return; }
				//Valmistame hoidla ette.
				h.kaivita();
			
			}
			
			//Võtame andmebloki.
			try { ab=h.vota(blokid[i]); } catch (HoidlaException he) { logija.logi(he.getMessage()); return; }
			
			System.out.println("Võetud andmebloki dekrüpteerimine");

			//Dekrüpeerime bloki
			ab.decrypt(ar.getKey());
			
			//Pakime bloki lahti
			ab.decompress();

			System.out.println("Andmeblokk lahti pakitud");
			
			//Võtame kirje faili kohta	
			f_kirje=fa.kirje(failinimi);
			
			//1. Kui faili algus ja lopp on samas blokis.
			if (f_kirje[0]==f_kirje[2] && f_kirje[2]==blokid[i]) {
			
				System.out.println("Fail on tervenisti blokis " +blokid[i]);
				try { kirjutaja.write(ab.votaAndmed(), f_kirje[1], f_kirje[3]-f_kirje[1]+1); } catch (IOException ioe) { logija.logi("Tulemusfaili ei saa kirjutada"); return; } //kirjutame faili.
				h.lopeta(); //lõpetame hoidla töö
				break; //väljume salvestustsüklist
			
			}
			//2. Fail algas antud blokis, aga lõpeb mujal
			else if (f_kirje[0]==blokid[i] && f_kirje[0]!=f_kirje[2]) {
			
				System.out.println("Fail algas blokis " +blokid[i]);
				try { kirjutaja.write(ab.votaAndmed(), f_kirje[1], ab.votaSuurus()-f_kirje[1]); } catch (IOException ioe) { logija.logi("Tulemusfaili ei saa kirjutada"); return; }
			
			}
			//3. Fail lõpeb antud blokis, aga algas mujal
			else if (f_kirje[2]==blokid[i] && f_kirje[0]!=f_kirje[2]) {
			
				System.out.println("Fail lõppes blokis " +blokid[i]);
				try { kirjutaja.write(ab.votaAndmed(), 0, f_kirje[3]+1); } catch (IOException ioe) { logija.logi("Tulemusfaili ei saa kirjutada"); return; }
				h.lopeta(); //lõpetame hoidla töö
				break; //väljume salvestustsüklist
			
			}
			//4. Fail jätkub antud blokiga (ei ole ükski eespool olevatest juhtumitest)
			else {
			
				System.out.println("Fail jätkub blokis " +blokid[i]);
				try { kirjutaja.write(ab.votaAndmed(), 0, ab.votaSuurus()); } catch (IOException ioe) { logija.logi("Tulemusfaili ei saa kirjutada"); return; }
			
			}
			
			v_blokk=blokid[i];
			v_hoidla=hoidla_id;
		
		}
		
		//Sulgeme tulemusfaili
		try { kirjutaja.flush(); kirjutaja.close(); } catch (IOException ioe) {};
	
	}

}
