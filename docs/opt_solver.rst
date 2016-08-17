.. _opt_solver:

********************
Optimization Solvers
********************

In OPTALG, optimization solvers are objects derived from the :class:`OptSolver <optalg.opt_solver.OptSolver>` class, and optimization problems are objects derived from the :class:`OptProblem <optalg.opt_solver.OptProblem>` class, which represents general problems of the form 

.. math:: 
   :nowrap:

   \begin{alignat*}{3}
   & \mbox{minimize}   \quad && \varphi(x)     \quad && \\
   & \mbox{subject to} \quad && Ax = b         \quad && : \lambda \\
   &                   \quad && f(x) = 0.      \quad && : \nu \\
   &                   \quad && l \le x \le u. \quad && : \pi, \mu
   \end{alignat*}

Before solving a :class:`problem <optalg.opt_solver.OptProblem>` with a specific solver, the solver parameters can be configured using the method :func:`set_parameters() <optalg.opt_solver.OptSolver.set_parameters>`. Then, the :func:`solve() <optalg.opt_solver.OptSolver.method>` method can be invoked with the :class:`problem <optalg.opt_solver.OptProblem>` to be solved as its argument. The status, optimal primal and optimal dual variables can be extracted using the class methods :func:`get_status() <optalg.opt_solver.OptSolver.get_status>`, :func:`get_primal_variables() <optalg.opt_solver.OptSolver.get_primal_variables>`, and :func:`get_dual_variables() <optalg.opt_solver.OptSolver.get_dual_variables>`, respectively.

.. _opt_solver_nr:

NR
==

This solver solves problems of the form

.. math:: 
   :nowrap:

   \begin{alignat*}{2}
   & \mbox{find}       \quad && x \\
   & \mbox{subject to} \quad && Ax = b \\
   &                   \quad && f(x) = 0.
   \end{alignat*}

using the Newton-Raphson algorithm.

.. _opt_solver_iqp:

IQP
===

This solver, which is represented by the class :class:`OptSolverIQP <optalg.opt_solver.OptSolverIQP>`, solves convex quadratic problems of the form

.. math:: 
   :nowrap:

   \begin{alignat*}{3}
   & \mbox{minimize}   \quad && \frac{1}{2}x^THx + g^Tx \quad && \\
   & \mbox{subject to} \quad && Ax = b                  \quad && : \lambda \\
   &                   \quad && l \le x \le u.          \quad && : \pi, \mu
   \end{alignat*}

using an interior point method. Quadratic problems solved with this solver must be objects derived from the class :class:`QuadProblem <optalg.opt_solver.QuadProblem>`, which is a subclass of :class:`OptProblem <optalg.opt_solver.OptProblem>`. The following example shows how to solve the quadratic problem

.. math:: 
   :nowrap:

   \begin{alignat*}{2}
   & \mbox{minimize}   \quad && 3x_1-6x_2 + 5x_1^2 - 2x_1x_2 + 5x_2^2 \\
   & \mbox{subject to} \quad && x_1 + x_2 = 1 \\
   &                   \quad && 0.2 \le x_1 \le 0.8 \\
   &                   \quad && 0.2 \le x_2 \le 0.8
   \end{alignat*}

using the :class:`OptSolverIQP <optalg.opt_solver.OptSolverIQP>` solver::

  >>> import numpy as np
  >>> from optalg.opt_solver import OptSolverIQP, QuadProblem

  >>> g = np.array([3.,-6.])
  >>> H = np.array([[10.,-2],
  ...               [-2.,10]])

  >>> A = np.array([[1.,1.]])
  >>> b = np.array([1.])

  >>> u = np.array([0.8,0.8])
  >>> l = np.array([0.2,0.2])

  >>> problem = QuadProblem(H,g,A,b,l,u)

  >>> solver = OptSolverIQP()

  >>> solver.set_parameters({'quiet': True,
  ...                        'tol': 1e-6})

  >>> solver.solve(problem)

  >>> print solver.get_status()
  solved

Then, the optimal primal and dual variables can be extracted, and feasibility and optimality can be checked as follows::

  >>> x = solver.get_primal_variables()
  >>> lam,nu,mu,pi = solver.get_dual_variables()

  >>> print x
  [ 0.20  0.80 ]

  >>> print x[0] + x[1]
  1.00

  >>> print l <= x
  [ True  True ]

  >>> print x <= u
  [ True  True ]

  >>> print pi
  [ 9.00e-01  1.80e-06 ]

  >>> print mu
  [ 1.80e-06  9.00e-01 ]

  >>> print np.linalg.norm(g+np.dot(H,x)-np.dot(A.T,lam)+mu-pi)
  1.25e-15

  >>> print np.dot(mu,u-x)
  2.16e-06

  >>> print np.dot(pi,x-l)
  2.16e-06

.. _opt_solver_lccp:

LCCP
====

This solver solves convex linearly-constrained problems of the form

.. math:: 
   :nowrap:

   \begin{alignat*}{3}
   & \mbox{minimize}   \quad && \varphi(x)     \quad && \\
   & \mbox{subject to} \quad && Ax = b         \quad && : \lambda \\
   &                   \quad && l \le x \le u. \quad && : \pi, \mu
   \end{alignat*}

using an interior point method.

.. _opt_solver_augl:

AugL
====

This solver solves convex or non-convex optimization problems of the form

.. math:: 
   :nowrap:

   \begin{alignat*}{3}
   & \mbox{minimize}   \quad && \varphi(x) \quad && \\
   & \mbox{subject to} \quad && Ax = b     \quad && : \lambda \\
   &                   \quad && f(x) = 0.  \quad && : \nu
   \end{alignat*}

using an Augmented Lagrangian algorithm. It requires the objective function to be strongly convex.
