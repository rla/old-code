# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import numpy
import time
import math
import scitools
import os
import subprocess

# Generate a 1-dimensional Laplacian matrix.
def laplacian_1d(n, d=2):
    m = n - 1
    return numpy.matrix(
        numpy.diagflat([d] * m)
        + numpy.diagflat([-1] * (m - 1), 1)
        + numpy.diagflat([-1] * (m - 1), -1)
    )

# Generate a 2-dimensional Laplacian matrix.
def laplacian_2d(n):
    m = n - 1 # Not the m from task description!.
    L = numpy.matrix(numpy.zeros((m * m, m * m), dtype=float))
    B = laplacian_1d(n, 4)
    # Negated unit matrix.
    mI = numpy.matrix(numpy.diagflat([-1.0] * m))
    for i in xrange(m):
        p = i * m
        # Put B into its place.
        L[p:p + m, p:p + m] = B
        # Put the negated unit matrices into left
        # and right of B.
        if p + m + m <= m * m:
            L[p:p + m, p + m:p + m + m] = mI
            L[p + m:p + m + m, p:p + m] = mI
    return L

# Convert the solution vector into usable data
# for visualization.
def xfull(x):
    n = int(math.sqrt(len(x)))
    x_full = numpy.matrix(numpy.zeros((n + 2, n + 2)))
    
    for i in xrange(n):
        r = n - i
        x_full[r, 1:n + 1] = x[(r - 1) * 3:(r - 1) * 3 + n]
    
    return x_full

def main(argv):
    # An example with the data in the assignment page.
    lap = laplacian_1d(10)
    print lap
    b = numpy.array([-1.0, -1.0, 3.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0])
    print b
    # Solves the equations system.
    x = numpy.linalg.solve(lap, b)
    # Creates a plot of the solution.
    scitools.easyviz.plot(numpy.linspace(0, 1.0, 9), x, hardcopy="1d.png", show=False)
    
    # Second example.
    N = 4
    lap = laplacian_2d(N)
    b = numpy.array([-1.0] * (N - 1) ** 2)
    x = numpy.linalg.solve(lap, b)
    space = numpy.linspace(0, 1, N + 1)
    grid = scitools.easyviz.ndgrid(space, space)
    scitools.easyviz.surfc(grid[0], grid[1], xfull(x), hardcopy="2d.png", show=False)
    
    # Uses ps utility to report used memory.
    print subprocess.call(["ps", "-p", "%s" % os.getpid(), "-ovsz"])
    a = laplacian_2d(60) # 92MB, w. 100, ~800MB
    print subprocess.call(["ps", "-p", "%s" % os.getpid(), "-ovsz"])
    # Prevents GC before measurement.
    print a[0,0]

if __name__ == "__main__":
    main(sys.argv[1:])
