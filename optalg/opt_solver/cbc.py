#****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2019, Tomas Tinoco De Rubira.        #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
#****************************************************#

from __future__ import print_function
import numpy as np
from .opt_solver_error import *
from .opt_solver import OptSolver
from .problem import OptProblem


class OptSolverCbc(OptSolver):

    parameters = {'mipgap': None,
                  'seconds': None,
                  'maxnodes': None,
                  'maxsolutions': None,
                  'quiet': False
                  }

    def __init__(self):
        """
        Mixed integer linear "branch and cut" solver from COIN-OR.
        """

        OptSolver.__init__(self)
        self.parameters = OptSolverCbc.parameters.copy()

    def supports_properties(self, properties):

        for p in properties:
            if p not in [OptProblem.PROP_CURV_LINEAR,
                         OptProblem.PROP_VAR_CONTINUOUS,
                         OptProblem.PROP_VAR_INTEGER,
                         OptProblem.PROP_TYPE_FEASIBILITY,
                         OptProblem.PROP_TYPE_OPTIMIZATION]:
                return False
        return True

    def solve(self, problem):

        # Import
        from ._cbc import CbcContext

        # Local vars
        params = self.parameters

        # Parameters
        mipgap = params['mipgap']
        seconds = params['seconds']
        maxnodes = params['maxnodes']
        maxsolutions = params['maxsolutions']
        quiet = params['quiet']

        # Problem
        try:
            self.problem = problem.to_mixintlin()
        except:
            raise OptSolverError_BadProblemType(self)

        # Cbc context
        self.cbc_context = CbcContext()
        self.cbc_context.loadProblem(self.problem.get_num_primal_variables(),
                                     self.problem.A,
                                     self.problem.l,
                                     self.problem.u,
                                     self.problem.c,
                                     self.problem.b,
                                     self.problem.b)
        self.cbc_context.setInteger(self.problem.P)

        # Reset
        self.reset()

        # Options
        if mipgap is not None:
            old_mipgap = self.cbc_context.getAllowableFractionGap()
            print("mipgap fraction was {:f} and set to {:f}".format(
                old_mipgap, mipgap))
            self.cbc_context.setAllowableFractionGap(mipgap)
        if seconds is not None:
            self.cbc_context.setParameter("seconds", seconds)
        if maxnodes is not None:
            self.cbc_context.setParameter("maxnodes", maxnodes)
        if maxsolutions is not None:
            self.cbc_context.setParameter("maxsolutions", maxsolutions)
        if quiet:
            self.cbc_context.setLogLevel(0)

        # Solve
        self.cbc_context.solve()

        # Save
        self.x = self.cbc_context.getColSolution()
        # TODO: how to get duals from API?
        if self.cbc_context.status() <= 0:
            if self.cbc_context.isProvenOptimal():
                self.set_status(self.STATUS_SOLVED)
                self.set_error_msg('')
            elif self.cbc_context.isProvenInfeasible():
                self.set_status(self.STATUS_ERROR)
                self.set_error_msg('Problem is infeasible')
            else:
                self.set_status(self.STATUS_ERROR)
                self.set_error_msg('Problem is neither optimal nor infeasible')
        else:
            raise OptSolverError_Cbc(self)

    def get_dual_variables(self):
        # Remove once implemented
        print("Cbc API is not currently able to get dual variables")
