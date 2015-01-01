import java.util.Vector;
import java.lang.Integer;
/**
*Sisaldab kohaliku faili lukustusmehanismi
*ja asukohta andmeblokkide suhtes.
*
*@author Raivo Laanemets
*/
class KohalikFail {

	private int algusblokk;
	private int algusbait;
	private int loppblokk;
	private int loppbait;
	private boolean lukustatud;
	private String nimi;        //Faili nimi.
	private Vector andmeblokid; //Andmeblokkide identifikaatorid

	/**
	*Ette antakse faili nimi.
	*/
	public KohalikFail(String failinimi) {

		lukustatud=false;
		nimi=failinimi;
		algusblokk=0;
		algusbait=0;
		loppblokk=0;
		loppbait=0;
		andmeblokid=new Vector();

	}

	/**
	*Lukustab antud faili.
	*/
	public void lukusta() {

		lukustatud=true;

	}

	/**
	*Vabastab antud faili.
	*/
	public void vabasta() {

		lukustatud=false;

	}

	/**
	*Tagastab, kas antud fail on lukustatud või mitte.
	*/
	public boolean onLukustatud() {

		return lukustatud;

	}
	
	/**
	*Tagastab faili nime.
	*/
	public String votaNimi() {
	
		return this.nimi;
	
	}
	
	/**
	*Algusbloki seadmine.
	*/
	public void setAlgus(int i) {
	
		algusblokk=i;
	
	}
	
	/**
	*Loppbloki seadmine.
	*/
	public void setLopp(int i) {
	
		loppblokk=i;
	
	}
	
	/**
	*Algusbaidi seadmine.
	*/
	public void setAlgusbait(int i) {
	
		algusbait=i;
	
	}
	
	/**
	*Loppbaidi seadmine.
	*/
	public void setLoppbait(int i) {
	
		loppbait=i;
	
	}
	
	/*
	*Alguse saamine.
	*/
	public int votaAlgus() {
	
		return algusblokk;
	
	}
	
	/*
	*Lopu saamine.
	*/
	public int votaLopp() {
	
		return loppblokk;
	
	}
	
	/**
	*Algusbaidi saamine.
	*/
	public int votaAlgusbait() {
	
		return algusbait;
	
	}
	
	/**
	*Loppbaidi saamine.
	*/
	public int votaLoppbait() {
	
		return loppbait;
	
	}
	
	/**
	*Andmebloki lisamine.
	*/
	public void lisaAndmeblokk(int id) {
	
		andmeblokid.add(new Integer(id));
	
	}
	
	/**
	*Andmeblokkide saamine.
	*/
	public Vector andmeblokid() {
	
		return andmeblokid;
	
	}

}
