import numpy
import time

from SparseMatrix import *

# Fixes Python 2.4 (kuu cluster) where compressed masked array
# cannot be used as an array of indexes.
# This probably destroys the performance.
#
# I developed on 2.5.2 and it works there (just return
# original array here).

def fix_p24_compressed(compressed_masked_array, dtype):
    ret = numpy.empty(compressed_masked_array.size, dtype)
    ret[:] = compressed_masked_array[:]
    
    return ret

# Constructs reverse mapping array for
# the given array.
# Example: [2,3] would be [-1,-1,0,1]

def reverse_map_array(array, n):
    
    rev = numpy.empty(n, dtype=int)
    rev[:] = -1
    rev[array] = numpy.arange(array.size)
    
    return rev

# Transforms the local sparse matrix A into local matrix.
#
# row_ids - row indices of the global matrix that this local matrix contains.
# col_ids - column indices of the global matrix that this local matrix contains.

def localize(row_ids, col_ids, A):
    
    L = SparseMatrix(row_ids.size, col_ids.size, A.nnz)
    
    # Maps global row and column index
    # to local row and column index.
    
    row_g2l = reverse_map_array(row_ids, A.m)
    col_g2l = reverse_map_array(col_ids, A.n)
    
    for k in xrange(A.nnz):
        L.irows[k] = row_g2l[A.irows[k]]
        L.icols[k] = col_g2l[A.icols[k]]
        
    L.vals[:] = A.vals[:]
    
    return L

# Copies received values from recv
# into the local ghost x values array.

def localize_xghost(recv, xghost, g2gh_y, fn):
    xghost[g2gh_y[fn]] = recv
    
# Prints out the given sparse array A
# into human-readable format.

def dump(name, A):
    m = numpy.zeros((A.m, A.n))
    
    for k in xrange(A.nnz):
        m[A.irows[k], A.icols[k]] = A.vals[k]
    
    return name + str(m)

# Creates sparse submatrix from given irows,
# icols and vals arrays. Only those triples
# are taken that are present in the ids array.

def create_submatrix(m, n, irows, icols, vals, ids):
    
    A = SparseMatrix(m, n, ids.size)
    A.irows[:] = irows[ids]
    A.icols[:] = icols[ids]
    A.vals[:] = vals[ids]
    
    return A

# Creates local and ghost matrices from the
# distributed irows, icols and vals values.
# Returns the pair (local, ghost).

def create_local_and_ghost(d, rank, m, n, irows, icols, vals):
     
    e = d[icols]
    mids = numpy.ma.array(numpy.arange(icols.size), mask=(e != rank))

    local = create_submatrix(m, n, irows, icols, vals, fix_p24_compressed(mids.compressed(), dtype=int))

    # Kuu: AttributeError: can't set attribute
    # so the following does not work on Python 2.4
    #mids.mask = mids.mask ^ True
    
    mids = numpy.ma.array(numpy.arange(icols.size), mask=(e == rank))
    ghost = create_submatrix(m, n, irows, icols, vals, fix_p24_compressed(mids.compressed(), dtype=int))
    
    return (local, ghost)

# Distributes the original sparse matrix A.
# Returns a pair (local, ghost) for the
# current process. It does not reindex
# local and ghost matrices.

def distribute_matrix(comm, A, d, rank, size):
    local = ghost = None
    
    if rank == 0:
        
        e = d[A.irows]
        ids = numpy.arange(e.size)
        
        for i in xrange(size):
            
            pids = fix_p24_compressed(numpy.ma.array(ids, mask=(e != i)).compressed(), dtype=int)
            irows = A.irows[pids]
            icols = A.icols[pids]
            vals = A.vals[pids]
            
            if i == 0:
                local, ghost = create_local_and_ghost(d, rank, A.m, A.n, irows, icols, vals)
            else:
                comm.send((A.m, A.n, irows, icols, vals), i, tag=55)
    else:
        
        m, n, irows, icols, vals = comm.recv(source=0, tag=55)
        local, ghost = create_local_and_ghost(d, rank, m, n, irows, icols, vals)
    
    return (local, ghost)

# Constructs an array of arrays of those
# x indices that are needed from the neighbours.
# The index in the returned array is the
# process id and the values are arrays of
# x indices that are needed from that process.
#
# Aghost - local ghost matrix.
# d - matrix decomposition.
# rank - the id of the current process.
# size - the total number of processes.

def from_neighs(Aghost, d, rank, size):
    
    # Maps column index to the number of
    # non-zero elements on that column in
    # the Aghost matrix (for these columns,
    # corresponding x values must be retrieved).
    
    vec_count = numpy.zeros(Aghost.n, dtype=int)
    
    # Assumes Aghost.icols has at least one value!
    
    count = numpy.bincount(Aghost.icols)
    vec_count[:count.size] = count

    # Non-0 elements.
    
    vi = fix_p24_compressed(numpy.ma.MaskedArray(numpy.arange(Aghost.n), mask=(vec_count == 0)).compressed(), dtype=int)
    
    fn = [numpy.empty(0, dtype=int)] * size
    nd = d[vi]
    
    for i in xrange(size):
        if i == rank:
            continue
        
        # Takes only neighbour indices.
        ins = fix_p24_compressed(numpy.ma.MaskedArray(vi, mask=(nd != i)).compressed(), dtype=int)
    
        if ins.size > 0:
            fn[i] = ins
            
    return fn
