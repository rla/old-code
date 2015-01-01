import time
import logging

from util.SparseMatrix import *
from prec.Preconditioner import *

class ConjugateGradientSolver:
    
    """Linear system solver for sparse matrices. It uses Conjugate Gradient
    algorithm which is an iterative method for solving linear systems."""
    
    log = logging.getLogger("cg")
    
    def __init__(self, tolerance, max_iterations, preconditioner):
        assert preconditioner is None or isinstance(preconditioner, Preconditioner)
        
        ConjugateGradientSolver.log.debug("preconditioner is: " + str(preconditioner))
        
        self._tolerance = tolerance
        self._max_iterations = max_iterations
        self._preconditioner = preconditioner
        
    def solve(self, A, b):
        
        """CG algotrithm implementation taken from RLPrax9_1. Here it is
        considerably cleaned up."""
        
        assert isinstance(A, SparseMatrix)
        assert len(b.shape) == 1
        
        start = time.time()

        n = len(b)
        x = x_prev = np.zeros(n, dtype=float)        
        r = b - A * x
        
        i = 1
        prec_time = 0.0
        while np.sqrt(np.sum(r ** 2)) > self._tolerance and i <= self._max_iterations:
            
            if self._preconditioner is not None:
                prec_start = time.time()
                z = self._preconditioner(A, r)
                prec_time += time.time() - prec_start
            else:
                z = r.copy()
            
            rh = np.sum(r * z)
            
            if i == 1:
                p = z
            else:
                p = z + (rh / rh_prev) * p_prev
            
            q = A * p
            
            a = rh / np.sum(p * q)
            x = x_prev + a * p
            r = r - a * q
            
            rh_prev, p_prev, x_prev = rh, p, x
            i += 1
        
        if i > self._max_iterations:
            raise Exception("Max iteration count in CG exceeded")
        
        ConjugateGradientSolver.log.debug("iterations: %i" % i)
        ConjugateGradientSolver.log.debug("preconditioning time: %.15f" % prec_time)
        ConjugateGradientSolver.log.debug("time: %.15f" % (time.time() - start))
        
        return x