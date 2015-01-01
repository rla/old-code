# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import sys
import random
import numpy as np
import time
import math
import scitools

# From lab description.

# The constant lambda.

def c_lam():
    return 1.0

# The term omega_i for trapezoid formula.

def c_omega_tr(i, n, h):
    if i == 1 or i == n:
        return h / 2.0
    else:
        return h
    
# The term omega_i for Simpson's formula. 
    
def c_omega_Sim(i, n, h):
    if i == 1 or i == n:
        return h / 3.0
    elif i >= 2 and i <= n - 1 and i % 2 == 0:
        return 4.0 * h / 3.0 
    else:
        return 2.0 * h / 3.0

# The constant h.
    
def c_h(a, b, n):
    return (b - a) / float(n - 1)

# The term si used during the approximation calculation.

def c_s(a, j, h):
    return a + (j - 1) * h

# Integral equation bounds.

def c_a():
    return -math.pi

def c_b():
    return math.pi

# Function K.

def f_K(t, s):
    return 3.0 / (6.4 * math.pi * np.cos((t + s) / 2.0) ** 2 - 10 * math.pi)

# Function f.

def f_f(t):
    return 25.0 - 16.0 * np.sin(t) ** 2

# A helper function to calculate
# yn (see last line of solve function).
# This is taken from equation 7.

def f_yn(t, a, n, h, Z, q_f_w):
    sum = 0.0
    for j in xrange(1, n + 1):
        sum += q_f_w(j, n, h) * f_K(t, c_s(a, j, h)) * Z[j - 1]
        
    return f_f(t) + c_lam() * sum

# Solves the integral equation with functions
# and bounds given above. Parameter q_f_w defines
# the function for term omega_i in the equations.

def solve(n, q_f_w):
    a = c_a()
    b = c_b()
    h = c_h(a, b, n)
    zmat = [] # the matrix of zi coefficients
    bvec = [] # the right side vector (f(si) values)
    for i in xrange(1, n + 1): # i = 1,...,n
        s_i = c_s(a, i, h)
        f_s_i = f_f(s_i) # right side of the equation 5
        bvec.append(f_s_i)
        rvec = [] # the vector of zj coefficients in the current row
        for j in xrange(1, n + 1): # j = 1,...,n
            rvec.append(-c_lam() * q_f_w(j, n, h) * f_K(s_i, c_s(a, j, h)))
        # Add zi
        rvec[i - 1] += 1.0
        zmat.append(rvec)
    
    # Prepare for solving for zi's.
    A = np.matrix(zmat)
    b = np.matrix(bvec)
    b.shape = (n, 1)
    
    # Uses built-in solver.
    Z = np.linalg.solve(A, b)
    Z.shape = (1, n)
    
    # Returns the approximated function yn(t).
    return lambda t: f_yn(t, a, n, h, Z.getA1(), q_f_w)

# I assume that this was the exact solution.
def sol(t):
    return 17.0 / 2.0 + 128.0 / 17.0 * np.cos(2.0 * t)

def main(argv):
    # The approximation using trapezoid formula.
    yn_tr = solve(6, c_omega_tr)
    
    # The approximation using Simpson's formula.
    yn_Sim = solve(9, c_omega_Sim)
    
    # A set of points used in plot.
    ts = np.linspace(c_a(), c_b(), 50)
    
    # Plot showing the approximations and the exact solution.
    scitools.easyviz.plot(
        ts, yn_tr(ts), 'b+-',
        ts, yn_Sim(ts), 'go-',
        ts, sol(ts), 'ro-',
        legend=('approx. w. trapezoid', 'approx. w. Simpson', 'exact'),
        xlabel='t',
        ylabel='y(t)'
    )

if __name__ == "__main__":
    main(sys.argv[1:])
