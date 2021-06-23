.. include:: defs.hrst

.. _start:

***************
Getting Started
***************

This section describes how to get started with OPTALG.

.. _start_installation:

Installation
============

In order to install OPTALG, the following tools are needed:

* Linux and Mac OS X:

  * C compiler
  * |make|
  * |python| (2 or 3)
  * |pip|

* Windows:

  * |anaconda| (for Python 3)
  * |msvc| (tested with MVSC 2015+, v15+)
  * |7-zip| (update system path to include the 7z executable, typically in ``C:\Program Files\7-Zip``)

After getting these tools, the OPTALG Python module can be installed using::

  pip install numpy cython
  pip install optalg

By default, no wrappers are built for any external solvers. If the environment variable ``OPTALG_IPOPT`` has the value ``true`` during the installation, OPTALG will download and build the solver |ipopt| for you, and then build its Python wrapper. Similarly, if the environment variables ``OPTALG_CLP`` amd ``OPTALG_CBC`` have the value ``true`` during the installation, OPTLAG will download and build the solvers |clp| and |cbc| for you, and then build their Python wrappers.

.. note:: Currently, the installation with |clp| and |cbc| does not work on Windows.

Alternatively, there are solver wrappers to command line interface of |clp|, |cbc| and |cplex| that are platform independent. You can install these tools separately and make edit the PATH environment variable so that OPTALG will try to make the system call to the application.

To install the module from source, the code can be obtained from `<https://github.com/romcon/OPTALG>`_, and then the following commands can be executed on the terminal or Anaconda prompt from the root directory of the package::

    pip install numpy cython
    python setup.py install

Running the unit tests can be done with::

    pip install nose
    python setup.py build_ext --inplace
    nosetests -s -v
