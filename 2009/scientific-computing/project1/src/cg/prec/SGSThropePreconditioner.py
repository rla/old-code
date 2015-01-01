import numpy
import logging
import time
import fnum

from Preconditioner import *
from util.SparseMatrix import *

class SGSThropePreconditioner(Preconditioner):
    
    """Symmetric Gauss-Seidel preconditioner class.

    This version uses preconditioning implemented in the Fortran language.
    The Fortran part uses 0-based indexing."""

    def __init__(self, n_iter=3):
        self.n_iter = n_iter
        
    def __call__(self, A, b):
        assert isinstance(A, SparseMatrix)
        assert A.n == len(b)
        assert A.n == A.m # We only have square matrices here.
        
        # I changed Fortran code a bit so I can pass irows and icols without +1 here.
         
        return fnum.stationary.sym_gauss_seidel_thrope(A.irows, A.icols, A.vals, b, self.n_iter)

