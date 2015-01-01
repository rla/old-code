# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import math
import numpy
import time

# Arvutab etteantud funktsiooni integraali,
# kasutades Monte-Carlo meetodit.
# f - funktsioon
# a - alumine raja
# b - ülemine raja
# n - summa elementide arv (vaikimisi 10000)
#
# Funktsioon viga ei väljasta, sest nii sai praktikumis
# kokku lepitud. 
def mc_int(f, a, b, n = 10000):
    sum = 0.0
    for i in range(n):
        x = random.uniform(a, b)
        sum += f(x)
    return (b - a)/float(n) * sum

# Arvutab etteantud funktsiooni integraali,
# kasutades Monte-Carlo meetodit ja NumPy võimalusi.
# f - funktsioon
# a - alumine raja
# b - ülemine raja
# n - summa elementide arv (vaikimisi 10000)
#
# Funktsioon viga ei väljasta, sest nii sai praktikumis
# kokku lepitud. 
def mc_int_numpy(f, a, b, n = 10000):
    # Genereeri ja skaleeri masiiv.
    xs = a + (b - a) * numpy.random.rand(n)
    # Kui f pole vektoriseeritud,
    # tee sellest vektoriseeritud variant.
    if not isinstance(f, numpy.ufunc):
         f = numpy.vectorize(f)
    return (b - a)/float(n) * numpy.sum(f(xs))

def main(argv):
    start = time.clock()
    print "MC integreerimine, math.sin(x) 0..pi: %s" % mc_int(math.sin, 0, math.pi, 300000)
    print "Aega kulus: " + str((time.clock() - start) * 1000) + "ms"
    
    start = time.clock()
    print "MC integreerimine (NumPy), math.sin(x) 0..pi: %s" % mc_int_numpy(math.sin, 0, math.pi, 300000)
    print "Aega kulus: " + str((time.clock() - start) * 1000) + "ms"
    
    start = time.clock()
    print "MC integreerimine, numpy.sin(x) 0..pi: %s" % mc_int(numpy.sin, 0, math.pi, 300000)
    print "Aega kulus: " + str((time.clock() - start) * 1000) + "ms"
    
    start = time.clock()
    print "MC integreerimine (NumPy), numpy.sin(x) 0..pi: %s" % mc_int_numpy(numpy.sin, 0, math.pi, 300000)
    print "Aega kulus: %s ms" % ((time.clock() - start) * 1000)

if __name__ == "__main__":
    main(sys.argv[1:])