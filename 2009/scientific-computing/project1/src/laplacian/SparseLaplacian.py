from WaveLaplacian import *
from util.SparseMatrix import *
from util.SparseMatrixFortran import *
from cg.ConjugateGradientSolver import *

class SparseLaplacian(WaveLaplacian):
    
    """A class for sparse wave Laplacians."""
    
    def __init__(self, n, triples, solver, with_fortran_mult):
        assert isinstance(solver, ConjugateGradientSolver)
        
        self._solver = solver
        m = n - 1
        
        if with_fortran_mult:
            self._m = SparseMatrixFortran(m * m, m * m, len(triples))
        else:
            self._m = SparseMatrix(m * m, m * m, len(triples))
        
        for i in xrange(len(triples)):
            (irow, icol, value) = triples[i]
            self._m.irows[i] = irow
            self._m.icols[i] = icol
            self._m.vals[i] = value
        
    def solve_with(self, b):
        
        """Solves the equaltion Ax = b with this Laplacian A and
        the given right-side b."""
        
        return self._solver.solve(self._m, b)
    
    def __str__(self):
        return str(self._m)