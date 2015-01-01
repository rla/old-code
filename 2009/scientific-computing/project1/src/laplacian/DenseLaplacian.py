import numpy
import time
import logging

from WaveLaplacian import *

class DenseLaplacian(WaveLaplacian):

    """Laplacian as a dense matrix. Used for testing purposes.
    For solving it uses numpy.linalg.solve"""
    
    log = logging.getLogger("dense_laplacian")
    
    def __init__(self, n, triples):
        m = n - 1
        self._m = numpy.matrix(numpy.zeros((m * m, m * m), dtype=float))
        for (irow, icol, value) in triples:
            self._m[irow, icol] = value
        
    def solve_with(self, b):
        
        """Solves the equation using the built-in Numpy solver
        numpy.linalg.solve."""
        
        assert len(b.shape) == 1
        
        start = time.time()
        u = numpy.linalg.solve(self._m, b)
        DenseLaplacian.log.debug("solve_with: %f" % (time.time() - start))
        
        return u
    
    def __str__(self):
        return str(self._m)