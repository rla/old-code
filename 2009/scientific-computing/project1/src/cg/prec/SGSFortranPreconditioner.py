import numpy
import logging
import time
import fnum

from Preconditioner import *
from util.SparseMatrix import *

class SGSFortranPreconditioner(Preconditioner):
    
    """Symmetric Gauss-Seidel preconditioner class.

    This version uses preconditioning implemented in the Fortran language."""

    def __init__(self, n_iter=3):
        self.n_iter = n_iter
        
    def __call__(self, A, b):
        assert isinstance(A, SparseMatrix)
        assert A.n == len(b)
        assert A.n == A.m # We only have square matrices here.
         
        return fnum.stationary.sym_gauss_seidel(A.irows + 1, A.icols + 1, A.vals, b, self.n_iter)

