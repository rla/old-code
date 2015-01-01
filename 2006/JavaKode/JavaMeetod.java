class JavaMeetod {

	/*
	Sisaldab infot meetodi kohta (abstract, protected,
	public, static), tagastustüüpi jne.
	
	Raivo Laanemets
	*/
	
	private String nimi; //sisaldab antud meetodi nime
	private String tyyp; //meetodi tüüp
	private String tagastus; //meetodi tagastustüüp
	private String parameetrid; //meetodi parameetrid
	
	public JavaMeetod(String nimi, String tyyp, String tagastus, String parameetrid) {
	
		/*
		Konstruktor
		*/
		
		this.nimi=nimi;
		this.tyyp=tyyp;
		this.tagastus=tagastus;
		this.parameetrid=parameetrid;
	
	}
	
	public String toString() {
	
		/*
		Stringina meetodi signatuuri tagastamine.
		*/
		
		return "<b>" +tyyp +" " +tagastus +" " +nimi +"</b> (" +parameetrid + ")";
	
	}

}