import java.util.Vector;
class KlassiKirjeldus {

	/**
	Antud klass mõistatab lahti klassi
	kirjelduse.
	
	Raivo Laanemets
	*/
	
	private String nimi=""; //Klassi või liidese nimi
	private String tyyp=""; //Klassi korral public, abstract
	private String ylemklass="";
	private Vector liidesed; //Liidesed, mida klass realiseerib
	private boolean liides;
	private boolean klass;
	
	public KlassiKirjeldus(String sisend) {
		
		sisend+=' ';
		liidesed=new Vector();
		String token="";
		char ch;
		boolean knimi=false;
		boolean ynimi=false;
		boolean lnimi=false;
		
		for (int i=0; i<sisend.length(); i++) {
			
			ch=sisend.charAt(i);
			
			if (onEraldaja(ch) && token.length()>0) {
				
				if (token.equals("abstract")) {
					tyyp="abstract";
				} else if (token.equals("public")) {
					tyyp="public";
				} else if (token.equals("class")) {
					knimi=true;
					liides=false;
					klass=true;
				} else if (token.equals("interface")) {
					knimi=true;
					liides=true;
					klass=false;
				} else if (knimi) {
					nimi=token;
					knimi=false;
				} else if (token.equals("extends")) {
					ynimi=true;
				} else if (ynimi) {
					ylemklass=token;
					ynimi=false;
				} else if (token.equals("implements")) {
					lnimi=true;
				} else if (lnimi) {
					liidesed.add(new String(token));
				}
				
				token="";
			
			} else { token+=ch; }
		
		}
	
	}
	
	private boolean onEraldaja(char ch) {
		
		if (ch==' ' || ch=='\t' || ch==',') return true;
		return false;
	
	}
	
	public String toString() {
	
		String str;
		
		if (klass) {
			
			str="Klass " +nimi +"\n------------------------\n"
			+"Ülemklass: " +ylemklass +"\n"
			+"Tüüp: " +tyyp +"\n"
			+"Realiseerib liideseid: \n";
			
			while (!liidesed.isEmpty()) {
			
				str+=(String)liidesed.remove(0)+"\n";
				
			}
			
		} else {
			
			str="Liides " +nimi +"\n------------------------\n"
			+"Ülemliides: " +ylemklass +"\n";	
			
		}
		
		return str;
			
	}

}