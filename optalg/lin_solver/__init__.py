#****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2015-2017, Tomas Tinoco De Rubira.   #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
#****************************************************#

from .lin_solver import LinSolver
from .mumps import LinSolverMUMPS
from .superlu import LinSolverSUPERLU

def new_linsolver(name,prop):
    """
    Creates a linear solver.

    Parameters
    ----------
    name : string
    prop : string
    
    Returns
    -------
    solver : :class:`LinSolver <optalg.lin_solver.LinSolver>`
    """
    
    if name == 'mumps':
        return LinSolverMUMPS(prop)
    elif name == 'superlu':
        return LinSolverSUPERLU(prop)
    elif name == 'default':
        try:
            return new_linsolver('mumps',prop)
        except ImportError:
            return new_linsolver('superlu',prop)            
    else:
        raise ValueError('invalid linear solver name')
