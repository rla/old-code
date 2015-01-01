# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

# Based on http://courses.cs.ut.ee/2009/sc/uploads/Main/sparse-template.py.txt

# generate documentation with `epydoc *.py'

import numpy as np

class SparseMatrix:
    "Sparse matrix in triple storage format."

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
            vs.append("%d %d %.15f" % (self.irows[i], self.icols[i], self.vals[i]))
        vs_str = "\n".join(vs)
        return "%d x %d nnz=%d\n%s" % (self.m, self.n, self.nnz, vs_str)

    # This code does not check for dimension matching.
    def __mul__(self, vec):
        """Matrix vector multiplication.

        @arg vec: NumPy vector
        """
        
        # Standard algorithm as described in the instructions.
        y = np.zeros(self.m, dtype=float)
        for k in xrange(self.nnz):
            i = self.irows[k]
            j = self.icols[k]
            v = self.vals[k]
            y[i] += vec[j] * v
            
        # For the sake of consistency will return a matrix
        # with the result column vector here (not only the vector).
        ret = np.matrix([y])
        ret.shape = (self.m, 1)
        return ret
    
    # Sets internal storage at i for triple: row, column, value.
    # This is used in as_sparse_matrix below.
    def set(self, i, r, c, v):
        self.irows[i] = r
        self.icols[i] = c
        self.vals[i] = v

class CSRMatrix:
    """Matrix in compressed sparse row-major format.

    @ivar rows: column indices
    @ivar rptr: pointer to I{rows}
    """

    def __init__(self, m, n, nnz):
        """Sparse matrix
        @arg m: number of rows
        @arg n: number of columns
        @arg nnz: number of non-zero elements"""

        self.m = m
        self.n = n
        self.nnz = nnz
        self.rows = np.zeros(nnz, dtype=int)
        self.rptr = np.zeros(m + 1, dtype=int)
        self.vals = np.zeros(nnz, dtype=float)

    def __str__(self):
        return "%d x %d nnz=%d\nrows=%s\nrptr=%s\nvals=%s" % (self.m, self.n, self.nnz,
                                     self.rows, self.rptr, self.vals)

    # This code does not check for dimension matching.
    def __mul__(self, vec):
        """Matrix vector multiplication.

        @arg vec: NumPy vector
        """
        
        # Standard algorithm as described in the instructions.
        y = np.zeros(self.m, dtype=float)
        for i in xrange(self.m):
            k1, k2 = self.rptr[i:i + 2]
            for j in xrange(k1, k2):
                c = self.rows[j]
                v = self.vals[j] 
                y[i] += vec[c] * v
            
        # For the sake of consistency will return a matrix
        # with the result column vector here (not only the vector).
        ret = np.matrix([y])
        ret.shape = (self.m, 1)
        return ret
    
    # Get the matrix element at given row and column.
    def get(self, r, c):
        k1, k2 = self.rptr[r:r + 2]
        for j in xrange(k1, k2): # Search for column index.
            c_s = self.rows[j]
            if c_s == c:
                return self.vals[j]
        return 0

def as_sparse_matrix(matrix):
    "Create sparse matrix from NumPy matrix."
    
    # Number of non-zero elements.
    nnz = np.sum(np.where(matrix != 0, 1, 0))
    (n, m) = matrix.shape
    sparse = SparseMatrix(n, m, nnz)
    i = 0
    for r in xrange(n):
        for c in xrange(m):
            if matrix[r, c] != 0: # FIXME inequality with 0! Is this OK?
                sparse.set(i, r, c, matrix[r, c])
                i += 1
    
    return sparse

def as_csr_matrix(matrix):
    "Create CSR matrix from NumPy matrix."
    
    # Number of non-zero elements.
    nnz = np.sum(np.where(matrix != 0, 1, 0))
    (n, m) = matrix.shape
    sparse = CSRMatrix(n, m, nnz)
    
    i = 0
    for r in xrange(n):
        rnnz = 0 # Number of non-zeros in the row.
        for c in xrange(m):
            if matrix[r, c] != 0:
                sparse.rows[i] = c
                sparse.vals[i] = matrix[r, c]
                rnnz += 1
                i += 1
        # Set the range of indices of rows and ivals
        # that refer to elements on row r.
        sparse.rptr[r + 1] = sparse.rptr[r] + rnnz
    
    return sparse

if __name__ == '__main__':
    x = np.array([1, 2, 3])
    x.shape = (x.size, 1)

    # create numpy matrix
    np_M = np.matrix([(1, 0, 2), (0, 3, 2), (0, 0, 2)], dtype=float)
    print "product:\n", np_M * x
    
    # convert to sparse matrix
    sp_M = as_sparse_matrix(np_M)
    print "\nsparse matrix:\n%s" % sp_M
    print "product:\n", sp_M * x

    # convert to CSR matrix
    csr_M = as_csr_matrix(np_M)
    print "\nCSR matrix:\n%s" % csr_M
    print "product:\n", csr_M * x

