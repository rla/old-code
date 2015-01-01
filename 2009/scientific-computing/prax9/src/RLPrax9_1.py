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
import RLPrax7_2

# Solves Ax = b using Conjugate Gradient. Returns a pair (x, it),
# where x is the solution and it is the number of iterations.

def solve(A, b, tolerance=1.0 * 10 ** -10, max_iter=1000):
    # Starting vector for the solution.
    x_i1 = np.zeros(len(b), dtype=float)
    
    # Initial value for r.
    r = b - A * x_i1
    
    it = 1
    while np.sqrt(np.sum(r.getA1() ** 2)) > tolerance and it <= max_iter:
        z = r.copy() # vector
        # It is scalar.
        rho_i1 = np.sum(r.getA1() * z) # scalar
        if it == 1:
            p_i = z # vector
        else:
            beta_i1 = rho_i1 / rho_i2 # scalar
            p_i = z + beta_i1 * p_i1 # vector
        
        # My CSR vector multiplication unfortunately accepts an array.
        # This operation also does the transposition.
        p_i.shape = (1, len(b))
        q_i = A * p_i.getA1()
        
        # p_i was transposed before finding q_i.
        alpha_i = rho_i1 / ((p_i * q_i)[0, 0])
        x_i = x_i1 + alpha_i * p_i
        r = r - alpha_i * q_i
        
        # Restores the shape of p_i.
        p_i.shape = (len(b), 1)
        
        # Manages "indices".
        rho_i2 = rho_i1
        p_i1 = p_i
        x_i1 = x_i
        it += 1
    
    if it > max_iter:
        raise Exception("Max iteration count exceeded")
    
    return (x_i, it - 1) # it started as 1.

def main(argv):
    # Both CSR and sparse work here but I prefer CSR.
    A = RLPrax8_1.as_csr_matrix(np.matrix([[2, -1, 0, 0], [-1, 2, -1, 0], [0, -1, 2, -1], [0, 0, -1, 2]], dtype=float))
    b = np.matrix([[1], [2], [3], [3]], dtype=float)
    print "A = ", A
    print "b = ", b
    (x, it) = solve(A, b)
    print "x = ", x
    print "CG number of iterations: ", it
    
    return 1
    # Benchmark num of iterations for solving Laplacians.
    print "Benchmark starts"
    x = []
    y = []
    print "1D Laplacians"
    for n in xrange(2, 200, 10):
        print "n = ", n
        x.append(n)
        lap = RLPrax8_1.as_csr_matrix(RLPrax7_2.laplacian_1d(n))
        b = np.matrix([[-1.0] * (n - 1)])
        b.shape = (n - 1, 1)
        (_x, it) = solve(lap, b)
        y.append(it)
        
    scitools.easyviz.plot(
        x,
        y,
        'r+-',
        xlabel='n',
        ylabel='iterations',
        hardcopy="1d_iterations.png",
        show=False
    )
    
    x = []
    y = []
    print "2D Laplacians"
    for n in xrange(2, 20):
        print "n = ", n
        x.append(n)
        lap = RLPrax8_1.as_csr_matrix(RLPrax7_2.laplacian_2d(n))
        b = np.matrix([[-1.0] * (n - 1) ** 2])
        b.shape = ((n - 1) ** 2, 1)
        (_x, it) = solve(lap, b)
        y.append(it)
        
    scitools.easyviz.plot(
        x,
        y,
        'b+-',
        xlabel='n',
        ylabel='iterations',
        hardcopy="2d_iterations.png",
        show=False
    )

if __name__ == "__main__":
    main(sys.argv[1:])
