# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

# A note: getA1() is used to transform matrix row into array.

import sys
import random
import numpy
import time

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

# Returns a pair (L, U) as the decomposition result.

def gauss_decomp(a):
    n = len(a)
    l = numpy.matrix(numpy.zeros((n, n), dtype=float))
    u = numpy.matrix(numpy.zeros((n, n), dtype=float))
    for i in xrange(n):
        if a[i, i] == 0:
            # It's *not* normal termination condition.
            # Lecture slides will lead to bogus algorithm?
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

# Based on http://en.wikipedia.org/wiki/LU_decomposition#Solving_linear_equations
# Did not find this part from lecture slides.

# Solves Ax = b for each b in bs.
# Does not compute errors.

def solve_all(A, bs):
    (L, U) = gauss_decomp(A)
    xs = map(lambda b: solve_lu(L, U, b), bs)
    return xs

def solve_single(A, b):
    (L, U) = gauss_decomp(A)
    return solve_lu(L, U, b);

def solve_lu(L, U, b):
    y = solveL(L, b)
    x = numpy.matrix(solveU(U, y))
    # Consistent with numpy.linalg.solve output.
    x.shape = (len(b), 1)
    return numpy.matrix(x)

def main(argv):
    A = numpy.matrix([[3, 1, 2], [0, -2, -2], [1, 5, 3]], dtype=float)
    b = numpy.array([1, 1, 2], dtype=float)

    print "A\n", A
    print "b\n", b
    print "solveL\n", solveL(A.copy(), b)
    print "solveL with unit\n", solveL(A.copy(), b, is_unit=True)
    print "solveU\n", solveU(A.copy(), b)
    (l, u) = gauss_decomp(A)
    print "gauss, L\n", l
    print "gauss, U\n", u
    print "gauss, LU (must be equal to A)\n", l * u
    
    # Testing with the example from http://en.wikipedia.org/wiki/System_of_linear_equations
    A = numpy.matrix([[3, 2, -1], [2, -2, 4], [-1, 0.5, -1]], dtype=float)
    b = numpy.array([1, -2, 0], dtype=float)
    print "A\n", A
    print "b\n", b
    print "solve\n", solve_single(A, b)

if __name__ == "__main__":
    main(sys.argv[1:])
