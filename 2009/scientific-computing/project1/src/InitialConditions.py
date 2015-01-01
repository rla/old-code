# Initial wave conditions.

import numpy
import logging
import common

from util.Wave import *
from laplacian.LaplacianGenerator import *
from laplacian.DenseLaplacian import *
from laplacian.SparseLaplacian import *

from cg.ConjugateGradientSolver import *

class InitialConditions:
    
    """An helper class to set up the initial values of some
    important variables."""
    
    log = logging.getLogger("initial")
    
    def __init__(self, n, dx, dt, stiffness_function):
        self._n = n
        self._laplacian_generator = LaplacianGenerator(n, dx, dt, stiffness_function)
        self._initial_wave = common.INITIAL_WAVE
        
    def initial_wave(self):
        
        """Returns initial wave of the simulation. Returns
        a fresh copy of wave at each call."""
        
        return self._wave()
    
    def zero_wave(self):
        
        """Returns a Wave containing only zeros. Returns new
        instance at each call."""
        
        return Wave(numpy.zeros((self._n - 1) ** 2))
    
    def laplacian(self):
        
        """Creates a Laplacian using parameters in the common module."""
        
        if common.DENSE:
            InitialConditions.log.debug("using dense Laplacian")
            return DenseLaplacian(self._n, self._laplacian_generator.triples())
        else:
            InitialConditions.log.debug("using sparse Laplacian")
            InitialConditions.log.debug("cg tolerance: %.15f, max_iter: %i" % (common.CG_TOLERANCE, common.CG_MAX_ITER))
            InitialConditions.log.debug("optimize multiplication in Fortran: " + str(common.OPTIMIZE_AX))
            
            # Creates and sets a preconditioner for CG.
            
            if common.USE_PRECONDITIONER:
                InitialConditions.log.debug("using preconditioner")
                InitialConditions.log.debug("preconditioner iterations: %i" % common.SGS_ITERATIONS)
                if common.OPTIMIZE_SGS:
                    InitialConditions.log.debug("optimizing preconditioner")
                    prec = common.OPT_PRECONDITIONER_CLASS(n_iter = common.SGS_ITERATIONS)
                else:
                    InitialConditions.log.debug("Python preconditioner")
                    prec = common.UNOPT_PRECONDITIONER_CLASS(n_iter = common.SGS_ITERATIONS)
            else:
                InitialConditions.log.debug("not using preconditioner")
                prec = None
            
            # Creates a CG solver for the sparse Laplacian. 
            
            solver = ConjugateGradientSolver(common.CG_TOLERANCE, common.CG_MAX_ITER, prec)
            
            # Creates sparse Laplacian using the solver and triples from the generator. 
            
            return SparseLaplacian(
                                   self._n,
                                   self._laplacian_generator.triples(),
                                   solver,
                                   common.OPTIMIZE_AX
                                   )

    def _wave(self):
        
        """Creates initial Wave by using the initial function."""
        
        x_col = numpy.linspace(0, 1.0, self._n - 1)
        x = numpy.array([x_col] * (self._n - 1))
        y_row = numpy.linspace(0, 1.0, self._n - 1)
        y = numpy.array([y_row] * (self._n - 1)).transpose()
        
        i = self._initial_wave(y, x)
        
        return Wave(i.flatten())
