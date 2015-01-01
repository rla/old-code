import java.io.*;
class PuhastaFail {
	
	/*
	Puhastab ühe java faili kommentaaridest
	ja stringidest.
	
	Raivo Laanemets
	*/
	
	static boolean Fail(String failinimi) {
	
		/*
		Failinimi tuleb ette anda ilma .java lõputa.
		Puhastatud kood salvestatakse faili .clear.
		*/
		
		BufferedReader sisend;
		PrintWriter valjund;
		
		try {
		
			sisend=new BufferedReader(new FileReader(failinimi +".java"));
			
		} catch (IOException e) {
		
			System.out.println("Faili " +failinimi +".java ei saa avada.");
			return false;
			
		}
		
		try {
		
			valjund=new PrintWriter(new FileWriter(failinimi +".clear"), true);
			
		} catch (IOException e) {
		
			System.out.println("Faili " +failinimi +".clear ei saa avada.");
			return false;
		
		}
		
		//Puhastamiseks vajalikud muutujad
		
		char ch=' ';
		char oldch=' ';
		
		boolean n_kommentaar=false; //ühele reale ulatuv kommentaar
		boolean kommentaar=false; //mitmele reale ulatuv kommentaar
		boolean string=false; //string
		
		String rida;
		String puhastatud="";
		
		int i=0;
		
		while (true) {
		
			/*
			Sisendfaili töötlemine.
			*/
			
			puhastatud="";
			n_kommentaar=false;
			
			try {
			
				rida=sisend.readLine();
				if (rida==null) break;
				
				//Vaatleme rea tähtede kaupa läbi. Parem oleks võibolla
				//terve fail korraga
				
				for (i=0; i<rida.length(); i++) {
					
					ch=rida.charAt(i);
					
					/*
					Reeglite kogum kommentaaride ja stringide eemaldamiseks
					*/
					
					if (ch=='*' && oldch=='/' && !string) {
						
						kommentaar=true;
					
					} else if (ch=='/' && oldch=='/' && !string) {
					
						n_kommentaar=true;
					
					} else if (ch=='"' && oldch!='\\' && !kommentaar && !string && !n_kommentaar) {
					
						string=true;
					
					} else if (ch=='/' && oldch=='*' && kommentaar && !string) {
					
						kommentaar=false;
					
					} else if (ch=='"' && oldch!='\\' && string && !kommentaar && !n_kommentaar) {
					
						string=false;
					
					} else if (!kommentaar && !string && !n_kommentaar) {
					
						if (ch!='/') puhastatud+=ch;
					
					}
					
					oldch=ch;
				
				}
				
				//Tühje ridu ei ole mõtet kirjutada
				
				if (puhastatud.length()>0) valjund.println(puhastatud);
			
			} catch (IOException e) {
			
				break;
			
			}
		
		}
		
		//Sulgeme failid
		
		try {
		
			sisend.close();
			valjund.close();
			
		} catch (IOException e) {
		
			System.out.println("Viga failide sulgemisel?");
			return false;
		
		}
		
		return true;
	
	}

}