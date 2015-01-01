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

import java.util.Date;

/**
*Käivitatav peafail.
*Käsurealt saab ette andmeruumi konfiguratsioonifaili nime.
*
*OOP projekt "Vares"
*/
	
class Main {

	/**Maksimaalselt koos töötavate lõimede arv*/
	final static int MAX_LOIMI=5;

	public static void main(String[] args) throws Exception {

		Object[] loimed=new Object[MAX_LOIMI];
		Object lukk=new Object();

		/*
		Kui kasutaja unustas käsurealt sisestamata
		andmeruumi konfiuratsioonifaili, siis näitame
		talle sellekohast infot ja väljume.
		*/

		if (args.length==0) {

			System.out.println("Konfiguratsioonifaili nime ei ole ette antud!");
			return;

		}

		/*
		Kui kasutaja jättis käsurealt sisestamata andmeruumi
		parooli, siis näidtata vastavat teadet ja väljuda.
		*/

		if (args.length==1) {

			System.out.println("Andmeruumi faili parooli ei ole ette antud!");
			return;

		}

		/*
		Kui kasutaja jättis käsurealt sisestamata
		soovitud tegevuse nime, siis näidata vastavat teadet ja väljuda.
		*/

		if (args.length==2) {

			System.out.println("Soovitud tegevust pole ette antud!");
			return;

		}

		Andmeruum ar;
		
		/*
		Käivitame tegevuste logija.
		*/

		Logija logija=new Logija(args[0]);

		Date date=new Date();

		logija.logi(args[0]);
		logija.logi(date.toString());

		/*
		Proovime lugeda ette antud konfiuratsioonifaili.
		*/

		try {

			ar=new Andmeruum(args[0], false, logija);

		} catch (AndmeException ae) {

			System.out.println("Viga andmeruumi konfiguratsiooni lugemisel.");
			System.out.println(ae.getMessage());
			return;

		}
		
		//Võtme seadmine.
		ar.setKey(args[1]);
		
		System.out.println("Sisseloetud andmeruumi nimi: " +ar.getNimi());


		/*
		Etteantud tegevuse sooritamine.
		*/

		if ("save".equals(args[2])) {

			/*
			Failide salvestamine hoidlatesse.
			*/

			logija.logi("Salvestamine");

			for (int i=0; i<MAX_LOIMI; i++) {

				loimed[i]=new Salvestaja(ar, logija, i, lukk);
				((Salvestaja)loimed[i]).start();

			}

			/*
			Paneme põhiprogrammi lõimede taha ootama.
			*/
			
			for (int i=0; i<MAX_LOIMI; i++) {
			
				((Salvestaja)loimed[i]).join();
				
			}
			
			/*
			Salvestame andmeruumifaili.
			*/
			
			try {
			
				ar.salvesta();
				
			} catch (AndmeException ae) {
			
				logija.logi("Andmeruumi faili ei õnnestunud salvestada");
			
			}

		} else if ("get".equals(args[2])) {
		
			if (args.length<5) {
			
				System.out.println("'get' tegevus nõuab nii võetava faili nime kui ka tulemuse nime");
				logija.sulge();
				return;
			
			}
		
			logija.logi("Faili " +args[3] +" võtmine");
			
			FailiVotja fv=new FailiVotja(args[3], args[4], args[0], logija, ar);
			
			logija.logi("Faili " +args[3] +" võtmine lõpetatud");
		
		}

		/*
		Sulgeme logija.
		*/

		logija.sulge();

		System.out.println("Programmi lõpp!");

	}

}
