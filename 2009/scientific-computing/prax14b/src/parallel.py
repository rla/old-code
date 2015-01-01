

from mpi4py import MPI
import numpy as np

import sparse

comm = MPI.COMM_WORLD

def initialize(idomains_):
    global idomains, local2global, local2globals
    
    # broadcast distribution information to others
    if comm.Get_rank()==0:
        idomains = idomains_
        comm.bcast(idomains_, root=0)
    else:
        idomains = comm.bcast(None, root=0)

    # find local indices
    local2global = np.ma.MaskedArray(np.arange(idomains.size),
                                     idomains!=comm.Get_rank()).compressed()

    # save all l2g on root
    local2globals = comm.gather(local2global, root=0)
    

def distribute(vec):
    vecs = None 
    if comm.Get_rank() == 0:
        n = idomains.size
        all_inds = np.arange(n)

        vecs = []
        for i in xrange(comm.Get_size()):
            vecs.append(vec[local2globals[i]])

    d_vec = comm.scatter(vecs, root=0)
    return d_vec

def collect(vec):
    xs = comm.gather(vec, root=0)
    if comm.Get_rank()==0:
        size = reduce(lambda s,x: s+x.size, xs, 0)
        y = np.zeros(size)
        for i in xrange(comm.Get_size()):
            y[local2globals[i]] = xs[i]
        
        return y.reshape(y.size,1)


def sum(x):
    s = np.sum(x)
    return np.sum(comm.allgather(s))

def dot(x,y):
    s = np.dot(x,y)
    return np.sum(comm.allgather(s))
    


class SparseMatrix(object):

    def __init__(self, sp_m):
        self.m = sp_m!=None and sp_m.m or None
        self.n = sp_m!=None and sp_m.n or None
        self._distribute(sp_m)
        self._prepare_communication()
        self._reindex_locally()

    def _distribute(self, sp_m):
        self.m, self.n = comm.bcast((self.m, self.n), root=0)
        
        # on root process divide the matrix according to domains and send to others
        if comm.Get_rank()==0:
            
            # domains of elements by rows
            el_domains = idomains[sp_m.irows]

            all_inds = np.arange(el_domains.size)
            # for each process
            for i in xrange(comm.Get_size()):
                inds = np.ma.array(all_inds,mask=(el_domains!=i))
                inds = inds.compressed()

                # pieces of the matrix for process i
                irows = sp_m.irows[inds]
                icols = sp_m.icols[inds]
                vals = sp_m.vals[inds]
                # save locally or send and save remotely
                if i==0:
                    self._createMatrices(sp_m.m, sp_m.n, irows, icols, vals)
                else:
                    comm.send((sp_m.m,sp_m.n,irows,icols,vals), i, tag=55)
                    
        else:
            # recv matrix
            m, n, irows, icols, vals = comm.recv(source=0, tag=55)
            self._createMatrices(m, n, irows, icols, vals)


    def _createMatrices(self, m, n, irows, icols, vals):
        # domains of elements by column
        el_domains = idomains[icols]
        inds = np.ma.array(np.arange(icols.size),mask=(el_domains!=comm.Get_rank()))

        # create local matrix
        local_inds = inds.compressed()
        lA = sparse.SparseMatrix(m,n,local_inds.size)
        lA.irows[:] = irows[local_inds]
        lA.icols[:] = icols[local_inds]
        lA.vals[:] = vals[local_inds]
        self._local_mat = lA

        # create remote matrix
        inds.mask = inds.mask ^ True
        remote_inds = inds.compressed()
        rA = sparse.SparseMatrix(m,n,remote_inds.size)
        rA.irows[:] = irows[remote_inds]
        rA.icols[:] = icols[remote_inds]
        rA.vals[:] = vals[remote_inds]
        self._ghost_mat = rA


    def _prepare_communication(self):
        "Notify neighbours which elements we want from them."

        # find vector indices that are present in ghost_mat.icols,
        #   i.e. we are interested in uniq(icols), but do not want to use sort()
        #   operation, so do the following steps (hoping it is cheaper for large n)
        n = self._ghost_mat.n
        vec_count = np.zeros(n, dtype=int)
        count = np.bincount(self._ghost_mat.icols)
        vec_count[:count.size] = count
        vec_all_inds = np.arange(n)
        vec_inds = np.ma.MaskedArray(vec_all_inds, vec_count==0).compressed()

        # now calculate what vector elements do we need from each neighbor        
        self._from_neighs = [np.empty(0, dtype=int)]*comm.Get_size()
        ## determine domain (i.e. neighbor) for each vector index
        vec_inds_domains = idomains[vec_inds]
        ## one neighbor at a time
        for i in xrange(comm.Get_size()):
            if i==comm.Get_rank():
                continue
            # filter only neighbor indices
            inds = np.ma.MaskedArray(vec_inds, vec_inds_domains!=i)
            vec_neigh_inds = inds.compressed()

            if vec_neigh_inds.size>0: # not empty
                self._from_neighs[i] = vec_neigh_inds
        
        # send to others indices we need from them
        self._to_neighs = comm.alltoall(self._from_neighs)            

    def _reindex_locally(self):
        N = idomains.size
        NL = local2global.size # number of local unknowns
        ghost2local = np.hstack(self._from_neighs)
        NG = ghost2local.size # number of ghost unknowns

        global2local = np.empty(N, dtype=int)
        global2local[:] = -1
        global2local[local2global] = np.arange(NL)
        global2local[ghost2local] = np.arange(NG)
        
        print "global2local=", global2local
        
        print "local_mat="
        dump(self._local_mat)
        
        print "ghost_mat="
        dump(self._ghost_mat)
        
        print "from_neighs=", self._from_neighs, " rank=", comm.Get_rank()
        print "to_neighs=", self._to_neighs, " rank=", comm.Get_rank()

        raise NotImplementedError("Implement reindexing of local_mat, ghost_mat, to_neighs, and from_neighs in Lab 12")


    def __mul__(self, x):
        raise NotImplementedError("Implement parallel Ax in Lab 12")
    
def dump(A):
    m = np.zeros((A.m, A.n))
    
    for k in xrange(A.nnz):
        m[A.irows[k], A.icols[k]] = A.vals[k]
        
    print m
    

if __name__=='__main__':
    # run with `mpirun -np 2 python parallel.py`
    assert comm.Get_size()==2
    M = None
    x = None
    if comm.Get_rank()==0:
        M = np.matrix([[1,2,0,0],[3,2,0,2],[0,-2,4,-0.5],[1,0,0,2]], dtype=float)
        print "M=\n", M
        M = sparse.as_sparse_matrix(M)

        x = np.array([1.2, -3., 0.22, 0.2])
        x = x.reshape(x.size,1)
        print "x=", x
        #print "y=", M*x

    initialize(np.array([0,0,1,1]))
    d_M = SparseMatrix(M)
    d_x = distribute(x)

    y_d = d_M*d_x

    y = collect(y_d)
    if comm.Get_rank()==0:
        print y

