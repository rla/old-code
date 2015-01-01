import numpy as np
import util
import time
from mpi4py import MPI
from sparse import *
from LaplacianGenerator import *

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

# Sets up initial values and distributes
# domain d.

if rank == 0:
    g = LaplacianGenerator(4, 0.5, 0.5, lambda x,y: 1.0)
    A = g.sparse()
    s = A.m
    d = np.array([0, 0, 1, 1, 2, 2, 3, 3, 3])
    x = np.array([1.0] * 9)    
    comm.bcast(d, root=0)
    #A = as_sparse_matrix(
    #    np.matrix([[1, 2, 0, 0],
    #               [3, 2, 0, 2],
    #               [0, -2, 4, -0.5],
    #               [1, 0, 0, 2]], dtype=float))
    
    print "Ax=", (A * x)
else:
    x = None
    d = comm.bcast(None, root=0)
    A = None

# Mapping arrays:
#
# l2g_x - maps local row index to global row index.
# l2g_y - maps local column index to global column index.
# g2g_x - maps local ghost row index to global row index.
# g2g_y - maps local ghost column index to global column index. 
# g2l_x - maps global row index to local row index.

ids = np.arange(d.size)
gh2g_x = l2g_x = l2g_y = np.ma.MaskedArray(ids, d != rank).compressed()
gh2g_y = np.ma.MaskedArray(ids, d == rank).compressed()
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

lA, rA = util.distribute_matrix(comm, A, d, rank, size)
local = util.localize(l2g_x, l2g_y, lA)
ghost = util.localize(gh2g_x, gh2g_y, rA)

n = rA.n
vec_count = np.zeros(n, dtype=int)
# Assumes rA.icols has at least one value!
count = np.bincount(rA.icols)
vec_count[:count.size] = count
vec_all_inds = np.arange(n)

# Non-0 elements.
vi = np.ma.MaskedArray(vec_all_inds, vec_count == 0).compressed()

from_neighs = util.from_neighs(vi, d, rank, size)
to_neighs = comm.alltoall(from_neighs)

xghost = np.zeros(ghost.n, dtype=float)
recv = np.zeros(ghost.n, dtype=float)
ylocal = local * xlocal

for i in xrange(len(to_neighs)):
    if i == rank:
        continue
    
    result = comm.Irecv([recv, MPI.FLOAT], source=i)
    comm.Send([xlocal[g2l_y[to_neighs[i]]], MPI.FLOAT], dest=i)
    result.Wait()
    util.localize_xghost(recv, xghost, g2gh_y, from_neighs[i])
    ylocal += ghost * xghost
    
y = comm.gather(ylocal, root=0)

if rank == 0:
    y = np.vstack(y)
    y.shape = (d.size)
    l2gs = util.reverse_map_array(np.hstack(l2gs).flatten(), d.size)
    y = y[l2gs]
    y.shape = (d.size, 1)
    print "Y=", y