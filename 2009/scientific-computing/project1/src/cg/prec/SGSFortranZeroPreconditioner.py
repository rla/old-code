import numpy
import logging
import time
import fnum

from Preconditioner import *
from util.SparseMatrix import *

class SGSFortranZeroPreconditioner(Preconditioner):
    
    """Symmetric Gauss-Seidel preconditioner class.

    This version uses preconditioning implemented in the Fortran language.
    Uses index management on Fortran side to allow icols, irows values from 0."""

    def __init__(self, n_iter=3):
        self.n_iter = n_iter
        
    def __call__(self, A, b):
        assert isinstance(A, SparseMatrix)
        assert A.n == len(b)
        assert A.n == A.m # We only have square matrices here.
        
        # I changed Fortran code a bit so I can pass irows and icols without +1 here.
         
        return fnum.stationary.sym_gauss_seidel_zero(A.irows, A.icols, A.vals, b, self.n_iter)

