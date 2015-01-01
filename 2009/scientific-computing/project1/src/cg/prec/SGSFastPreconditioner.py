import numpy
import logging
import time

from Preconditioner import *
from util.SparseMatrix import *

class SGSFastPreconditioner(Preconditioner):
    
    """Symmetric Gauss-Seidel preconditioner class.

    The objects of this class are callable which allows them to be used
    in place of functions. This is faster version than SGSPreconditioner.
    The code is from direct translation of stationary.f90 to Python."""

    def __init__(self, n_iter=3):
        self.n_iter = n_iter
        
    def __call__(self, A, b):
        assert isinstance(A, SparseMatrix)
        assert A.n == len(b)
        assert A.n == A.m # We only have square matrices here.
        
        start = time.time()
        x = numpy.zeros(A.n)
        
        # This code is a direct translation from stationary.f90.
        
        for it in xrange(self.n_iter):
            
            # Forward iteration:
            
            k = 0
            for i in xrange(A.n):
                x[i] = b[i]
                while k < A.nnz and A.irows[k] == i:
                    j = A.icols[k]
                    if (i == j):
                        diag = A.vals[k]
                    else:
                        x[i] = x[i] - x[j] * A.vals[k]
                    k += 1
                x[i] = x[i] / diag
                
        #for it in xrange(self.n_iter):
                
            # Backward iteration:
            
            k = A.nnz - 1
            for ii in xrange(A.n):
                i = A.n - (ii + 1)
                x[i] = b[i]
                
                while k >= 0 and A.irows[k] == i:
                    j = A.icols[k]
                    if (i == j):
                        diag = A.vals[k]
                    else:
                        x[i] = x[i] - x[j] * A.vals[k]
                    k -= 1
                x[i] = x[i] / diag
        
        return x

