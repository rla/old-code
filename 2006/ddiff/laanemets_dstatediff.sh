#!/usr/bin/awk -f
##############################################################################
#                                                                            #
#                                                                            #
# Programm etteantud kataloogi (ilma alamkataloogiteta) oleku muutuste       #
# näitamiseks.                                                               #
# Raivo Laanemets, rlaanemt@ut.ee                                            #
#                                                                            #
##############################################################################

BEGIN {

  test1=(getline rida1 < ".dstate")
  test2=(getline rida2 < ".dstate_current")
  
  split(rida1, r1, "?")
  split(rida2, r2, "?")
  
  #Tsükkel üle failide ühisosa.
  while (test1>0 && test2>0) {
    
    #Kui failide nimed on samad, siis
    #kontrollime muutust.
    
    if (r1[1]==r2[1]) {
    
      if (r1[4]!=r2[4]) {
        print "chmod " r1[1] " " r1[4] " -> " r2[4]
      }
      if (r1[2]!=r2[2]) {
        print "omanik " r1[1] " " r1[2] " -> " r2[2]
      }
      if (r1[3]!=r2[3]) {
        print "grupp " r1[1] " " r1[3] " -> " r2[3]
      }
      if (r1[5]!=r2[5]) {
        print "suurus " r1[1] " " r1[5] " -> " r2[5]
      }
      if (r1[6]!=r2[6]) {
        print "muutmise kuupäev " r1[1] " " r1[6] " -> " r2[6]
      }
      if (r1[7]!=r2[7]) {
        print "räsi " r1[1] " " r1[7] " -> " r2[7]
      }
      
      #Valime järgmise võrdluspaari
      
      test1=(getline rida1 < ".dstate")
      test2=(getline rida2 < ".dstate_current")
  
      split(rida1, r1, "?")
      split(rida2, r2, "?")
      
    #Kui esimese listi failinimi on
    #väiksem kui teise oma, on faile ilmselt
    #juurde lisatud. Liigume edasi, kuni esimese nimi=>teise nimi.
      
    } else if (r1[1]<r2[1]) {
      while (r1[1]<r2[1] && test1>0) {
        print "kustutatud " r1[1]
        test1=(getline rida1 < ".dstate")
        split(rida1, r1, "?")
      }
      
    #Toimime vastupidiselt eelmisele
    #olukorrale.
      
    } else {
      while (r1[1]>r2[1] && test2>0) {
        print "lisatud " r2[1]
        test2=(getline rida2 < ".dstate_current")
        split(rida2, r2, "?")
      }
    }
  }
  
  #Kui midagi jäi esimese faili lõpust alles, st. kustutatud failid.
  while (test1>0) {
    print "kustutatud " r1[1]
    test1=(getline rida1 < ".dstate")
    split(rida1, r1, "?")
  }
  
  #Kui midagi jäi teise faili lõpust alles, st. lisatud failid.
  while (test2>0) {
    print "lisatud " r2[1]
    test2=(getline rida2 < ".dstate_current")
    split(rida2, r2, "?")
  }
  
  exit 0;
  
}


