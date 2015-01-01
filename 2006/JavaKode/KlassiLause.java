import java.util.Vector;
class KlassiLause {

	/**
	Töötleb klassi ühe lause.
	Lauseks on välja või meetodi kirjeldus.
	
	Raivo Laanemets
	*/
	
	private boolean fStatic=false;
	private boolean fPublic=true;
	private boolean fPrivate=false;
	private boolean fProtected=false;
	private String andmetyyp="";
	private boolean fFinal=false;
	private boolean fAbstract=false;
	private Vector nimed; //ühe lausega saab rohkem kui üks muutuja kirjeldatud
	
	public KlassiLause(String sisend) {
	
		sisend+=" ";
		char ch;
		String token="";
		nimed=new Vector();
		
		for (int i=0; i<sisend.length(); i++) {
			
			ch=sisend.charAt(i);
			
			if (onEraldaja(ch) && token.length()>0) {
				
				if (token.equals("static")) {
					fStatic=true;
				} else if (token.equals("public")) {
					fPublic=true;
				} else if (token.equals("private")) {
					fPrivate=true;
					fPublic=false;
				} else if (token.equals("protected")) {
					fProtected=true;
					fPublic=false;
					fPrivate=false;
				} else if (token.equals("abstract")) {
					fAbstract=true;
					fPublic=false;
				} else if (token.equals("final")) {
					fFinal=true;
				} else if (andmetyyp.length()==0) {
					andmetyyp=token;
				} else {
					nimed.add(new String(token));
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
	
		String str="";
		
		if (fPrivate) str+="private "; else str+="public ";
		if (fProtected) str+="protected ";
		if (fStatic) str+="static ";
		
		str+=andmetyyp;

		while (!nimed.isEmpty()) str+=(String)nimed.remove(0)+"\n";
		
		return str;
	
	}

}