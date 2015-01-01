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

package vares2;

import java.io.*;
import java.util.*;

/**
*Klass andmeblokkide seoste lugemiseks ja kirjutamiseks.
*@author Raivo Laanemets
*/

class Andmeblokid {

	/**Seostefaili nimi*/
	private String failinimi;

	/**Hoidlad*/
	private Vector hoidlad;

	/**Ette antakse faili nimi, kust seosed loetakse*/
	public Andmeblokid(String failinimi) throws AndmeException {

		BufferedReader lugeja;
		String rida;
		String[] str_kirje;
		int[] kirje;
		int i;

		hoidlad=new Vector();

		//Avame faili
		try { lugeja=new BufferedReader(new FileReader(failinimi)); }
		catch (IOException ioe) { throw new AndmeException("Andmeblokkide-hoidlate seoseid ei õnnestunud lugeda."); }

		while (true) {

			try { rida=lugeja.readLine(); } catch (IOException ioe) { break; }
			if (rida==null) break;
			str_kirje=rida.split(":");
			kirje=new int[str_kirje.length];
			for (i=0; i<str_kirje.length; i++) kirje[i]=Integer.parseInt(str_kirje[i]); //konvertimine täisärvudeks
			hoidlad.add(kirje);

		}

		try { lugeja.close(); } catch (IOException ioe) {};

	}

	/**
	*Hoidlate kirjete saamine.
	*/
	public Vector getHoidlad() {

		return hoidlad;

	}

	/**
	*Antud identifikaatoriga andmebloki hoidla saamine. Kui
	*vastavat hoidlat ei leidu, siis tagastatakse -1.
	*Mõttekam oleks ennem luua indeks andmeblokkide id-de peale.
	*/
	public int hoidlaId(int id) {

		int[] kirje;
		Iterator it=hoidlad.iterator();
		int i;
		while (it.hasNext()) {

			kirje=(int[])(it.next());
			for (i=1; i<kirje.length; i++) if (kirje[i]==id) return kirje[0];

		}

		return -1;

	}

}
