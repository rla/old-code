import math
import numpy

class Wave:
    
    """An helper class for Wave values  (vectors u, u_(i-1) etc. in
    the instructions). This class contains additional code for checking
    the correct shape of these vectors."""
    
    def __init__(self, values):
        assert type(values) == numpy.ndarray
        assert len(values.shape) == 1
        self.values = values
    
    def copy_from(self, values):
        
        """Copies data from the given NumPy array into this
        Wave vector."""
        
        assert type(values) == numpy.ndarray        
        assert self.values.shape == values.shape
        
        self.values[:] = values[:]
