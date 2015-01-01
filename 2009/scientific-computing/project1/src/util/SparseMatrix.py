"""
Classes and methods for sparse matrices.
"""

import numpy as np
import bisect

class SparseMatrix:
    """Sparse matrix in triple storage format.

    @ivar m: number of matrix rows
    @ivar n: number of matrix columns
    @ivar nnz: number of matrix non-zero elements
    @ivar irows: array of L{nnz} row indices
    @type irows: C{numpy.ndarray(dtype=int)}
    @ivar icols: array of L{nnz} column indices
    @type icols: C{numpy.ndarray(dtype=int)}
    @ivar vals: array of L{nnz} non-zero elements' values
    @type vals: C{numpy.ndarray(dtype=float)}
    """

    def __init__(self, m, n, nnz):
        """Sparse matrix
        @arg m: number of rows
        @arg n: number of columns
        @arg nnz: number of non-zero elements"""

        self.m = m
        self.n = n
        self.nnz = nnz
        self.irows = np.zeros(nnz, dtype=int)
        self.icols = np.zeros(nnz, dtype=int)
        self.vals = np.zeros(nnz, dtype=float)

    def __str__(self):
        "String representation of the matrix."
        vs = []
        for i in xrange(self.nnz):
            vs.append("%d %d %.15f" % (self.irows[i],self.icols[i],self.vals[i]) )
        vs_str = "\n".join(vs)
        return "%d x %d nnz=%d\n%s" % (self.m,self.n,self.nnz, vs_str)

    def __mul__(self, vec):
        """Matrix vector multiplication.

        @arg vec: NumPy vector
        """
        assert self.n == vec.size

        y = np.zeros(self.m, dtype=float)
        for k in xrange(self.nnz):
            i = self.irows[k]
            j = self.icols[k]
            v = self.vals[k]
            y[i] += vec[j] * v
            
        return y
    
    def __getitem__(self, key):
        
        """Return the item of matrix at the given location.
        It uses binary search and requires values in the correct
        visiting order (sorted by row and column). However, it
        is still very slow compared to similar dense matrix."""
        
        (row, col) = key
        row_start = bisect.bisect_left(self.irows, row)
        
        if self.irows[row_start] != row:
            
            # No row with the given index exists in the matrix.
            
            return 0.0
        
        row_end = bisect.bisect_right(self.irows, row)
        
        i = bisect.bisect_left(self.icols, col, row_start, row_end)
        
        return self.vals[i] if self.icols[i] == col else 0.0
