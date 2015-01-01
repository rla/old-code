# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import numpy
import sys
import time
from mpi4py import MPI

comm = MPI.COMM_WORLD
size = comm.Get_size() # number of processes
rank = comm.Get_rank() # identificator of the current process

# Size is read as the first argument.

sizemult = int(sys.argv[1])

n = sizemult * size
m = sizemult * size
k = sizemult * size

if rank == 0:
    print "n=%i, m=%i, k=%i" % (n, m, k)

debug = "debug" in sys.argv

# An helper procedure for matrix multiplication.
# Alocal - a part of the first matrix that has beensplit by rows.
# Blocal - a part of the second matrix that has been split by columns.
# Clocal - a part of the resulting matrix, split by columns.
# mlocal - number rows in Alocal
# klocal - number columns in Blocal
# rlocal - offset index in Clocal (the rank of process the Blocal is from)

def do_mult(Alocal, Blocal, Clocal, mlocal, klocal, rlocal):
    koffset = rlocal * klocal
    for i in xrange(mlocal):
        for j in xrange(klocal):
            Clocal[i, koffset + j] = numpy.sum(Alocal[i] * Blocal[j])
            
    # Vectorized version requires Blocal in other shape.
    # It makes new array for multiplication block, therefore I do
    # not use it here.
    
    #Clocal[0:mlocal, koffset:koffset+klocal] = (Alocal * Blocal)[0:mlocal, 0:klocal]

# An helper procedure for checking whether the multiplication
# result is correct.
            
def check_mult(C, AB, m, k):
    print "Checking multiplication result"
    eps = 10E-6
    if numpy.sum(numpy.matrix(C) - AB) > eps:
        raise Exception("Multiplication contains an error")
    print "OK"

# Generates and splits both matrices on the
# first process.

if rank == 0:
    #A = numpy.matrix(numpy.random.rand(m, n))
    #B = numpy.matrix(numpy.random.rand(n, k))
    A = numpy.random.rand(m, n)
    B = numpy.random.rand(n, k)
    if debug:
        print "A=", A
        print "B=", B
    Asplit = numpy.vsplit(A, size)
    Bsplit = numpy.hsplit(B, size)
else:
    # These will be initially empty at the start on
    # other processes and will be set during
    # comm.scatter below.
    Asplit = None
    Bsplit = None
    
start = time.time()

if debug:
    print "%i before first scatter" % rank
    
Alocal = comm.scatter(Asplit, root=0)

if debug:
    print "%i after first scatter" % rank
    
Blocal = numpy.ascontiguousarray(comm.scatter(Bsplit, root=0).transpose())

assert Alocal.flags['C_CONTIGUOUS']
assert Blocal.flags['C_CONTIGUOUS']

mlocal = m / size
klocal = k / size
Clocal = numpy.zeros((mlocal, k), dtype=float)

# Multiplies initial data into the Clocal block.
            
do_mult(Alocal, Blocal, Clocal, mlocal, klocal, rank)

# These are process from which to send the old Blocal
# and receive a new Blocal.

dest = (rank + 1) % size
source = (rank - 1) % size

# A buffer for receiving Blocal values. For sending,
# Blocal itself works as the buffer.

BlocalRecv = numpy.zeros(Blocal.shape, dtype=float)
assert BlocalRecv.flags['C_CONTIGUOUS']

commtime = 0.0

for i in xrange(1, size):
    # I could not find how to use Irecv and Isend correctly.
    # Page 5 in the manual only states that these functions exist.
    # I reached this solution by reading some source here:
    # http://www.cs.utk.edu/~luszczek/hpcc/python/hpcc.py
    
    # I also try to measure communication time here.
    
    commstart = time.time()
    if debug:
        print "%i before irecv" % rank
    recvResult = comm.Irecv([BlocalRecv, MPI.FLOAT], source=source)
    if debug:
        print "%i after irecv, before send" % rank
    comm.Send([Blocal, MPI.FLOAT], dest=dest)
    if debug:
        print "%i after send" % rank
    recvResult.Wait()
    if debug:
        print "%i after irecv wait" % rank
    commtime += time.time() - commstart
    
    # Swaps buffers.
    Blocal, BlocalRecv = BlocalRecv, Blocal
    
    # The original rank of that process that had this Blocal.
    rlocal = (rank - i) % size
    do_mult(Alocal, Blocal, Clocal, mlocal, klocal, rlocal)

# This will be set only on rank=0 process,
# on others it will be None.

C = numpy.array(comm.gather(Clocal, root=0)).flatten()
commtime_total = numpy.sum(comm.gather(commtime, root=0))

# On the first process this will print out the
# solution and checks it with built-in multiplication.

if rank == 0:
    print "Multiplication took: %.15f seconds" % (time.time() - start)
    print "Communication time: %.15f seconds" % commtime_total
    
    C.shape = (m, k)
    
    print "Finding built-in multiplication"
    start = time.time()
    AB = numpy.matrix(A) * numpy.matrix(B)
    print "Built-in multiplication took: %.15f seconds" % (time.time() - start)
    
    if debug:
        print "C=", C
        print "AB=", AB
    check_mult(C, AB, m, k)
    