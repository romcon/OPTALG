# ****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2019, Tomas Tinoco De Rubira.        #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
# ****************************************************#

import os
import sys
import numpy as np
from subprocess import call
from Cython.Build import cythonize
from setuptools import setup, Extension
import py_compile
from setuptools.command.build_py import build_py
from setuptools.command.bdist_egg import bdist_egg
from wheel.bdist_wheel import bdist_wheel


# External libraries
if "darwin" in sys.platform.lower() or "linux" in sys.platform.lower():
    return_code = call(["./build_lib.sh"])
else:
    return_code = call(["build_lib.bat"])
if return_code != 0:
    raise ValueError("Unable to build external library")

# Libraries and extra link args
if "darwin" in sys.platform.lower():
    libraries_mumps = ["coinmumps"]
    libraries_ipopt = ["ipopt"]
    extra_link_args = ["-Wl,-rpath,@loader_path/"]
elif "linux" in sys.platform.lower():
    libraries_mumps = ["coinmumps"]
    libraries_ipopt = ["ipopt"]
    extra_link_args = [
        "-Wl,-rpath=$ORIGIN",
        "-Wl,-rpath=$ORIGIN/../../lin_solver/_mumps",
        "-Wl,-rpath=$ORIGIN/../../lin_solver/_klu",
    ]
else:
    libraries_mumps = ["coinmumps.dll"] #["IpOptFSS"]
    libraries_ipopt = ["ipopt.dll"] #["IpOpt-vc10"]
    extra_link_args = None

# Extension modules
ext_modules = []

# IPOPT and MUMPS
if os.environ.get("OPTALG_IPOPT") == "true":
    # MUMPS
    ext_modules += cythonize(
        [
            Extension(
                name="optalg.lin_solver._mumps._dmumps",
                sources=["./optalg/lin_solver/_mumps/_dmumps.pyx"],
                libraries=libraries_mumps,
                include_dirs=[
                    "./lib/build/include/coin-or/mumps",
                    "./lib/build/include/coin-or",
                ],
                library_dirs=[
                    "./lib/build/lib",
                    "./lib/build/bin",
                    # "./lib/ipopt/build/lib"
                ],
                extra_link_args=extra_link_args,
                define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            )
        ],
        language_level=3,
    )

    # IPOPT
    ext_modules += cythonize(
        [
            Extension(
                name="optalg.opt_solver._ipopt.cipopt",
                sources=["./optalg/opt_solver/_ipopt/cipopt.pyx"],
                libraries=libraries_ipopt,
                include_dirs=[
                    np.get_include(),
                    "./lib/build/include/coin-or/mumps",
                    "./lib/build/include",
                ],
                library_dirs=[
                    "./lib/build/lib",
                    "./lib/build/bin",
                ],
                extra_link_args=extra_link_args,
                define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            )
        ],
        language_level=3,
    )

# CLP
if os.environ.get("OPTALG_CLP") == "true":
    ext_modules += cythonize(
        [
            Extension(
                name="optalg.opt_solver._clp.cclp",
                sources=["./optalg/opt_solver/_clp/cclp.pyx"],
                libraries=["Clp"],
                include_dirs=[np.get_include(), "./lib/clp/include"],
                library_dirs=["./lib/clp/lib"],
                extra_link_args=extra_link_args,
                define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            )
        ],
        language_level=3,
    )

# CBC
if os.environ.get("OPTALG_CBC") == "true":
    ext_modules += cythonize(
        [
            Extension(
                name="optalg.opt_solver._cbc.ccbc",
                sources=["./optalg/opt_solver/_cbc/ccbc.pyx"],
                libraries=["CbcSolver"],
                include_dirs=[np.get_include(), "./lib/cbc/", "./lib/cbc/include"],
                library_dirs=["./lib/cbc/lib"],
                extra_link_args=extra_link_args,
                define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            )
        ],
        language_level=3,
    )

# KLU solver
if os.environ.get("OPTALG_KLU") == "true":
    ext_modules += cythonize(
        [
            Extension(
                name="optalg.lin_solver._klu.klu",
                sources=["./optalg/lin_solver/_klu/klu.pyx"],
                libraries=["KLU"],
                include_dirs=[
                    np.get_include(),
                    "./lib/SuiteSparse/Include",
                    "./lib/SuiteSparse/KLU/",
                    "./lib/SuiteSparse/AMD/include",
                    "./lib/SuiteSparse/BTF/include",
                    "./lib/SuiteSparse/COLAMD/include",
                    "./lib/SuiteSparse/CSparse/include",
                    "./lib/SuiteSparse/SuiteSparse_config",
                    "./lib/SuiteSparse/KLU/include",
                ],
                library_dirs=["./lib/SuiteSparse"],
                extra_link_args=extra_link_args,
                define_macros=[("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION")],
            )
        ],
        language_level=3,
    )

exec(open(os.path.join("optalg", "version.py")).read())


# Custom distribution build commands
class bdist_wheel_compiled(bdist_wheel):
    """Small customizations to build compiled only wheel."""

    description = "build compiled wheel distribution"


class bdist_egg_compiled(bdist_egg):
    """Small customizations to build compiled only egg."""

    description = "build compiled egg distribution"


if len(sys.argv) > 1 and "compiled" in sys.argv[1]:

    class build_py(build_py):
        """
        A custom build_py command to exclude source files from packaging and
        include compiled pyc files instead.
        """

        def byte_compile(self, files):
            for file in files:
                full_path = os.path.abspath(file)
                if file.endswith(".py"):
                    print("{}  compiling and unlinking".format(file))
                    py_compile.compile(file, cfile=file + "c")
                    os.unlink(file)
                elif file.endswith("pyx") or file.endswith("pxd"):
                    print("{}  unlinking".format(file))
                    os.unlink(file)

    extra_cmd_classes = {
        "bdist_wheel_compiled": bdist_wheel_compiled,
        "bdist_egg_compiled": bdist_egg_compiled,
        "build_py": build_py,
    }

else:
    extra_cmd_classes = {
        "bdist_wheel_compiled": bdist_wheel_compiled,
        "bdist_egg_compiled": bdist_egg_compiled,
    }

setup(
    name="OPTALG",
    zip_safe=False,
    version=__version__,
    description="Optimization Algorithms and Wrappers",
    url="https://github.com/romcon/OPTALG",
    author="Adam Wigington, Fan Zhang, Swaroop Guggilam",
    author_email="awigington@epri.com",
    include_package_data=True,
    cmdclass=extra_cmd_classes,
    license="BSD 2-Clause License",
    packages=[
        "optalg",
        "optalg.lin_solver",
        "optalg.lin_solver._mumps",
        "optalg.lin_solver._klu",
        "optalg.opt_solver",
        "optalg.opt_solver._ipopt",
        "optalg.opt_solver._clp",
        "optalg.opt_solver._cbc",
    ],
    install_requires=["cython>=3.0", "numpy>=1.20", "scipy>=1.0", "pytest"],
    package_data={
        "optalg.lin_solver._mumps": ["libcoinmumps*", "*.dll"], # Add dll names for windows
        "optalg.lin_solver._klu": ["KLU*", "*.dll", "libKLU*"],
        "optalg.opt_solver._ipopt": ["libipopt*", "*.dll"], # Add dll names for windows
        "optalg.opt_solver._clp": ["libClp*"],
        "optalg.opt_solver._cbc": ["libCbc*"],
        "": ["*.dll", "*.txt"],
    },
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "License :: OSI Approved :: BSD License",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
    ],
    ext_modules=ext_modules,
)
