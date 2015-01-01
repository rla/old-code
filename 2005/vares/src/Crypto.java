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

import java.util.Random;

/*
 * Created on 24.04.2005
 */

/**
 *Staatiline krüpteerimisklass
 *@author Hanno Vene
 */
public class Crypto {
    /**
     * Krüpteerimismeetod baidi põhine
     * @param data
     * @param key
     * @return byte []
     */
	public static byte [] crypt(byte [] data,byte[] key) {
		int k=0;
		for (int i=0; i<data.length; i++) {
		
			data[i]=(byte)(data[i]^key[k]); //krüpeerimine, ^ on xor tehe.
			k++;
			if (k-key.length==0) k=0;
		
		}
	    return data;
	}
	/**
	 * Küpteerimismeetodi Stringi teisend
	 * @param data
	 * @param key
	 * @return data
	 */
	public static String crypt(String data,String key) {
	    return new String(crypt(data.getBytes(),key.getBytes()));
	}
	/**
	 * Võtme tegemine
	 * @param length
	 * @return key
	 */
	public static String makeKey(int len) {
	    Random rnd = new Random(); 
	    int tmp;
	    String result = "";
	    for (int i=0; i < len; i++) {
	        tmp = rnd.nextInt(6);
	        if (tmp <= 2) result += ""+rnd.nextInt(9);
	        else result += ""+(char) (65+rnd.nextInt(6));
	    }
	    return result;
	}
	/**
	 * Võtme vaikimisi pikkusega 10 märki tegemine
	 * @return
	 */
	public static String makeKey() {
	    return makeKey(10);    
	}
	/**
	 * Peameetod testimaks antud staatilist klassi
	 * @param args
	 */
	public static void main(String [] args) {
	    System.out.println(makeKey());
	}

}
