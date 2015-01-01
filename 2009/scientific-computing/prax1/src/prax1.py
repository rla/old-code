# -*- coding: utf-8 -*-
# ^ vajalik rida täpitähtedega kommentaaride kasutamiseks.

# Raivo Laanemets
# rlaanemt@ut.ee

import sys # <-- vajalik programmi argumentide saamiseks.

# Abiklass maatriksi operatsioonide jaoks.
class Maatriks:

	def __init__(self, maatriks = []):
		self.maatriks = maatriks
	
	# Meetod maatriksi lugemiseks failist.	
	def loe(self, faili_nimi):
		sisend = open(faili_nimi) # Ava fail lugemiseks.
		self.maatriks = []        # Initsialiseeri maatrksi andmete massiiv.
		for rida in sisend:
			rida = rida.rstrip()  # Eemalda reavahetus.
			if (len(rida) > 0):
				self.maatriks.append(rida.split())
		sisend.close()            # Sulge fail.
		# FIXME muuda maatriksi lahtrite tüüp intideks (on seda vaja?).
		for rida in self.maatriks:
			for i in range (0, len(rida)):
				rida[i] = int(rida[i])
		
	# Meetod maatriksi kirjutamiseks faili.
	def kirjuta(self, faili_nimi):
		fail = open(faili_nimi, "w")
		for rida in self.maatriks:
			esimene_lahter = True
			for lahter in rida:
				if esimene_lahter:
					esimene_lahter = False
				else:
					fail.write(" ")
				fail.write(str(lahter))
			fail.write("\n")
		fail.close()
		
	# Meetod maatriksi transponeerimiseks (tagastab
	# uue maatriksi).
	def transponeeri(self):
		ridu = len(self.maatriks[0])
		transpositsioon = []
		for i in range(0, ridu):
			transpositsioon.append([])
		for i in range(0, ridu):
			for j in range(0, len(self.maatriks)):
				transpositsioon[i].append(self.maatriks[j][i])
		return Maatriks(transpositsioon)
	
	# Tagastab selle maatriksi ridade arvu.
	def ridu(self):
		return len(self.maatriks)
	
	# Tagastab selle maatriksi veergude arvu.
	def veerge(self):
		return len(self.maatriks[0])
	
	# Korrutab maatriksi etteantud maatriksiga.
	def korruta(self, maatriks):
		# Wikipedia algoritm
		# http://en.wikipedia.org/wiki/Matrix_multiplication#Formal_definition
		m = self.ridu()
		n = self.veerge()
		if (n != maatriks.ridu()):
			raise Exception("Ei saa korrutada")
		p = maatriks.veerge()
		
		# Tulemusmaatriksi initsialiseerimine
		# FIXME ilmselt on selleks m6istlikum viis
		tulemus = []
		for i in range (0, m):
			rida = []
			for j in range (0, p):
				rida.append(0)
			tulemus.append(rida)
			
		for i in range (0, m):
			for j in range (0, p):
				for r in range (0, n):
					tulemus[i][j] += self.maatriks[i][r] * maatriks.maatriks[r][j]
					
		return Maatriks(tulemus)
		
# Main-funktsioon.
# Programmi täitmine algab siit.
def main(argv):                         
	nimi = argv[0]
	
	maatriks = Maatriks()
	maatriks.loe(nimi);                       # Loe maatriks.
	transpositsioon = maatriks.transponeeri() # Transponeeri see.
	transpositsioon.kirjuta(nimi + ".trans")  # Kirjuta väljundisse.
	
	A = Maatriks()
	A.loe(nimi)              # Loe transponeerimata maatriks uuesti sisse.
	B = Maatriks()
	B.loe(nimi + ".trans")   # Loe transponeeritud maatriks uuesti sisse.
	C = A.korruta(B)         # Leia nende korrutis.
	C.kirjuta(nimi + ".mul") # Kirjuta korrutis faili sisse.

# +-- vajalik normaalsel kujul main-funktsiooni käivitamiseks.
# v
if __name__ == "__main__":
    main(sys.argv[1:])