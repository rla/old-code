class WaveLaplacian:
    
    def solve_with(self, b):
        
        """Intead of using matrices directly I define
        here an abstract method for using this Laplacian.
        This allows to use both dense and sparse matrices
        (I need them for testing purposes)"""