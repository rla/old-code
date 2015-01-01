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

import java.lang.Thread;
import java.util.*;
import java.io.*;

/**
*Salvestab kõik failid hoidlatesse.
*@autor Raivo Laanemets
*/

class Salvestaja extends Thread {

	/**Andmebloki suurus baitides*/
	static final int BLOCK_SIZE=1000000;

	private Andmeruum ar;
	private Vector failid;
	private Vector hoidlad;
	private int id;              //Lõime identifikaator.
	private Logija logija;       //Tegevuste logija.
	//private Andmeblokk ab;       //Parajasti kasutatav andmeblokk;
	private int hoidla_suurus;   //Parasjagu kasutatavasse hoidlasse salvestamine.
	private boolean lopetanud;   //true, kui lõim on oma töö lõpetanud.
	private Object lukk;         //Peaprogrammi lukk.
	private byte[] puhver;        //Lugemispuhver.
	private KohalikFail[] buf_failid;   //Puhvris olevad failid.
	private int puhvris;         //Puhvrisse loetud andmete kogus.
	private KohalikFail viimati;      //Viimati loetud kohalik fail.
	private boolean poolik;      //Viimati loetud fail on poolikult loetud?
	private InputStream lugeja;
	private boolean faili_lopp;
	private boolean salvestatud;
	
	/**
	*Ette antakse sisseloetud andmeruum ja logija. Logija
	*salvestab kõik toimingud.
	*/
	public Salvestaja(Andmeruum ar, Logija logija, int id, Object lukk) {

		this.ar=ar;
		failid=ar.votaFailid();
		hoidlad=ar.votaHoidlad();
		this.logija=logija;
		this.id=id;
		lopetanud=false;
		this.lukk=lukk;
		puhver=new byte[BLOCK_SIZE];
		poolik=false;
		puhvris=0;
		faili_lopp=true;
		salvestatud=true;
		viimati=null;

	}

	/**
	*Võtab ühe hoidla ja lukustab selle.
	*/
	private synchronized Hoidla votaHoidla() {

		Hoidla h;

		Iterator it=hoidlad.iterator();
		while (it.hasNext()) {

			h=(Hoidla)(it.next());
			if (!h.onLukustatud()) {
		
				h.lukusta();
				logija.logi("Lõim " +id +" valis hoidla " +h.getId());
				return h;

			}

		}
		
		return null;

	}

	/**
	*Võtab ühe faili ja lukustab selle.
	*/
	private synchronized KohalikFail votaFail() {

		KohalikFail kf;

		Iterator it=failid.iterator();
		while (it.hasNext()) {

			kf=(KohalikFail)(it.next());
			if (!kf.onLukustatud()) {
		
				kf.lukusta();
				logija.logi("Lõim " +id +" valis faili " +kf.votaNimi());
				return kf;

			}

		}
		
		return null;
		
	}
	
	/**
	*Unikaalse andmebloki identifikaatori saamine.
	*/
	private synchronized int getAbId() {
	
		int id=ar.getLastId();
		id++;
		ar.setLastId(id);
		return id;
	
	}

	/**
	*Käivitab ühe salvestuslõime.
	*Hoidla ja failid, mida kasutatakse, lukustatakse.
	*Kõigepealt võtab esimese mittelukustatud hoidla ja
	*hakkab sellesse lukustamata faile salvestama.
	*/
	public void run() {
	
		logija.logi("Lõim " +id +" käivitus");
		
		Hoidla h;
		KohalikFail kf;
		BufferedInputStream lugeja;         //Failist lugeja.
		Andmeblokk ab;

		salvestatud=true;
		ab=null;
		
		while (true) {
			
			h=valiHoidla(); //valime hoidla
			
			if (h==null) return;
			
			while (true) {
			
				if (salvestatud) { ab=moodusta_andmeblokk(); ab.compress(); ab.crypt(ar.getKey()); }
				
				if (ab.votaSuurus()>0) {
					if (!salvesta_ab(ab, h)) { salvestatud=false; break; } else { salvestatud=true; h.addAbId(ab.getId()); }
				} else return;
				
				yield();
				
			}
			

		}
		

	}
	
	/**
	*Andmebloki moodustamine.
	*/
	private Andmeblokk moodusta_andmeblokk() {
	
		int loetud=0;
		int loetud_uus=0;
		int id=getAbId();
		int i;
		int yhik;
		byte bait;
		int vaja_veel=BLOCK_SIZE;
		
		Andmeblokk ab=new Andmeblokk(id, false, false, BLOCK_SIZE);
		
		while (true) {
		
			if (faili_lopp) {

				if (viimati!=null) { viimati.setLopp(id); viimati.setLoppbait(loetud-1); }
				lugeja=valiFail(); faili_lopp=false;
				if (lugeja!=null) {

					viimati.setAlgus(id); viimati.setAlgusbait(loetud);
				
				}
			}
			
			if (lugeja==null) {
				ab.setSize(loetud); return ab;
			}
			
			if (!faili_lopp) { viimati.lisaAndmeblokk(id); }
		
			for (i=0; i<vaja_veel; i++) {
		
				try {
					yhik=lugeja.read(); 
					if (yhik==-1) { faili_lopp=true; break; }
					bait=(byte)yhik;
					ab.write(bait);
				} catch (IOException ioe) { faili_lopp=true; break; }
				loetud++;
		
			}
		
			if (loetud==BLOCK_SIZE) {
				viimati.lisaAndmeblokk(id);
				if (faili_lopp) { viimati.setLopp(id); viimati.setLoppbait(loetud-1); }
				return ab;
			}
		
			if (loetud<BLOCK_SIZE) {
				vaja_veel=BLOCK_SIZE-loetud;
			}
		
		}
	
	}
	
	/**
	*Faili valimine.
	*/
	private InputStream valiFail() {
	
		KohalikFail kf;
	
		while (true) {
	
			kf=votaFail();
			if (kf==null) {
			
				logija.logi("Lõim " +id +" ei leidnud salvestamiseks faili ja lõpetab oma töö");
				return null;
			
			}
				
			lugeja=open(kf);
			if (lugeja==null) continue; //Valime järgmise faili.
			viimati=kf;
			return lugeja;
			
		}
			
	}
	
	/**
	*Kasutatava hoidla valimine.
	*/
	private Hoidla valiHoidla() {
	
		Hoidla h;
	
		while (true) {
			
			h=votaHoidla();
			if (h==null) {
				
				logija.logi("Lõim " +id +" ei leidnud sobivat hoidlat ja lõpetab oma töö");
				break;
				
			}
			
			//Valmistame hoidla ette salvestamiseks.
			
			if (!h.kaivita()) continue;
			
			return h;
			
		}
		
		return null;
	
	}
	
	/**
	*Andmebloki ab salvestamine hoidlasse h. Kui salvestamine
	*ünnestus, siis tagastab true, vastasel korral false.
	*/
	private boolean salvesta_ab(Andmeblokk ab, Hoidla h) {
	
		//Kõigepealt kontrollime suurust.
		if (h.getSize()+ab.votaSuurus()>h.getMaxSize()) return false;
						
		//Proovime salvestada
		try { h.pane(ab); } catch (HoidlaException he) { return false; }
		
		return true;
	
	}
	
	/**
	*Avab voo lugeja andmete lugemiseks.
	*/
	private BufferedInputStream open(KohalikFail kf) {
	
		BufferedInputStream lugeja;
	
		try {
				
			lugeja=new BufferedInputStream(new FileInputStream(kf.votaNimi()));
			return lugeja;
					
		} catch (IOException ioe) { logija.logi("Faili " +kf.votaNimi() +" ei saa avada"); return null; }
	
	}
	
	/**
	*Loeb failist sisend ühe andmebloki andmeid.
	*/
	private Andmeblokk loe_failist(BufferedInputStream lugeja) {
	
		Andmeblokk ab;
		int size;
		byte[] buffer=new byte[BLOCK_SIZE];
		
		try {

                	//Loeme ühe andmebloki. Muutuja size jätab meelde,
                       	//mitu baiti tegelikult loeti.

                        size=lugeja.read(buffer);
			if (size<0) return null;
			
			ab=new Andmeblokk(getAbId(), false, false, size);
			ab.write(buffer, size);
						
			return ab;

               } catch (IOException ioe) { return null; }

	}
	
	/**
	*Tagastab true, kui lõim on oma töö lõpetanud, vastasel
	*korral tagastab false;
	*/
	public synchronized boolean onLopetanud() {
	
		return lopetanud;
	
	}

	/**
	*Peatab andmete salvestamise,
	*eemaldab luku kasutamisel olnud hoidlalt ja faililt.
	*/
	public synchronized void peata() {
	}

}
