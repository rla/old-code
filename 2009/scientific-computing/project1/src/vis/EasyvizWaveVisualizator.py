import numpy
import scitools
import logging
import time
import subprocess
import os

from scitools.easyviz import surfc, ndgrid

from util.Wave import *
from WaveVisualizator import *

class EasyvizWaveVisualizator(WaveVisualizator):
    log = logging.getLogger("visualizator")
    
    def __init__(self, n, tmp_prefix):
        self._n = n
        self._values = numpy.matrix(numpy.zeros((n + 1, n + 1)))
        self._tmp_prefix = tmp_prefix
        self._frame_nr = 0
        
        space = numpy.linspace(0, 1, n + 1)
        self._grid = ndgrid(space, space)
        
        self._clean_files()
        
    def visualize_frame(self, wave):
        assert isinstance(wave, Wave)
        assert (self._n - 1) ** 2 == len(wave.values)
        
        self._put_values(wave)
        
        start = time.time()  
        surfc(
              self._grid[0],
              self._grid[1],
              self._values,
              zmin = -1.0,
              zmax = 1.0,
              hardcopy = self._tmp_prefix + ("%04d" % self._frame_nr) + ".png",
              show = False
        )
        EasyvizWaveVisualizator.log.debug("surfc took %f" % (time.time() - start))
        
        self._frame_nr += 1
        
    def finish_visualization(self):
        EasyvizWaveVisualizator.log.debug("generating video from frames")
        
        start = time.time()
        self.generate_video("movie.avi")
        
        EasyvizWaveVisualizator.log.debug("video generated in %.15f" % (time.time() - start))
    
    def generate_video(self, filename):
        
        # I found it from http://web.njit.edu/all_topics/Prog_Lang_Docs/html/mplayer/encoding.html
        
        subprocess.Popen([
                        "mencoder",
                         "mf://" + self._tmp_prefix + "*.png",
                         "-mf", "w=640:h=480:fps=10:type=png",
                         "-of", "avi",
                         "-ovc", "lavc",
                         "-o", filename],
                         stdin = None,
                         stdout = subprocess.PIPE,
                         stderr = subprocess.PIPE,
                         close_fds = True).wait()
        
    def _put_values(self, wave):
        m = self._n - 1
        for i in xrange(m):
            r = m - i
            self._values[r, 1:m + 1] = wave.values[(r - 1) * m:(r - 1) * m + m]
        
    def _clean_files(self):
        tmpfiles = filter(lambda n: n.startswith(self._tmp_prefix), os.listdir("."))
        
        EasyvizWaveVisualizator.log.debug("Removing %d temporary files" % len(tmpfiles))
        
        for fname in tmpfiles:
            os.remove(fname)
