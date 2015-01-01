# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import time
from numpy import random, where, reshape, sum
from RLPrax2_1 import GameSimulator

def main(argv):
    n = int(argv[0])
    start = time.clock()
    # Leia kõik 2 * n visked.
    visked = random.randint(1, 7, 2 * n)
    # Leia kohad, kus tulemus 6 (6 - väärtus 1, mitte 6 - väärtus 0).
    tulemus6 = where(visked == 6, 1, 0)
    # Paiguta kahe viske tulemused kohakuti.
    tulemus6.shape = (2, n)
    # Massiiv, kus indeksil i väärtus > 0 näitab, et
    # vähemalt üks visetest sellel kohal on 6.
    tulemus6Summa = tulemus6[0] + tulemus6[1]
    # Massiiv, kus indeksil i väärtus 1 näitab, et
    # vähemalt üks visetest sellel kohal on 6.
    tulemus6Summa = where(tulemus6Summa > 0, 1, 0)
    # Selliste mängude kogus kokku
    tulemus6Visetest = sum(tulemus6Summa)
    
    lopp = time.clock()
    # Kulutatud aeg ms
    aega = int((lopp - start) * 1000)
    
    print "Mängukordi kokku: " + str(n)
    print "Võite kokku: " + str(tulemus6Visetest)
    print "Võidu tõenäosus: " + str(tulemus6Visetest/float(n))
    print "Teoreetiline väärtus: " + str(11.0/36.0)
    print "Aega kulus: " + str(aega) + "ms"
    
    # Ajalise võrlduse saamiseks eelmise lahendusega
    # (eelmine praks)
    sim = GameSimulator(n);
    start = time.clock();
    sim.simulate();
    lopp = time.clock()
    # Kulutatud aeg ms
    aega = int((lopp - start) * 1000)
    print "Ilma NumPy kasutamiseta lahendus kulutas aega: " + str(aega) + "ms"

if __name__ == "__main__":
    main(sys.argv[1:])