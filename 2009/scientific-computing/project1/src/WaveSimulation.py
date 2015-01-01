import logging
import time
import common

from vis.WaveVisualizator import *
from InitialConditions import *

class WaveSimulation:
    
    """The class that contains main steps in the wave simulation."""
    
    log = logging.getLogger("simulation")
    
    def __init__(self, dx, dt, initial_conditions, visualizator, nt):
        assert isinstance(initial_conditions, InitialConditions)
        assert isinstance(visualizator, WaveVisualizator)
        
        self._dx = dx
        self._dt = dt
        self._initial = initial_conditions
        self._visualizator = visualizator
        self._nt = nt
        
    def run(self):
        WaveSimulation.log.debug("starting simulation")
        start = time.time()
        
        # Sets up initial values for u,u_(i-1) and u_(i+1).
        # From page 7 in instructions version 0.2.
        
        v_prev = self._initial.initial_wave()
        v = self._initial.initial_wave()
        v_next = self._initial.zero_wave()
        A = self._initial.laplacian()
        
        for i in xrange(self._nt):
            # Computes a new wave.
            self._step(A, v_prev, v, v_next)
            # Visualizes it.
            self._visualizator.visualize_frame(v)
            # Swaps pointers.
            v_prev, v, v_next = v, v_next, v_prev
            assert v_prev is not v
            assert v_next is not v
            assert v_next is not v_prev
        
        self._visualizator.finish_visualization()
        WaveSimulation.log.debug("simulation took %.15f seconds" % (time.time() - start))
            
    def _step(self, A, v_prev, v, v_next):
        assert isinstance(A, WaveLaplacian)

        b = ((self._dx ** 2) / (self._dt ** 2)) * (2 * v.values - v_prev.values)
        u = A.solve_with(b)
        v_next.copy_from(u)