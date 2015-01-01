# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import numpy
import time
import scitools

# Performs curve fitting.
#
# points - data points (array of pairs(ti, yi))
# rank - rank of polynomial that should pass the
# data points as close as possible.
#
# Returns matrix (w. single column)
# representing polynomial coefficients.
def solve(points, m):
    n = len(points)
    t = numpy.array(map(lambda x: x[0], points))
    y = numpy.array(map(lambda x: x[1], points))
    
    # y must be column vector
    y.shape = (n, 1)
     
    # Calculates transposed C with ti^1 in columns,
    # except in first, where it is 1.
    # + is list concatenation here
    # * is list repetition here
    Ct = numpy.matrix([numpy.repeat(1, n)] + ([t] * m))
    
    # Calculates ti^(j-1) in columns
    Ct = numpy.cumprod(Ct, axis=0)
    C = Ct.transpose()
    A = Ct * C
    b = Ct * y
    
    return numpy.linalg.solve(A, b)

def main(argv):
    # Dealing with m-th order polynomial, change here.
    m = 9
    # Data points.
    points = [
        (0.07, 0.1), (0.1, 0.6), (0.15, 0.3), (0.22, 0.7),
        (0.3, 0.5), (0.33, 0.2), (0.4, 0.2), (0.57, 0.8),
        (0.6, 0.3), (0.8, 0.3), (0.87, 0.95), (0.9, 0.6)
    ]
    # Applies curve fitting.
    x = solve(points, m)
    # Plots calculated values and original data
    # points for comparision.
    t = numpy.linspace(0.05, 0.91, 50)
    # Find matrix [[1, t, t^2, t^3, ..., t^(m-1)]] for each t
    t1 = map(lambda t:numpy.matrix(numpy.cumprod([1] + [t] * m)), t)
    # Broadcasting * over the list of matrices.
    # Calculates the polynomial value at each t.
    # (multiplication of t^i matrix with coefficents matrix
    # gives 1,1 matrix (scalar))
    v = numpy.array(t1 * x)
    # Splits points (pairs) into usable form
    # that is required by easyviz.
    tis, yis = zip(*points)
    scitools.easyviz.plot(
        t, v,
        tis, yis, 'bo',
        hardcopy="assignment2.png",
        show=False
    )

if __name__ == "__main__":
    main(sys.argv[1:])