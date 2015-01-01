# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import RLPrax8_1
import numpy as np
import RLPrax7_2

# A - N x N CSR matrix.
# b - COLUMN vector (e.g. matrix N x 1)
# This returns ROW vector (not consistent with instructions).
def solve_jacobi(A, b, max_error = 0.000001, max_iterations = 1000):
    x = np.zeros(A.m, dtype=float)
    x_next = np.zeros(A.m, dtype=float)
    
    # Start with x.
    for i in xrange(A.m):
        x[i] = b[i, 0]
    
    iter = 0
    error = None
    while iter < max_iterations and error > max_error or error is None:
        # Calculate x_next:
        for i in xrange(A.m):
            sum = 0.0
            for j in xrange(A.n):
                if i != j:
                    sum += A.get(i, j) * x[j]
            x_next[i] = 1.0 / A.get(i, i) * (b[i, 0] - sum) # Complete fail for zeros on diagonal.
        
        error = np.sqrt(np.sum((b - A * x_next).getA1() ** 2))
        
        print "iteration %i, error %f" % (iter, error)
        
        x[:] = x_next
        iter += 1
                            
    return x_next

def main(argv):
    A = np.matrix([[ 2.0, -1.0, 0.0], [-1.0, 2.0, -1.0], [ 0.0, -1.0, 2.0]])
    b = np.matrix([[1], [2], [3]])
    x = solve_jacobi(RLPrax8_1.as_csr_matrix(A), b)
    print "x = ", x
    
    # Testing with 2D Laplacian.
    N = 4
    lap = RLPrax7_2.laplacian_2d(N)
    
    # Right-side vector.
    b = np.array([-1.0] * (N - 1) ** 2)
    b.shape = ((N - 1) ** 2, 1)
    
    print lap
    
    # Takes about 38 iterations.
    x = solve_jacobi(RLPrax8_1.as_csr_matrix(lap), np.matrix(b))
    
    print "x = ", x
    

if __name__ == "__main__":
    main(sys.argv[1:])
