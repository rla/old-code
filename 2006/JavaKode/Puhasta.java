import java.io.File;
class Puhasta {

	/*
	Eemaldab java koodist kommentaarid ja
	asendab stringid tühjade stringidega.
	Töötleb järjest terve kaustatäie faile.
	
	Raivo Laanemets
	*/
	
	public static void main(String[] args) {
	
		if (args.length==0) {
		
			System.out.println("Kasutamine: java Puhasta <kausta nimi>");
			return;
			
		}
		
		/*
		Läbime kausta, esialgu mitterekursiivselt
		*/
		
		File kaust=new File(args[0]);
		String failid[]=kaust.list();
		String fail;
 
		for (int i=0; i<failid.length; i++) {
		
			fail=failid[i];
			
			//Meile on vajalikud ainult .java failid
			
			if (fail.endsWith(".java")) {
			
				fail=fail.substring(0, fail.indexOf('.'));
				
				if (PuhastaFail.Fail(kaust.getAbsolutePath() + "/" + fail))
					System.out.println("Faili " +fail +" puhastamine õnnestus.");
			
			}
     
		}
	
	}

}