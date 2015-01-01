import numpy as np
import util
import time
import sys

from mpi4py import MPI

from SparseMatrix import *
from LaplacianGenerator import *

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

# Sets up initial values and distributes
# domain d.

if rank == 0:
    
    n = 100
    if (len(sys.argv) > 1):
        n = int(sys.argv[1])
        
    print "n =", n
        
    A = LaplacianGenerator(n, 0.5, 0.5, lambda x,y: 1.0).sparse()
    q = (n - 1) * (n - 1)
    dp = q / size
    
    # Constructs the domain decomposition.
    # Distributes using the formula i % size.
    
    d = np.empty(q, dtype=int)
    for i in xrange(q):
        d[i] = i % size
    
    x = np.linspace(0.0, 10.0, q)
    
    start = time.time()
    ycorrect = A * x
    
    print "Time taken for non-parallelized multiplication: %.15f" % (time.time() - start)
    
    comm.bcast(d, root=0)
    
else:
    x = None
    d = comm.bcast(None, root=0)
    A = None

start = time.time()

# Mapping arrays:
#
# l2g_x - maps local row index to global row index.
# l2g_y - maps local column index to global column index.
# gh2g_x - maps local ghost row index to global row index.
# gh2g_y - maps local ghost column index to global column index.
# g2l_x - maps global row index to local row index.
# g2l_y - maps global column index to local column index.
# g2gh_y - maps global ghost index to local ghost index.

ids = np.arange(d.size)
gh2g_x = l2g_x = l2g_y = util.fix_p24_compressed(np.ma.MaskedArray(ids, mask=(d != rank)).compressed(), dtype=int)
gh2g_y = util.fix_p24_compressed(np.ma.MaskedArray(ids, mask=(d == rank)).compressed(), dtype=int)
g2gh_y = util.reverse_map_array(gh2g_y, d.size)
g2l_y = g2l_x = util.reverse_map_array(l2g_x, d.size)

l2gs = comm.gather(l2g_x, root=0)

# Distributes vector x.

if rank == 0:
    vecs = []
    for i in xrange(size):
        vecs.append(x[l2gs[i]])
else:
    vecs = None
        
xlocal = comm.scatter(vecs, root=0)

# Distributes the matrix A into local
# and ghost matrices between processes.

lA, rA = util.distribute_matrix(comm, A, d, rank, size)
local = util.localize(l2g_x, l2g_y, lA)
ghost = util.localize(gh2g_x, gh2g_y, rA)

# Calculates which elements from the
# neighbours are needed.
#
# from_neighs - maps process id into an array of global x indices that
#               have to be retrieved from that process.
# to_heighs - maps process id into an array of global x indices that
#             have to be send to that process.

from_neighs = util.from_neighs(rA, d, rank, size)
to_neighs = comm.alltoall(from_neighs)

# Prepares buffers for data retrieval.
# xghost - whole xghost array.
# recv - receive buffer for x from a single neighbour.

xghost = np.zeros(ghost.n, dtype=float)
recv = np.zeros(ghost.n, dtype=float)

# Calculates the initial result from
# non-ghost parts.

ylocal = local * xlocal

# Data communication loop.

for i in xrange(len(to_neighs)):
    if i == rank:
        continue
    
    result = comm.Irecv([recv, MPI.FLOAT], source=i)
    
    # Sends x values that process i needs.
    # process id -> global index -> local index
    
    comm.Send([xlocal[g2l_y[to_neighs[i]]], MPI.FLOAT], dest=i)
    result.Wait()
    
    # Copies received values into xghost.
    
    util.localize_xghost(recv, xghost, g2gh_y, from_neighs[i])
    
ylocal += ghost * xghost

# Collects the solution.
    
y = comm.gather(ylocal, root=0)

if rank == 0:
    
    # The result have to be reindexed, too.
    # Reindexing is done using array l2gs.
    
    y = np.vstack(y)
    y.shape = (d.size)
    l2gs = util.reverse_map_array(np.hstack(l2gs).flatten(), d.size)
    y = y[l2gs]
    y.shape = (d.size, 1)
    
    print "Time taken for parallelized multiplication: %.15f" % (time.time() - start)
    
    if (np.sum(y - ycorrect) < 0.0000001):
        print "Solution is OK"
    else:
        print "Solution might contain an error"