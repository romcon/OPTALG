#****************************************************#
# This file is part of OPTALG.                       #
#                                                    #
# Copyright (c) 2019, Tomas Tinoco De Rubira.        #
#                                                    #
# OPTALG is released under the BSD 2-clause license. #
#****************************************************#

import os
import sys
import numpy as np
from subprocess import call
from Cython.Build import cythonize
from setuptools import setup, Extension
import py_compile
from distutils import log
from setuptools.command.build_py import build_py
from setuptools.command.bdist_egg import bdist_egg
from wheel.bdist_wheel import bdist_wheel
from django.templatetags.i18n import language

# External libraries
if 'darwin' in sys.platform.lower() or 'linux' in sys.platform.lower():
    return_code = call(["./build_lib.sh"])
else:
    return_code = call(["build_lib.bat"])
if return_code != 0:
    raise ValueError('Unable to build external library')

# Libraries and extra link args
if 'darwin' in sys.platform.lower():
    libraries_mumps = ['coinmumps']
    libraries_ipopt = ['ipopt']
    extra_link_args = ['-v','-Wl,-rpath,@loader_path/']
elif 'linux' in sys.platform.lower():
    libraries_mumps = ['coinmumps']
    libraries_ipopt = ['ipopt']
    extra_link_args = ['-Wl,-rpath=$ORIGIN', '-Wl,-rpath=$ORIGIN/../../lin_solver/_mumps']
else:
    libraries_mumps = ['IpOptFSS']
    libraries_ipopt = ['IpOpt-vc10']
    extra_link_args = ['']

# Extension modules
ext_modules = []

# IPOPT and MUMPS
if os.environ.get('OPTALG_IPOPT') == 'true':

    # MUMPS
    ext_modules += cythonize([Extension(name='optalg.lin_solver._mumps._dmumps',
                                        sources=['./optalg/lin_solver/_mumps/_dmumps.pyx'],
                                        libraries=libraries_mumps,
                                        include_dirs=['./lib/ipopt/include/coin-or'],
                                        library_dirs=['./lib/ipopt/lib'],
                                        extra_link_args=extra_link_args)],
                                        language_level=3)

    # IPOPT
    ext_modules += cythonize([Extension(name='optalg.opt_solver._ipopt.cipopt',
                                        sources=['./optalg/opt_solver/_ipopt/cipopt.pyx'],
                                        libraries=libraries_ipopt,
                                        include_dirs=[np.get_include(),'./lib/ipopt/include'],
                                        library_dirs=['./lib/ipopt/lib'],
                                        extra_link_args=extra_link_args)],
                                        language_level=3)

# CLP
if os.environ.get('OPTALG_CLP') == 'true':
    ext_modules += cythonize([Extension(name='optalg.opt_solver._clp.cclp',
                                        sources=['./optalg/opt_solver/_clp/cclp.pyx'],
                                        libraries=['Clp'],
                                        include_dirs=[np.get_include(),'./lib/clp/include'],
                                        library_dirs=['./lib/clp/lib'],
                                        extra_link_args=extra_link_args)],
                                        language_level=3)

# CBC
if os.environ.get('OPTALG_CBC') == 'true':
    ext_modules += cythonize([Extension(name='optalg.opt_solver._cbc.ccbc',
                                        sources=['./optalg/opt_solver/_cbc/ccbc.pyx'],
                                        libraries=['CbcSolver'],
                                        include_dirs=[np.get_include(),'./lib/cbc/include'],
                                        library_dirs=['./lib/cbc/lib'],
                                        extra_link_args=extra_link_args)],
                                        language_level=3)

exec(open(os.path.join('optalg', 'version.py')).read())


# Custom distribution build commands
class bdist_wheel_compiled(bdist_wheel):
    """Small customizations to build compiled only wheel."""
    description = 'build compiled wheel distribution'


class bdist_egg_compiled(bdist_egg):
    """Small customizations to build compiled only egg."""
    description = 'build compiled egg distribution'


if len(sys.argv) > 1 and 'compiled' in sys.argv[1]:

    class build_py(build_py):
        """
        A custom build_py command to exclude source files from packaging and
        include compiled pyc files instead.
        """
        def byte_compile(self, files):
            for file in files:
                full_path = os.path.abspath(file)
                if file.endswith('.py'):
                    log.info("{}  compiling and unlinking".format(file))
                    py_compile.compile(file, cfile=file+'c')
                    os.unlink(file)
                elif file.endswith('pyx') or file.endswith('pxd'):
                    log.info("{}  unlinking".format(file))
                    os.unlink(file)

    extra_cmd_classes = {'bdist_wheel_compiled': bdist_wheel_compiled,
                         'bdist_egg_compiled': bdist_egg_compiled,
                         'build_py': build_py}

else:
    extra_cmd_classes = {'bdist_wheel_compiled': bdist_wheel_compiled,
                         'bdist_egg_compiled': bdist_egg_compiled}

setup(name='OPTALG',
      zip_safe=False,
      version=__version__,
      description='Optimization Algorithms and Wrappers',
      url='https://github.com/romcon/OPTALG',
      author='Adam Wigington, Fan Zhang, Swaroop Guggilam',
      author_email='awigington@epri.com',
      include_package_data=True,
      cmdclass=extra_cmd_classes,
      license='BSD 2-Clause License',
      packages=[
                'optalg',
                'optalg.lin_solver',
                'optalg.lin_solver._mumps',
                'optalg.opt_solver',
                'optalg.opt_solver._ipopt',
                'optalg.opt_solver._clp',
                'optalg.opt_solver._cbc'],
      install_requires=['cython>=0.20.1',
                        'numpy>=1.11.2',
                        'scipy>=0.18.1',
                        'nose'],
      package_data={
        'optalg.lin_solver._mumps' : ['libcoinmumps*', 'IpOptFSS*'],
                    'optalg.opt_solver._ipopt' : ['libipopt*', 'IpOpt-vc10*', 'IpOptFSS*'],
                    'optalg.opt_solver._clp' : ['libClp*'],
                    'optalg.opt_solver._cbc' : ['libCbc*']},
      classifiers=['Development Status :: 5 - Production/Stable',
                   'License :: OSI Approved :: BSD License',
                   'Programming Language :: Python :: 2.7',
                   'Programming Language :: Python :: 3.5',
                   'Programming Language :: Python :: 3.6',
                   'Programming Language :: Python :: 3.7'],
      ext_modules=ext_modules)
