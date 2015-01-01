import numpy as np
import fnum

from SparseMatrix import *

class SparseMatrixFortran(SparseMatrix):
    
    """A sparse matrix with the matrix-vector multiplication
    implemented with the help of Fortran."""
    
    def __mul__(self, vec):
        """Matrix vector multiplication.

        @arg vec: NumPy vector
        """
        assert self.n == vec.size

        return fnum.nested.sum(
                               np.take(vec, self.icols) * self.vals,
                               self.irows + 1,
                               len(vec)
        )
