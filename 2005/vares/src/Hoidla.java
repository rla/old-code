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

import java.util.*;

/**
*Hoidlate alusklass.
*@author Raivo Laanemets
*/

abstract class Hoidla {

	/**Lukustusmehanism mitme lõime kasutamisel.*/
	private boolean lukustatud;
	
	/**Hoidla identifikaator.*/
	private int id;
	
	/**Maksimaalne hoidlasse salvestatud info hulk(B).*/
	private long max_size;
	
	/**Hoidlasse salvestatud info hulk(B).*/
	private long size;
	
	/**Hoidlas olevad andmeblokid(andmeblokkide identifikaatorid).*/
	private Vector andmeblokid;

	/**Andmebloki salvestamine hoidlasse.*/
	public abstract void pane(Andmeblokk ab) throws HoidlaException;
	
	/**Andmebloki võtmine hoidlast*/
	public abstract Andmeblokk vota(int id) throws HoidlaException;
	
	/**Hoidla kasutamise lõpetamine, sulgeb ühenduse vms.*/
	public abstract void lopeta();
	
	/**Valmistab hoidla ette andmete salvestamiseks.*/
	public abstract boolean kaivita();

	public Hoidla() {

		lukustatud=false;
		id=0;
		max_size=0;
		size=0;
		andmeblokid=new Vector();

	}

	/**
	*Lukustab antud hoidla.
	*/
	public void lukusta() {

		lukustatud=true;

	}

	/**
	*Vabastab antud hoidla.
	*/
	public void vabasta() {

		lukustatud=false;

	}

	/**
	*Tagastab, kas antud hoidla on lukustatud või mitte.
	*/
	public boolean onLukustatud() {

		return lukustatud;

	}
	
	/**
	*Tagastab hoidla id.
	*/
	public int getId() {
	
		return id;
	
	}
	
	/**
	*Hoidla id seadmine.
	*/
	public void setId(int id) {
	
		this.id=id;
	
	}
	
	/**
	*Hoidla maksimaalse infokoguse seadmine. (B)
	*/
	public void setMaxSize(long i) {
	
		max_size=i;
	
	}
	
	/**
	*Hoidlasse salvestatud infokoguse suurendamine (B)
	*/
	public void setSize(long i) {
	
		size=i;
	
	}
	
	/**
	*Hoidla maksimaalse suuruse saamine. (B)
	*/
	public long getMaxSize() {
	
		return max_size;
	
	}
	
	/**
	*Hoidla suuruse saamine. (B)
	*/
	public long getSize() {
	
		return size;
	
	}
	
	/**
	*Andmebloki id sisestamine hoidlasse.
	*/
	public void addAbId(int id) {
	
		andmeblokid.add(new Integer(id));
	
	}
	
	/**
	*Hoidla andmeblokkide identifikaatorite massiivi saamine.
	*/
	public Vector getAndmeblokid() {
	
		return andmeblokid;
	
	}

}
