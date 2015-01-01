class LaplacianGenerator:
    
    """An helper class to generate suitable 2D Laplacian
    matrices. The generator outputs the matrix as a list
    of triples (irow, icol, value)."""
    
    def __init__(self, n, dx, dt, f):
        self._n = n
        self._triples = self._laplacian_2d_triples(n, dx, dt, f)
        
    def triples(self):
        
        """Returns the Laplacian as a set of triples (irow, icol, value).
        Triples are guaranteed to be in row-by-row matrix visiting order starting
        by the first row and the first column."""
        
        return self._triples
    
    def _laplacian_2d_triples(self, n, dx, dt, f):
        m = n - 1
        
        triples = []
        for i in xrange(m * m):
            R = self._row(m, i, dx, dt, f)
            for (icol, value) in R.components():
                triples.append((i, icol, value))
                
        return triples
    
    def _row(self, m, i, dx, dt, f):
        
        """Generates a single row in the matrix. It treats the
        row as the 2D grid as it would be laid out in the visualization
        phase."""
        
        dy = dx
        xi = i % m
        yi = int(i / m)
        x = (xi + 1) * dx
        y = (yi + 1) * dy
        
        left = -f(x - dx/2.0, y)
        right = -f(x + dx/2.0, y)
        down = -f(x, y - dy/2.0)
        up = -f(x, y + dy/2.0)
        
        R = LaplacianRowHelper(m)
        
        if xi > 0: # has left
            R[xi - 1, yi] = left
        if xi < m - 1: # has right
            R[xi + 1, yi] = right
        if yi > 0: # has down
            R[xi, yi - 1] = down
        if yi < m - 1: # has up
            R[xi, yi + 1] = up

        R[xi, yi] = -(left + right + down + up) + (dx ** 2) / (dt ** 2)
        
        return R
        
class LaplacianRowHelper:
    
    """An helper class for building a row of the Laplacian matrix.
    It is used as the 2D grid on which the solution is laid out.
    The values on the grid are set as it were 2D matrix, with
    the row index as the first dimension."""
    
    def __init__(self, m):
        self._tuples = []
        self._m = m
        
    def __setitem__(self, key, value):
        
        """An implementation of Python array/list set operation.
        An example: r[1,2]. It translates the grid coordinates
        (with row coordinate being the first - 1 - in this example)
        automatically into icol value in the final Laplacian as
        the sparse matrix."""
        
        (gridx, gridy) = key
        self._tuples.append((gridx + gridy * self._m, value))  
        
    def components(self):
        
        """Returns the row as list of pairs (icol, value).
        icol is the column index in the final Laplacian as
        the sparse matrix."""
        
        self._tuples.sort()
        return self._tuples

