# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import numpy
import time
from scitools.easyviz import plot, hold
from numpy import log10

@numpy.vectorize
def derivative(f, x, h):
    return (f(x + h) - f(x)) / h

@numpy.vectorize
def cderivative(f, x, h):
    return (f(x + h) - f(x - h)) / (2 * h)

# 1st argument - number of data points.
# next arguments - values of x's where the derivative is calculated at.
# Up to 5 values.
def main(argv):
    n = int(argv[0])
    xs = argv[1:]
    j = numpy.linspace(1, 16, n)
    h = 10 ** (-j)
    f = lambda x: x ** 3         # the original function
    fprim = lambda x: 3 * (x**2) # derivative of the original function
    x = 1.0
    
    # Array of colors for different x's.
    colors = ['b', 'y', 'r', 'c', 'm']

    for i in range(len(xs)):
        x = float(xs[i])
        c = colors[i]
        
        # Set 1.0 for absolute errors.
        # Also check the file output name.
        relfactor = 1.0 / fprim(x)
        
        E1 = abs(derivative(f, x, h) - fprim(x)) * relfactor
        E2 = abs(cderivative(f, x, h) - fprim(x)) * relfactor
        plot(
             log10(h),  # Instead of setting log scale for the plot, we mangle with
             log10(E1), # the data points so that the graph appears log-scaled.
             c + 'o-',
             log10(h),
             log10(E2),
             c + '+-',
             legend=('der ' + str(x), 'c_der ' + str(x)),
             xlabel='log10(h)',
             ylabel='log10(E)',
             hardcopy="task1_relative.png", # Name of output file.
             show=False, # Does not display immediately on screen.
             hidden='on'
        )
        # Add plot to the current plot.
        if i < len(xs) - 1:
            hold('on')

if __name__ == "__main__":
    main(sys.argv[1:])