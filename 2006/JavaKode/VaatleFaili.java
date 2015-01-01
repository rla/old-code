import java.io.*;
import java.util.*;
class VaatleFaili {

	/**
	Avab .java faili ja otsib koodist välja
	klassi meetodid ja valjad. Ühes failis võib
	olla üks või mitu klassi. (parem oleks üks)
	
	@author: Raivo Laanemets
	*/
	
	/**
	Kontrollitakse, kas etteantud märgend on eraldaja.
	Eraldajateks loeme võtmesõnu eraldavaid märke ' ', '\t', '{', '}'
	*/
	static boolean onEraldaja(char ch) {
	
		if (ch==' ' || ch=='\t' || ch=='{' || ch=='}' || ch==',' || ch==';' || ch=='=') return true;
		return false;
	
	}
	
	/**
	Etteantud failinimi peab olema ilma .clear lõputa.
	*/
	static Vector Fail(String failinimi) {
	
		System.out.println("--fail");
	
		Vector klassid=new Vector();
		Vector meetodid=new Vector();
		Vector valjad=new Vector();
		Vector liidesed=new Vector();
		
		JavaKlass klass;
		JavaVali vali;
	
		/*
		Avame faili ja tööleme selle.
		Tagastab klasside hulga (vektori).
		*/
		
		
		BufferedReader sisend;
		
		try {
		
			sisend=new BufferedReader(new FileReader(failinimi +".clear"));
			
		} catch (IOException e) {
		
			System.out.println("Faili " +failinimi +".clear ei saa avada.");
			return null;
			
		}
		
		System.out.println("--fail avatud");
		
		//Loogilised muutujad
		
		boolean onKlass=false; //oleme klassi sees või mitte
		boolean onMeetod=false; //oleme meetodi sees või mitte
		boolean onKlassinimi=false;
		boolean onYlemklassinimi=false;
		boolean onLiidesenimi=false;
		boolean onKlassikood=false;
		boolean onTyyp=false;
		boolean onNimi=false;
		
		//Ülejäänud muutujad
		
		char ch=' ';
		char oldch=' ';
		
		String rida;
		String token="";
		String klassinimi="";
		String ylemklass="";
		String valjatyyp="public";
		String tyyp=""; //välja või meetodi tüüp/tagastustüüp
		String nimi=""; //välja või meetodi nimi
		boolean klassivali=false;
		
		int i=0;
		int ccount=0; //avavate ja sulgevate loogsulgude vahekord
		
		
		while (true) {
		
			/*
			Sisendfaili töötlemine.
			*/
			
			try {
			
				rida=sisend.readLine();
				if (rida==null) break;
				
				for (i=0; i<rida.length(); i++) {
					
					ch=rida.charAt(i);
					
					if (!onEraldaja(ch)) token+=ch;
					
					else {
					
		
						//Loogsulgude balansi arvutamine.
						//Klassi lõpuks peab avavaid ja sulgevaid loogsulge
						//olema täpselt sama palju.
					
						if (ch=='{') ccount++; else if (ch=='}') ccount--;
						if (ch==';') {
						
							onTyyp=false; //lause lõpp, algseadistame lausega seotud muutujad
							onNimi=false;
							
						}
						
						//Kontrollime kas on klass ja kas loog sulgude vahe on 0.
						//Niiviisi leiame klassi lõpu.
					
						if (token.equals("class") && !onKlass) {
						
							onKlassinimi=true; //järgmisena peaks tulema klassi nimi
							onKlass=true; //leidsime klassi alguse
							
						} else if (onKlassinimi && onKlass) {
						
							onKlassinimi=false;
							klassinimi=token;
						
						} else if (token.equals("extends") && onKlass) {
						
							onYlemklassinimi=true;
						
						} else if (onYlemklassinimi && onKlass) {
						
							onYlemklassinimi=false;
							ylemklass=token;
						
						} else if (token.equals("implements") && onKlass) {
						
							onLiidesenimi=true;
						
						} else if (onLiidesenimi && onKlass && token.length()>0) {
						
							if (ccount==0) {
							
								//klassi sisemine kood pole veel alanud
								liidesed.add(token);
								
							}
							
							else onLiidesenimi=false;
						
						} else if (ccount!=0 && !onKlassikood) {
							
							onKlassikood=true;
						
						} else if (token.length()>0 && onKlassikood && !onMeetod && !onTyyp && !onNimi) {
						
							//klassi- või isendivälja algus
							
							if (token.equals("private")) valjatyyp="private";
							else if (token.equals("protected")) valjatyyp="protected";
							else if (token.equals("static")) klassivali=true;
							else if (token.equals("public")) valjatyyp="public";
							else { tyyp=token; onTyyp=true; onNimi=true; }
						
						} else if (onKlassikood && onNimi && token.length()>0) {
						
							nimi=token;
							System.out.println("valjatyyp=" +valjatyyp);
							System.out.println("tyyp=" +tyyp);
							System.out.println("nimi=" +nimi);
		
						}
						
						token="";
						
						if (ccount==0 && onKlassikood) {
						
							/*
							Arvatav klassi lõpp.
							Seame taas algmuutujad ja lisame klassi
							antud faili klasside hulka(Vector).
							*/
							
							klass=new JavaKlass(klassinimi, ylemklass, liidesed, meetodid, valjad);
							klassid.add(klass);
							
							System.out.println(klass);
							
							/*
							Algmuutujate seadmine
							*/
							
							onKlass=false;
							onMeetod=false; 
							onKlassinimi=false;
							onYlemklassinimi=false;
							onLiidesenimi=false;
							onKlassikood=false;
							onTyyp=false;
							onNimi=false;
							
							token="";
							klassinimi="";
							ylemklass="";
							valjatyyp="public";
							tyyp="";
							nimi="";
							klassivali=false;
						}
					
					}
					
					
					oldch=ch;
				
				}
				
			
			} catch (IOException e) {
			
				break;
			
			}
		
		}
		
			
		//Sulgeme faili
		
		try {
		
			sisend.close();
			
		} catch (IOException e) {
		
			System.out.println("Viga faili sulgemisel?");
			return null;
		
		}
		
		return klassid;
	
	}

}