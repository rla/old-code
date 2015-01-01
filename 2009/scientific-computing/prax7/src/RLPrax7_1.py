# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

# A note: getA1() is used to transform matrix row into array.

import sys
import random
import numpy
import time
import math

# Solves linear system Kx = b.
# when is_unit is set to True then the
# procedure expects lower triangular matrix as L
# otherwise it expects lower unit triangular matrix as L.
# Might destructively update input matrix!

def solveL(L, b, is_unit=False):
    # If unit triangular matrix is assumed, set 1's in
    # the matrix main diagonal.
    if is_unit:
        L += numpy.diag(numpy.matrix(-L.diagonal() + 1).getA1())
    # Solve with forward subsitution.
    x = numpy.array(numpy.zeros(len(b), dtype=float))
    x[0] = b[0] / L[0, 0]
    for i in xrange(1, len(b)):
        x[i] = (b[i] - sum((L[i, 0:i]).getA1() * x[0:i])) / L[i, i]
    return x

# Solves linear system Kx = b.
# Expects upper triangular matrix as L.

def solveU(L, b):
    # Transforms the matrix L into suitable form to use with solveL.
    # Might be inefficient.
    # [::-1] reverses the array.
    return solveL(numpy.fliplr(numpy.flipud(L)), b[::-1])[::-1]

# Taken from pseudoalgorithm:
# http://www.math.vt.edu/people/wapperom/class_home/4445/alg_ludoolittle.pdf

# Compared to one on our lecture slides:
# 1. It gives name of the algorithm (Doolittle's) so
# I can ask someone about it.
# 2. Checks if factorization is possible at all
# instead of quitely producing bogus results.
# 3. Gives L and U matrixes I actually know how to use.

# Returns a three tuple (L, U) as the decomposition result.
# Modifies right side vector b as well.

def gauss_decomp(a, b, pivoting=False):
    n = len(a)
    l = numpy.matrix(numpy.zeros((n, n), dtype=float))
    u = numpy.matrix(numpy.zeros((n, n), dtype=float))
    for i in xrange(n): # iterates over rows

        max_a = abs(a[i, i])
        max_i = i
        
        # Row pivoting.
        # Find best pivot (manually).
        if pivoting:
            for j in xrange(i, n):
                if (abs(a[j, i]) > max_a):
                    max_a = abs(a[j, i])
                    max_i = j
                    
        if max_i != i:
            
            # Swaps rows manually.
            # Tracking row permutations was too complex for me.
            # This might be inefficient but could be easily
            # implemented in C or Fortran and then use
            # that implementation through some Python
            # native interface.
            
            interchange(a, i, max_i);
            interchange(l, i, max_i);
                
            # Also does swapping for right-hand side vector.
            
            tmp = b[i]
            b[i] = b[max_i]
            b[max_i] = tmp
            
        if a[i, i] == 0:
            raise Exception("Factorization not possible");
        l[i, i] = 1.0
        for j in xrange(i, n):
            u[i, j] = a[i, j]
            for k in xrange(i):
                u[i, j] = u[i, j] - l[i, k] * u[k, j]
        for j in xrange(i + 1, n):
            l[j, i] = a[j, i]
            for k in xrange(i):
                l[j, i] = l[j, i] - l[j, k] * u[k, i]
            l[j, i] = l[j, i] / float(u[i, i])

    return (l, u)

def interchange(M, r1, r2):
    for j in xrange(len(M)):
        tmp = M[r1, j]
        M[r1, j] = M[r2, j]
        M[r2, j] = tmp

def solve_single(A, b, pivoting=True):
    (L, U) = gauss_decomp(A, b, pivoting)
    return solve_lu(L, U, b);

def solve_lu(L, U, b):
    y = solveL(L, b)
    x = numpy.matrix(solveU(U, y))
    # Consistent with numpy.linalg.solve output.
    x.shape = (len(b), 1)
    return numpy.matrix(x)

def main(argv):
    # Testing with the example from http://en.wikipedia.org/wiki/System_of_linear_equations
    A = numpy.matrix([[2, -2, 4], [3, 2, -1], [-1, 0.5, -1]], dtype=float)
    b = numpy.array([-2, 1, 0], dtype=float)
    print "A\n", A
    print "b\n", b
    print "solve\n", solve_single(A, b, True)
    
    # Calculating errors for large matrices.
    m = 40
    size = 25
    errors = []
    errors_pivoting = []
    for i in xrange(m):
        Aarr = (numpy.random.rand(size * size) - 0.5) * 1000000000
        Aarr.shape = (size, size)
        A = numpy.matrix(Aarr)
        b = numpy.random.random(size)
        A1 = A.copy()
        b1 = b.copy()
        x1 = solve_single(A1, b1, False)
        errors.append(numpy.sum(numpy.square(b1 - (A1 * x1).getA1())))
        A2 = A.copy()
        b2 = b.copy()
        x2 = solve_single(A2, b2, True)
        errors_pivoting.append(numpy.sum(numpy.square(b2 - (A2 * x2).getA1())))
        
        
    print "Average error without pivoting :", numpy.average(errors)
    print "Average error with pivoting :", numpy.average(errors_pivoting)

if __name__ == "__main__":
    main(sys.argv[1:])
