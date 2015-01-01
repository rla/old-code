class JavaVali {

	/*
	Mingi java klassi mingi välja kirjeldus.
	*/
	
	private boolean isendivali; //välja tüüp (klassi- või isendiväli)
	private String nimi; //välja nimi
	private String tyyp; //välja andmetüüp
	private String valjatyyp; //protected, private, public vms.
	
	public JavaVali(String nimi, boolean isendivali, String tyyp) {
	
		/*
		Konstruktor
		*/
		
		this.nimi=nimi;
		this.isendivali=isendivali;
		this.tyyp=tyyp;
	
	}
	
	public String toString() {
	
		return "<b>" +tyyp +"</b> <font color=\"blue\">" +tyyp +"</font> " +nimi;
	
	}

}