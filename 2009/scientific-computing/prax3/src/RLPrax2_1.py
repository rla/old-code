# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
from Taring import Taring

# Abiklass kahe täringuviske mängu simuleerimiseks.
class GameSimulator:
    def __init__(self, viskeid):
        self.viskeid = viskeid
        
    # Jooksutab simulatsiooni teatud arv kordi.
    # Tagastab float-arvu, mis väljendab, mitu korda
    # soovitud tulemus tuli.
    def simulate(self):
        taring1 = Taring()
        taring2 = Taring()
    
        p = 0
        for i in range(0, self.viskeid):
            vise1 = taring1.viska()
            vise2 = taring2.viska()
            if vise1 == 6 or vise2 == 6:
                p += 1
        
        return p/float(self.viskeid)
        
    # Tagastab täpse tulemuse.
    def exact(self):
        return 11.0/36.0

def main(argv):
    n = int(argv[0])
    simulator = GameSimulator(n)
    tulemus = simulator.simulate()
    
    print "Täpne tulemus: " + str(simulator.exact())
    print "Simuleeritud tulemus: " + str(tulemus)
    print "Viga: " + str(abs(tulemus - simulator.exact()))

if __name__ == "__main__":
    main(sys.argv[1:])