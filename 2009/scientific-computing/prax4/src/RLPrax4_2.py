# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import math
import numpy
import time

# Arvutab etteantud funktsiooni integraali,
# kasutades Monte-Carlo meetodit ja NumPy võimalusi.
# f - funktsioon
# fd - raja kirjeldav funktsioon
# n - summa elementide arv (vaikimisi 1000)
#
# Funktsioon viga ei väljasta, sest nii sai praktikumis
# kokku lepitud. 
def mc_int_numpy(f, fd, box, n = 100000):
    # Juhuslike arvude geneerimine.
    xs = numpy.random.rand(n * len(box))
    
    # Juhuslike arvude jagamine dimensioonide vahel.
    # Siin tarvis sobivat kuju skaleerimise jaoks.
    xs.shape = (n, len(box))
    
    # Dimensioonide pikkuste massiivi koostamine.
    lbox = numpy.array(map(lambda d: d[1] - d[0], box))
    
    # Dimensioonide pikkuste korrutis annab box'i ruumala.
    volume = numpy.product(lbox)
    
    # Skaleerimise esimene osa - dimensioonides arvude
    # skaala läbikorrutamine pikkuse kordajaga.
    xs = xs * lbox
    
    # Dimensioonide alguspiiride massiivi koostamine.
    sbox = numpy.array(map(lambda d: d[0], box))
    
    # Skaleerimise teine osa - dimensioonides arvude
    # nihutamine õigesse kohta.
    xs = xs + sbox

    # Funktsioonide vektoriseerimine
    if not isinstance(f, numpy.ufunc):
         f = numpy.vectorize(f)
    if not isinstance(fd, numpy.ufunc):
         fd = numpy.vectorize(fd)
         
    # Väärtuste massiivi kuju kohendamine sellisele kujule,
    # et funktsioonid saaksid sobival kujul argumendid.
    xs.shape = (len(box), n)
    
    # Integreerimisvalemi rakendamine.
    # *xs muudab veerus olevad elemendid
    # argumentideks (argument unpacking).
    return volume * numpy.sum(numpy.where(fd(*xs), f(*xs), 0)) / float(n)

# Põhiprogramm, käivitab integreerimise ja
# väljastab tulemused.
def main(argv):
    start = time.clock()
    print "Tulemus: %s" % mc_int_numpy(
        lambda x, y, z: 1.0,
        lambda x, y, z: x * x + y * y + z * z <= 1,
        [(-1.0,1.0), (-1.0,1.0), (-1.0,1.0)]
    )
    print "Täpne tulemus: %s" % (4 * math.pi/float(3))
    
if __name__ == "__main__":
    main(sys.argv[1:])