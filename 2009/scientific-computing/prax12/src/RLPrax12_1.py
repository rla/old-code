# -*- coding: utf-8 -*-

# Raivo Laanemets
# rlaanemt@ut.ee

import numpy
from mpi4py import MPI

comm = MPI.COMM_WORLD
size = comm.Get_size() # number of processes
rank = comm.Get_rank() # identificator of the current process

# Works with A (11 * 4, 12 * 4) which is (44, 48) matrix.
# It does not work (blocks) with (48, 48). A is split into
# 4 so that buffer is about 11 * 48 * 4 (assuming float numbers).
# This gives about 2kB as the size of the buffer.

n = 11 * size
m = 12 * size
k = 11 * size

# An helper procedure for matrix multiplication.
# Alocal - a part of the first matrix that has beensplit by rows.
# Blocal - a part of the second matrix that has been split by columns.
# Clocal - a part of the resulting matrix, split by columns.
# mlocal - number rows in Alocal
# klocal - number columns in Blocal
# rlocal - offset index in Clocal (the rank of process the Blocal is from)

def do_mult(Alocal, Blocal, Clocal, mlocal, klocal, rlocal):
    koffset = rlocal * klocal
    Clocal[0:mlocal, koffset:koffset+klocal] = (Alocal * Blocal)#[0:mlocal, 0:klocal]

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
    A = numpy.matrix(numpy.random.rand(m, n))
    B = numpy.matrix(numpy.random.rand(n, k))
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

Alocal = comm.scatter(Asplit, root=0)
Blocal = comm.scatter(Bsplit, root=0)

assert Blocal.flags['C_CONTIGUOUS']
assert Alocal.flags['C_CONTIGUOUS']

mlocal = m / size
klocal = k / size
Clocal = numpy.zeros((mlocal, k), dtype=float)

# Multiplies initial data into the Clocal block.
            
do_mult(Alocal, Blocal, Clocal, mlocal, klocal, rank)

# These are process from which to send the old Blocal
# and receive a new Blocal.

dest = (rank + 1) % size
source = (rank - 1) % size

for i in xrange(1, size):
    comm.send(Blocal, dest=dest)
    Blocal = comm.recv(source=source)
    # The original rank of that process that had this Blocal.
    rlocal = (rank - i) % size
    do_mult(Alocal, Blocal, Clocal, mlocal, klocal, rlocal)

# This will be set only on rank=0 process,
# on others it will be None.

C = numpy.array(comm.gather(Clocal, root=0)).flatten()

# On the first process this will print out the
# solution and checks it with built-in multiplication.

if rank == 0:
    C.shape = (m, k)
    AB = numpy.matrix(A) * numpy.matrix(B)
    print "C=", C
    print "AB=", AB
    check_mult(C, AB, m, k)
    