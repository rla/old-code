# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
from Taring import Taring

# Abiklass nelja täringuviske mängu simuleerimiseks.
class GameSimulator:
    def __init__(self):
        # Täringute ettevalmistamine.
        self.t1 = Taring()
        self.t2 = Taring()
        self.t3 = Taring()
        self.t4 = Taring()
    
    # Viskab kõiki nelja täringut ja tagastab visete summa.    
    def viskaTaringuid(self):
        return self.t1.viska() + self.t2.viska() + self.t3.viska()+ self.t4.viska()

    # Jooksutab simulatsiooni etteantud arv kordi.
    # Tagastab float-arvu, mis väljendab, mitu korda
    # soovitud tulemus tuli.
    def simulate(self, mange):
        voite = 0
        for i in range(0, mange):
            if self.viskaTaringuid() < 9:
                voite += 1
        
        return voite/float(mange)

# Põhiprogramm.
# Võtab argumendiks simulatsioonis kasutatava
# mängukordade arvu ja väljastab tulemuse, kas
# mängu on mõistlik mängida või mitte.
def main(argv):
    manguMaksumus = 1.0
    voiduPreemia = 10.0
    mange = int(argv[0])
    simulator = GameSimulator()
    voiduTn = simulator.simulate(mange)
    maksumusKokku = mange * manguMaksumus
    voiduPreemiaKokku = mange * voiduPreemia
    voiduPreemiaSimulatsioon = voiduPreemiaKokku * voiduTn
    
    print "Mängude arv: " + str(mange)
    print "Võidu tõenäosus: " + str(voiduTn)
    print "Mängude maksumus kokku: " + str(maksumusKokku)
    print "Maksimaalne võidupreemia (kõik mängud võidetud): " + str(voiduPreemiaKokku)
    print "Simulatsiooni võidupreemia: " + str(voiduPreemiaSimulatsioon)
    
    if maksumusKokku < voiduPreemiaSimulatsioon:
        print "Mängu on mõistlik mängida"
    else:
        print "Mängu ei ole mõistlik mängida"
    
if __name__ == "__main__":
    main(sys.argv[1:])