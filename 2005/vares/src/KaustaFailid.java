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

import java.io.File;
import java.util.Vector;

/**
*Läbib ühe kausta ja selle alamkausta,
*kirjutades üles failide nimed koos teega.
*
*Osa OOP projektist "Vares".
*@author Raivo Laanemets
*/

class KaustaFailid extends Vector {

	/**
	*Põhikonstruktor. Ette antakse kausta nimi.
	*@param kaustanimi etteantav kaustanimi, millest faile otsitakse.
	*/
	public KaustaFailid(String kaustanimi) {

		loeKaust(kaustanimi);

	}

	//Rekursiivselt faile otsiv meetod.
	private void loeKaust(String nimi) {

		File kaust=new File(nimi);

		if (kaust.isFile()) {

			add(nimi);
			return;

		}

		String[] failid=kaust.list();

		if (failid==null) return;

		for (int i=0; i<failid.length; i++) loeKaust(nimi +'/' +failid[i]);

	}

}
