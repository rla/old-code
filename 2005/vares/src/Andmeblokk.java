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
import java.util.zip.*;

/**
*Andmeblokk - teatud hulk andmeid.
*Krüpteerimine: Hanno Vene
*Pakkimine: Raivo Laanemets
*/

class Andmeblokk {

	private byte[] andmed;   //Siin hoitakse tegelikke andmeid//
	private int id;          //Samas andmeruumis on iga andmeblokk teistest eristatav id poolest//
	private int suurus;      //Andmebloki andmete kogus - muutub pakkimisel või krüpteerimisel//
	private boolean crypted; //Tõene - andmed krüpeeritud//
	private boolean pakitud; //Tõene - andmed pakitud//
	private int koht;        //Andmeblokis koht, kuhu andmete lisamine viimati jõudis//

	/**
	*Standardkonstruktor.
	*/
	public Andmeblokk(int id, boolean crypted, boolean pakitud, int suurus) {


		this.id=id;

		this.crypted=crypted;
		this.pakitud=pakitud;

		//valmistame ette puhvri andmete hoidmiseks//

		andmed=new byte[suurus];
		this.suurus=suurus;

		koht=0;

	}

	/**
	*Andmebloki andmete vaatamine. Vajalik näiteks
	*hoidlasse salvestamisel.
	*/
	public byte[] votaAndmed() {

		return andmed;

	}

	public Andmeblokk() throws Exception {

		/*
		Seda konstruktorit ei tohi kasutada, sest
		id peab olema määratud.
		*/

		throw new Exception("Andmeblokile tuleb id ette anda!");

	}

	/**
	*Andmebloki nime moodustmine.
	*/
	public String toString() {

		return id+".dbl";

	}

	/**
	*Andmebloki krüpteerimine. Toimub vaid juhul kui andmebloki suurus>0.
	*/
	public void crypt(String key) {

		if (suurus<=0) return;
		try { Crypto.crypt(andmed, key.getBytes("UTF-8")); } catch (Exception e) {}
		crypted=true;

	}

	/**
	*Andmebloki lahtikrüpteerimine. Toimub vaid juhul kui andmebloki suurus>0.
	*/
	public void decrypt(String key) {

		if (suurus<=0) return;
		try { Crypto.crypt(andmed, key.getBytes("UTF-8")); } catch (Exception e) {}
		crypted=false;

	}

	/**
	*Andmebloki pakkimine. Toimub vaid juhul, kui andmebloki suurus>0
	*/
	public void compress() {
	
		int count;
		
		if (suurus<=0) return;

		Deflater compressor=new Deflater();
		compressor.setLevel(Deflater.BEST_COMPRESSION);
		compressor.setInput(andmed);
		compressor.finish();
		
		//muudetava suurusega baidimassiiv
		ByteArrayOutputStream bos=new ByteArrayOutputStream(andmed.length);
		
		byte[] buf=new byte[1024]; //puhver
		
		//pakkimine
		
    		while (!compressor.finished()) {
		
			count=compressor.deflate(buf);
			bos.write(buf, 0, count);
			
    		}
		
		try { bos.close(); } catch (IOException e) {}
    
		//salvestamine andmete masiivi tagasi
		
		andmed=bos.toByteArray();
		suurus=andmed.length;
		
		pakitud=true;

	}

	/**
	*Andmebloki lahtipakkimine.
	*/
	public void decompress() {
	
		int count;
	
		Inflater decompressor=new Inflater();
		decompressor.setInput(andmed);
		ByteArrayOutputStream bos=new ByteArrayOutputStream(andmed.length);
    
		byte[] buf = new byte[1024];
		while (!decompressor.finished()) {
		
			try { count=decompressor.inflate(buf); bos.write(buf, 0, count); }
			catch (Exception e) { return; }
			//System.out.println("OK");

		}
		
		try { bos.close(); } catch (IOException e) {}
    
		andmed=bos.toByteArray();
		suurus=andmed.length;
		
		pakitud=false;

	}

	/**
	*Andmete kirjutamine andmeblokki.
	*/
	public int write(byte[] data, int kogus) {

		//kopeerime etteantud andmed puhvrisse//
		
		for (int i=koht; i<koht+kogus; i++) andmed[i]=data[i-koht];
		koht+=kogus;

		return 0;

	}
	
	/**
	*Baidi kirjutamine andmeblokki.
	*/
	public void write(byte bait) {
	
		andmed[koht]=bait;
		koht++;
	
	}

	/**
	*Andmebloki suuruse saamine.
	*/
	public int votaSuurus() {

		return suurus;

	}
	
	/**
	*Andmebloki identifikaatori saamine.
	*/	
	public int getId() {
	
		return id;
	
	}
	
	/**
	*Andmebloki suuruse muutmine.
	*/
	public void setSize(int i) {
	
		suurus=i;
	
	}

}
