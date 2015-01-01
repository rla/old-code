# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import time
from numpy import random, where, reshape, sum
from RLPrax2_2 import GameSimulator

def main(argv):
    n = int(argv[0])
    start = time.clock()
    # Leia kõik 2 * n visked.
    visked = random.randint(1, 7, 4 * n)
    # Paiguta nelja viske tulemused kohakuti.
    visked.shape = (4, n)
    # Tulemuste summa massiiv (summeeri sama mängu visked)
    viskedSumma = sum(visked, axis=0)
    # Massiiv, kus indeksil i väärtus 1 näitab, et
    # visete summa mängus i on < 9
    viskedSumma = where(viskedSumma < 9, 1, 0)
    # Selliste mängude kogus kokku
    tulemusVisetest = sum(viskedSumma)
    
    lopp = time.clock()
    # Kulutatud aeg ms
    aega = int((lopp - start) * 1000)
    
    print "Mängukordi kokku: " + str(n)
    print "Võite kokku: " + str(tulemusVisetest)
    print "Võidu tõenäosus: " + str(tulemusVisetest/float(n))
    print "Aega kulus: " + str(aega) + "ms"
    
    # Ajalise võrlduse saamiseks eelmise lahendusega
    # (eelmine praks)
    sim = GameSimulator();
    start = time.clock();
    sim.simulate(n);
    lopp = time.clock()
    # Kulutatud aeg ms
    aega = int((lopp - start) * 1000)
    print "Ilma NumPy kasutamiseta lahendus kulutas aega: " + str(aega) + "ms"

if __name__ == "__main__":
    main(sys.argv[1:])