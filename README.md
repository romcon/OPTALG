# OPTALG

[![Build Status](https://travis-ci.org/romcon/OPTALG.svg?branch=master)](https://travis-ci.org/romcon/OPTALG)

## Overview

OPTALG is a Python package that provides algorithms, wrappers, and tools for solving optimization problems. Currently, it contains the following:
* Newton-Raphson algorithm for solving systems of equations.
* Primal-dual interior-point algorithms for solving convex problems.
* Augmented Lagrangian algorithm for solving problems with convex objective.
* Interface for the interior-point solver [Ipopt](https://projects.coin-or.org/Ipopt) (via cython).
* Interface for the linear programming solver [Clp](https://projects.coin-or.org/Clp) (via command-line or cython).
* Interface for mixed-integer linear programming solver [Cbc](https://projects.coin-or.org/Cbc) (via command-line or cython).
* Common interface for linear solvers ([SuperLU](http://crd-legacy.lbl.gov/~xiaoye/SuperLU/), [MUMPS](http://mumps-solver.org), [UMFPACK](https://directory.fsf.org/wiki/UMFPACK)) (via cython).

This package is meant to be used by other Python packages and not by users directly. Currently, it is used by:
* [GRIDOPT](https://github.com/romcon/GRIDOPT)
* [OPTMOD](https://github.com/romcon/OPTMOD)

## Documentation

For EPRI developers, see the guides documentation in <https://gitlab.epri.com/gat-devs/guides/-/blob/master/tool-guides/OPTALG.md>.

The version 1.1.7 documentation for this package can be found in <http://optalg.readthedocs.io/>.
But, it is preferred that you build the documentation using Sphinx (prerequisite) by going to the docs folder. Then run `make html` to build html documentation and `make latexpdf` to build the pdf file via latexpdf.

## License

BSD 2-clause license.
