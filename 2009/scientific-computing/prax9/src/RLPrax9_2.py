# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import numpy as np
import time
import math
import scitools
import RLPrax8_1
import fnum

# Matrix-vector multiplication for a sparse matrix A.
# I did not want to modify my old code. Otherwise this
# would be the implementation of __mul__ SparseMatrix (or in
# a subclass). Just have to replace A with the instance variable 'self'.

def multiply(A, vec):
    return fnum.nested.sum(
        np.take(vec, A.icols) * A.vals,
        A.irows + 1,
        len(vec)
    )

def main(argv):
    A = RLPrax8_1.as_sparse_matrix(np.matrix([(4, -1, 0), (-1, 4, -1), (0, -1, 4)], dtype=float))
    x = np.array([1, 2, 3])
    print "A =", A
    print "x=", x
    print "y=", multiply(A, x)
    
    print "Doing a benchmark"
    
    ns = []
    times_normal = []
    times_nested = []
    # Might run long time
    for i in xrange(2, 12):
        n = 2 ** i
        print "n =", n
        ns.append(n)
        Aran = np.random.rand(n * n)
        Aran.shape = (n, n)
        A = RLPrax8_1.as_sparse_matrix(Aran)
        vec = np.random.rand(n)
        start = time.clock()
        A * vec # assumes that it does not modify A or vec
        times_normal.append(time.clock() - start)
        start = time.clock()
        multiply(A, vec)
        times_nested.append(time.clock() - start)
        
    scitools.easyviz.plot(
        ns, np.log10(times_normal), 'b+-',
        ns, np.log10(times_nested), 'ro-',
        xlabel='n',
        ylabel='time',
        hardcopy="mult_time.png",
        show=False
    )

if __name__ == "__main__":
    main(sys.argv[1:])
