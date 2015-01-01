from WaveVisualizator import *

class DummyWaveVisualizator(WaveVisualizator):
    
    """The dummy visualization class."""
        
    def visualize_frame(self, wave):
        
        """This method just passes through without drawing
        any visualization."""
        
        pass
    
    def finish_visualization(self):
        
        pass