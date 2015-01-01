
"""Constants and variables common to the whole program

@var DENSE: whether to use dense Laplacian
@var VISUALIZE: whether to generate video
@var PRECONDITIONER_CLASS: class or function that returns preconditioner object (1-parameter callable object) for CG, see L{SGSPreconditioner} for example
@var PRECONDITIONER: preconditioner object (1-parameter callable object) that returns
I{z} for a given I{r}
@var SGS_ITERATIONS: number of Symmetric Gauss-Seidel iterations
@var OPTIMIZE_SGS: whether to use Fortran code for Symmetric Gauss-Seidel
@var OPTIMIZE_AX: whether to use Fortran code for matrix-vector multiplication
@var STIFFNESS_FUNCTION: coefficient function that returns stiffness for any point (x,y)
@var CG_TOLERANCE: max error value for the Conjugate Gradient solver
@var CG_MAX_ITER: maximum value of iterations in the Conjugate Gradient solver
@var TMP_PREFIX: name prefix for the temporary image files
@var N: number of segments for (the each axis of) the grid 
@var NT: number of time steps
@var T: end time for the simulation (start time is 0)
@var DT: time step S{Delta}t
@var DX: space step S{Delta}x
"""

import numpy

from cg.prec.SGSPreconditioner import *
from cg.prec.SGSFastPreconditioner import *
from cg.prec.SGSFortranPreconditioner import *
from cg.prec.SGSThropePreconditioner import *
from cg.prec.SGSFortranZeroPreconditioner import *

l_and = numpy.logical_and

def I(x, y):

    return numpy.where(l_and(l_and(x > 0.2, x < 0.3),
                             l_and(y < 0.5, y > 0.4)),
                       2.0,
                       0.0)
    
def I_test_SGS(x, y):

    return numpy.where(l_and(l_and(x > 0.1, x < 0.9),
                             l_and(y > 0.1, y < 0.9)),
                       1.0,
                       0.0)

# This runs the whole thing with dense matrices and uses built-in
# numply.linalg.solve function.
DENSE = False

VISUALIZE = False

USE_PRECONDITIONER = False

# To test preconditioners, N = 4, NT = 6, T = 3.0, I_test_SGS
# z in the first iteration:
# z= [ 0.01133408  0.02408493  0.01101583  0.02408493  0.08085519  0.02387329
#  0.01101583  0.02387329  0.01109741]

# There are various preconditioners available:

#PRECONDITIONER_CLASS = SGSPreconditioner
#PRECONDITIONER_CLASS = SGSFastPreconditioner
#PRECONDITIONER_CLASS = None
#PRECONDITIONER_CLASS = SGSFortranPreconditioner
#PRECONDITIONER_CLASS = SGSThropePreconditioner

# Non-optimized preconditioner class
UNOPT_PRECONDITIONER_CLASS = SGSFastPreconditioner

# Optimized preconditioner class
OPT_PRECONDITIONER_CLASS = SGSFortranZeroPreconditioner

SGS_ITERATIONS = 3
#INITIAL_WAVE = I_test_SGS
INITIAL_WAVE = I
OPTIMIZE_SGS = False
OPTIMIZE_AX = False
STIFFNESS_FUNCTION = lambda x,y: 1.0
CG_TOLERANCE = 1E-10
CG_MAX_ITER = 1000
TMP_PREFIX = "tmp2D_"
N = 50
NT = 300
T = 1.0
DT = T/NT
DX = 1.0/N
