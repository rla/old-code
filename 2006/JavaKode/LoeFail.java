import java.io.*;
import java.util.*;
class LoeFail {

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
		
		int i=0;
		int ccount=0; //avavate ja sulgevate loogsulgude vahekord
		
		
		while (true) {
		
			/*
			Sisendfaili töötlemine. Jaotame
			Klassi lauseteks
			*/
			
			try {
			
				rida=sisend.readLine();
				if (rida==null) break;
				
				for (i=0; i<rida.length(); i++) {
					
					ch=rida.charAt(i);
					
					
					
					
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