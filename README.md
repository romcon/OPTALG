# OPTALG

Known working version Python 3.8, 3.9, 3.10.

Python 3.7 is no longer supported, but may still work if numpy is downgraded (previously known working version was 1.16, but that may no longer be compatible with other libraries).

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

## Available Linear Solvers

- SuperLU (default via python's numpy)
- MUMPS wrapper (optional)
  - needs to be built on system and only if IPOPT is built
  - requires ``OPTALG_IPOPT=true``
- KLU wrapper (optional)
  - needs to be built on system
  - requires ``OPTALG_KLU=true``

## Available Optimization Solvers

- AUGL (builtin)
  - an Augmented Lagrangian non-linear programming solver
- INLP (builtin)
  - an interior-point non-linear programming solver
- IQP (builtin)
  - an interior-point quadratic programming solver
- NR (builtin)
  - Newton-Raphson algorithm implementation
- IPOPT wrapper (optional)
  - Interior point nonlinear optimization algorithm from COIN-OR
  - requires ``OPTALG_IPOPT=true``
- CBC wrapper(optional)
  - Mixed integer linear "branch and cut" solver from COIN-OR
  - Only available on Linux/Mac OSX
- CBC CMD (optional)
  - Mixed integer linear "branch and cut" solver from COIN-OR
  - requires user have CLP installed and available via the command-line
- CLP wrapper (optional)
  - Linear programming solver from COIN-OR
  - Only available on Linux/Mac OSX
- CLP CMD (optional)
  - Linear programming solver from COIN-OR
  - requires user have CLP installed and available via the command line
- CPLEX CMD (optional)
  - High performance commercial solver from IBM for linear, mixed-integer and quadratic programming
  - requires user have CPLEX installed and available via the command-line

## Dependencies

Skip this section if you are not building OPTALG with support for IPOPT, CBC, CLP or the KLU wrappers.

Build tools:
* Autotools/automake (linux/mac for )
* CMake (Windows)

Libraries
* LAPACK (for any additional solvers)
* BLAS (for any additional solvers)

### Windows

Install command line versions of CLP and CBC. You will also need CMake (https://cmake.org/) for IPOPT and KLU. 

### Linux (debian)

Install the autotools toolkit chain and CMake.

```
sudo apt install autotools-dev
sudo apt install autoconf
sudo apt install libtool
sudo apt install cmake
```

### Mac OSX

You will need autotools/automake for the IPOPT, CLP and CBC wrappers, but CMake (https://cmake.org/) for KLU. (Ideally we should consolidate to cmake for all packages.) 

If you need autotools/automake:
```
brew install autoconf
brew install autoconf-archive
brew install automake
brew install libtool
```

If you need Cmake:
```
brew install cmake
```

I recommend to use the Xcode Accelerate framework's version for LAPACK and BLAS.

However, you can also install openblas and lapack version from homebrew easily:

```
brew install lapack
brew install openblas
```

If you do install them from homebrew then you will need to follow the instructions to make sure they can be found by compilers (at least on MX chip versions of homebrew):

```
export LDFLAGS="-L/opt/homebrew/opt/lapack/lib -L/opt/homebrew/opt/openblas/lib"

export CPPFLAGS="-I/opt/homebrew/opt/lapack/include -I/opt/homebrew/opt/openblas/include"

export PKG_CONFIG_PATH="/opt/homebrew/opt/lapack/lib/pkgconfig /opt/homebrew/opt/openblas/lib/pkgconfig"
```

You can install command line versions of CBC and CLP easily with homebrew:

```
brew install cbc
brew install clp
```

## Installation

Set any environment variables for needed:
```
OPTALG_KLU=true    # for the KLU wrapper
OPTALG_IPOPT=true  # for the IPOPT wrapper (MUMPS is also installed)
OPAALG_CBC=true    # for the CBC wrapper
OPTALG_CLP=true    # for the CLP wrapper
```

Clone the repo: `git clone https://github.com/romcon/OPTALG.git``

Install with ``python setup.py install`` or ``pip install .`` Or to build locally first do ``python setup.py build_ext --inplace`` (this is required if you want to run the tests).

To run tests ``pytest -s -v ``

To test various supported versions of python ``tox .``

### Reminders and Debugging

If you want to use cplex, cbc or clp via the command-line interface, make sure that you have the binaries ``cplex``, ``cbc``, ``clp`` on your path

When reinstalling, don't forget to clean the contents of the directory `lib` if you want any solver wrapper, e.g. for ipopt, to be re-built run ``clean.sh`` or ``clean.bat``.

Check your output if there are failures, which can be espeically important if using any of the wrappers.



## Documentation

For EPRI developers, see the guides documentation in <https://azuredevops.epri.com/EPRI/GAT Suite/_git/guides?path=/tool-guides/OPTALG.md>.

To build the documentation using Sphinx (prerequisite) go to the docs folder. Then run `make html` to build html documentation and `make latexpdf` to build the pdf file via latexpdf.

## License

BSD 2-clause license.
