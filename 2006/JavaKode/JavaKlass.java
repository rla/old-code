import java.util.Vector;
class JavaKlass {

	/**
	Sisaldab java klassi klassivälju, isendivälju
	klassimeetodeid, isendimeetodeid, pärilust (kui on, siis
	millisest klassist, millised liideseid kasutab),
	klassi tüüpi (abstrakne, liides).
	
	Raivo Laanemets
	*/
	
	private String nimi; //sisaldab antud klassi nime
	private Vector meetodid; //klassi poolt realiseeritud meetodid
	private Vector valjad; //klassi- või isendiväljad
	private String ylemklass;
	private Vector liidesed; //liidesed, mida antud klass realiseerib
	
	/**
	JavaKlassi loomisel tuleb just seda konstruktorit kasutada,
	sest puuduvad seadmismeetodid isendiväljadele. 
	*/
	public JavaKlass(String nimi, String ylemklass, Vector liidesed, Vector meetodid, Vector valjad) {
	
		this.nimi=nimi;
		this.ylemklass=ylemklass;
		this.liidesed=liidesed;
		this.meetodid=meetodid;
		this.valjad=valjad;
	
	}
	
	public String getNimi() {
		
		return this.nimi;
		
	}
	
	public String getYlemklass() {
	
		return this.ylemklass;
	
	}
	
	public Vector getMeetodid() {
	
		return this.meetodid;
	
	}
	
	public Vector getValjad() {
	
		return this.valjad;
	
	}
	
	public String toString() {
		
		return "Klass: " +this.nimi +":\n" +"Ülemklass: " +this.ylemklass +"\n";
	
	}

}