#! /usr/bin/env python

"""
Main script for wave simulation.
"""

import os
import sys
import getopt
import numpy
import math
import time
import logging

import common
import Stiffness

from InitialConditions import *
from WaveSimulation import *

def main():
    """Main function of wave simulation."""
    
    # Sets up the logging. This will just set the level.
    # The logging output goes into standard output or error.
    
    logging.basicConfig(level=logging.DEBUG)
    
    # I assume this kind of conditional import is required
    # to prevent easyviz initialization which might be non-wanted
    # in some situations.
    
    if common.VISUALIZE:
        from vis.EasyvizWaveVisualizator import EasyvizWaveVisualizator
        visualizator = EasyvizWaveVisualizator(common.N, common.TMP_PREFIX)
    else:
        from vis.DummyWaveVisualizator import DummyWaveVisualizator
        visualizator = DummyWaveVisualizator()
        
    # Sets up the initial conditions (time and space steps, etc.).
    
    initial_conditions = InitialConditions(common.N, common.DX, common.DT, common.STIFFNESS_FUNCTION)
    
    # Sets up the simulation and runs it.

    simulation = WaveSimulation(common.DX, common.DT, initial_conditions, visualizator, common.NT)
    simulation.run()

def usage():
    print """wave [-h|--help] [-N <num>] [-T <real>] [-S <num>] [-v] [--sgs] [-O <num>] [--variable]
\t-h|--help\t this message

\t-N <num>\t grid size (default 50)
\t-T <real>\t simulation time (default 3.0)
\t-S <num>\t number of time steps (default 300)
\t-v      \t visualize
\t--sgs=<n>\t use symmetric Gauss-Seidel as preconditioner with n of iterations
\t-O <num>\t 0 - no optimization, 1 - optimize SGS,
\t\t\t 2 - optimize Ax, 3 - optimize both
\t--variable\t use variable stiffness coefficient for material"""

def parse_options():    
    try:
        opts, args = getopt.getopt(sys.argv[1:], "N:T:S:hvO:", ["help", "sgs=", "variable"])
    except getopt.GetoptError, err:
        # print help information and exit:
        print str(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
        
    for o, a in opts:
        if o == "-N":
            common.N = int(a)
        elif o == "-T":
            common.T = float(a)
        elif o == "-S":
            common.NT = int(a)
        elif o == "-v":
            common.VISUALIZE = True
        elif o in ("-h", "--help"):
            usage()
            sys.exit()

        elif o in ("--sgs"):
            common.USE_PRECONDITIONER = True
            common.SGS_ITERATIONS = int(a)

        elif o in ("-O"):
            a = int(a)
            if a==0:
                pass
            elif a==1:
                common.OPTIMIZE_SGS = True
            elif a==2:
                common.OPTIMIZE_AX = True
            elif a==3:
                common.OPTIMIZE_SGS = True
                common.OPTIMIZE_AX = True
            else:
                usage()
                raise "Invalid optimization value: %d" % a
            
        elif o in ("--variable"):
            common.STIFFNESS_FUNCTION = Stiffness.variable_stiffness
            
        else:
            assert False, "unhandled option"

# --- MAIN ---

parse_options()

_start_time = time.time()

main()

print "Wall time: %.15f" % (time.time()-_start_time)
