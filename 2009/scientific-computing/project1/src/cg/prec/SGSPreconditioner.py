import numpy
import logging

from Preconditioner import *
from util.SparseMatrix import *

class SGSPreconditioner(Preconditioner):
    
    """Symmetric Gauss-Seidel preconditioner class.

    The objects of this class are callable which allows them to be used
    in place of functions."""

    def __init__(self, n_iter=3):
        self.n_iter = n_iter
        
    def __call__(self, A, b):
        assert isinstance(A, SparseMatrix)
        assert A.n == len(b)
        assert A.n == A.m # We only have square matrices here.
        
        z = numpy.zeros(A.n)
        
        for k in xrange(self.n_iter):
            
            # Forward iteration:
            
            for i in xrange(A.n):
                sum = 0.0
                for j in xrange(A.n):
                    if i != j:
                        sum += A[i, j] * z[j]
                z[i] = 1.0 / A[i, i] * (b[i] - sum)
                
        #for k in xrange(self.n_iter):
                
            # Backward iteration:
                
            for ii in xrange(A.n):
                i = A.n - (ii + 1)
                sum = 0.0
                for j in xrange(A.n):
                    if i != j:
                        sum += A[i, j] * z[j]
                z[i] = 1.0 / A[i, i] * (b[i] - sum)
        
        return z

