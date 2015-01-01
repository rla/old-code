import numpy
import sparse
import time

# Constructs reverse mapping array for
# the given array.
# Example: [2,3] would be [-1,-1,0,1]

def reverse_map_array(array, n):
    
    rev = numpy.empty(n, dtype=int)
    rev[:] = -1
    rev[array] = numpy.arange(array.size)
    
    return rev

# Transforms the sparse matrix A into local matrix.

def localize(row_ids, col_ids, A):
    
    L = sparse.SparseMatrix(row_ids.size, col_ids.size, A.nnz)
    
    # Maps global row and column index
    # to local row and column index.
    
    row_g2l = reverse_map_array(row_ids, A.m)
    col_g2l = reverse_map_array(col_ids, A.n)
    
    for k in xrange(A.nnz):
        L.irows[k] = row_g2l[A.irows[k]]
        L.icols[k] = col_g2l[A.icols[k]]
        
    L.vals[:] = A.vals[:]
    
    return L

def localize_xghost(recv, xghost, g2gh_y, fn):
    xghost[:] = 0.0
    xghost[g2gh_y[fn]] = recv

def dump(name, A):
    m = numpy.zeros((A.m, A.n))
    
    for k in xrange(A.nnz):
        m[A.irows[k], A.icols[k]] = A.vals[k]
    
    return name + str(m)

# Creates sparse submatrix from given irows,
# icols and vals arrays. Only those triples
# are taken that are present in the ids array.

def create_submatrix(m, n, irows, icols, vals, ids):
    
    A = sparse.SparseMatrix(m, n, ids.size)
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

    local = create_submatrix(m, n, irows, icols, vals, mids.compressed())

    mids.mask = mids.mask ^ True
    ghost = create_submatrix(m, n, irows, icols, vals, mids.compressed())
    
    return (local, ghost)

def distribute_matrix(comm, A, d, rank, size):
    local = ghost = None
    
    if rank == 0:
        
        e = d[A.irows]
        ids = numpy.arange(e.size)
        
        for i in xrange(size):
            
            pids = numpy.ma.array(ids, mask=(e != i)).compressed()
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
# vi - array of total x indices that are needed.
# d - matrix decomposition.
# rank - the id of the current process.
# size - the total number of processes.

def from_neighs(vi, d, rank, size):
    
    fn = [numpy.empty(0, dtype=int)] * size
    nd = d[vi]
    
    for i in xrange(size):
        if i == rank:
            continue
        
        # filter only neighbor indices
        ins = numpy.ma.MaskedArray(vi, nd != i).compressed()
    
        if ins.size > 0:
            fn[i] = ins
            
    return fn
