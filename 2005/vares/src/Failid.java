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
*Klass failide seoste lugemiseks ja kirjutamiseks.
*@author Raivo Laanemets
*/

class Failid {

	/**Seostefaili nimi*/
	private String failinimi;
	
	/**Seosed*/
	private Vector seosed;

	/**Ette antakse faili nimi, kust seosed loetakse*/
	public Failid(String failinimi) throws AndmeException {
	
		BufferedReader lugeja;
		String rida;
		String[] kirje;
	
		seosed=new Vector();
		
		//Avame faili
		try { lugeja=new BufferedReader(new FileReader(failinimi)); }
		catch (IOException ioe) { throw new AndmeException("Failide-andmeblokkide seoseid ei õnnestunud lugeda."); }
		
		while (true) {
		
			try { rida=lugeja.readLine(); } catch (IOException ioe) { break; }
			if (rida==null) break;
			kirje=rida.split(":");
			seosed.add(kirje);
			
		}
		
		try { lugeja.close(); } catch (IOException ioe) {};
	
	}
	
	/**
	*Seoste kirjete saamine.
	*/
	public Vector getSeosed() {
	
		return seosed;
	
	}
	
	/**
	*Kontroll, kas antud faili on andmeruumis.
	*/
	public boolean includes(String fail) {
	
		Iterator it=seosed.iterator();
		String[] kirje;
		while (it.hasNext()) {
		
			kirje=(String[])(it.next());
			if (fail.equals(kirje[0])) return true;
		
		}
		
		return false;
	
	}
	
	/**
	*Antud faili moodustavate andmeblokkide võtmine.
	*/
	public int[] votaBlokid(String fail) {
	
		Iterator it=seosed.iterator();
		String[] kirje;
		int count;
		int[] blokid=null;
		int i;
		
		while (it.hasNext()) {
		
			kirje=(String[])(it.next());
			if (fail.equals(kirje[0])) {
			
				count=kirje.length-5; //andmeblokkide arv
				blokid=new int[count];
				for (i=5; i<kirje.length; i++) blokid[i-5]=Integer.parseInt(kirje[i]);
				break;
			
			}
		
		}
		
		return blokid;
	
	}
	
	/**
	*Kirjena võtmine.
	*/
	public int[] kirje(String fail) {
	
		Iterator it=seosed.iterator();
		String[] str_kirje;
		int[] kirje=null;
		int i;
		
		while (it.hasNext()) {
		
			str_kirje=(String[])(it.next());
			if (fail.equals(str_kirje[0])) {
			
				kirje=new int[str_kirje.length-1];
				for (i=1; i<kirje.length; i++) kirje[i-1]=Integer.parseInt(str_kirje[i]);
				break;
			
			}
		
		}
		
		return kirje;
	
	}

}