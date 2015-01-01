#OOP projekti "Vares" makefail
#
#19. aprill 2005 - v. 001
#24. aprill 2005 - v. 002
#25. aprill 2005 - v. 003
#1. mai 2005 - v. 004

#Kompileerimisvõtmed

LOPPKAUST=build
VOTMED=-sourcepath src -d $(LOPPKAUST)
SRC=src/

#Kompileerimine.

$(LOPPKAUST)/Main.class:
	javac $(VOTMED) $(SRC)Hoidla.java
	javac $(VOTMED) $(SRC)HoidlaException.java
	javac $(VOTMED) $(SRC)FileSystemStore.java
	javac $(VOTMED) $(SRC)Logija.java
	javac $(VOTMED) $(SRC)Andmeblokk.java
	javac $(VOTMED) $(SRC)Andmeruum.java
	javac $(VOTMED) $(SRC)AndmeException.java
	javac $(VOTMED) $(SRC)KohalikFail.java
	javac $(VOTMED) $(SRC)KaustaFailid.java
	javac $(VOTMED) $(SRC)Salvestaja.java
	javac $(VOTMED) $(SRC)FailiVotja.java
	javac $(VOTMED) $(SRC)Andmeblokid.java
	javac $(VOTMED) $(SRC)Failid.java
	javac $(VOTMED) $(SRC)Crypto.java
	javac $(VOTMED) $(SRC)FtpStore.java
	javac $(VOTMED) $(SRC)Main.java
	
#.class failide kustutamine (kui kompileerimine ei õnnestunud näiteks).

clean:
	rm -r $(LOPPKAUST)/*.class
	rm -r javadoc/*
	
#Javadoc genereerimine.

javadocs:
	javadoc -private -d javadoc src/*.java
