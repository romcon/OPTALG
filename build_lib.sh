#! /bin/sh
set -e

# Note on Mac OSX if you have trouble with lapack and openblas, however the xcode provided Accelerate framework seems to work
# For example with homebrew (on M1/M2 chips) installed openlapack and openblas
# export LDFLAGS="-L/opt/homebrew/opt/lapack/lib -L/opt/homebrew/opt/openblas/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/lapack/include -I/opt/homebrew/opt/openblas/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/lapack/lib/pkgconfig /opt/homebrew/opt/openblas/lib/pkgconfig"

# IPOPT and MUMPS
if [ ! -d "lib/ipopt" ] && [ "$OPTALG_IPOPT" = true ]; then
    mkdir -p lib
    cd lib
    # Shared build path
    mkdir -p build
    BUILD_PATH=$PWD/build

    # Get and install MUMPS
    if [ ! -d "ThirdParty-Mumps" ]; then
      git clone https://github.com/coin-or-tools/ThirdParty-Mumps.git
    fi
    cd ThirdParty-Mumps
    ./get.Mumps
    ./configure --prefix=$BUILD_PATH
    make clean
    make uninstall
    make
    make install
    cp $BUILD_PATH/lib/libcoinmumps* ../../optalg/lin_solver/_mumps
    if [ "$(uname)" == "Darwin" ]; then
      install_name_tool -id "@rpath/libcoinmumps.3.dylib" ../../optalg/lin_solver/_mumps/libcoinmumps.3.dylib
    fi
    cd ..

    # Get and Install IPOPT
    if [ ! -f 3.14.14.zip ]; then
      wget https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.14.zip
    fi
    unzip 3.14.14.zip
    mv Ipopt-releases-3.14.14 ipopt

    cd ipopt
    ./configure --prefix=$BUILD_PATH --disable-java --with-mumps --with-mumps-cflags="-I$BUILD_PATH/include/coin-or/mumps" --with-mumps-lflags="-L$BUILD_PATH/lib -lcoinmumps"
    make clean
    make uninstall
    make
    make install
    cp $BUILD_PATH/lib/libipopt* ../../optalg/opt_solver/_ipopt
    if [ "$(uname)" == "Darwin" ]; then
      install_name_tool -id "@rpath/libipopt.3.dylib" ../../optalg/opt_solver/_ipopt/libipopt.3.dylib
      install_name_tool -change "@rpath/libcoinmumps.3.dylib" "@loader_path/../../lin_solver/_mumps/libcoinmumps.3.dylib" ../../optalg/opt_solver/_ipopt/libipopt.3.dylib
    fi
    cd ../../
fi

# CLP
if [ ! -d "lib/clp" ] && [ "$OPTALG_CLP" = true ]; then
    mkdir -p lib
    cd lib
    if [ ! -f Clp-1.17.6.zip ]; then
      wget https://www.coin-or.org/download/source/Clp/Clp-1.17.6.zip
    fi
    unzip -u Clp-1.17.6.zip
    mv Clp-1.17.6 clp
    cd clp
    ./configure --prefix=$PWD
    make clean
    make uninstall
    make
    make install
    if [ "$(uname)" == "Darwin" ]; then
      install_name_tool -id "@rpath/libClp.1.dylib" lib/libClp.1.dylib
    fi
    cp lib/libClp* ../../optalg/opt_solver/_clp
    cd ../../
fi

# CBC
if [ ! -d "lib/cbc" ] && [ "$OPTALG_CBC" = true ]; then
    mkdir -p lib
    cd lib
    if [ ! -f Cbc-2.10.5.zip ]; then
      wget https://www.coin-or.org/download/source/Cbc/Cbc-2.10.5.zip
    fi
    unzip Cbc-2.10.5.zip
    mv Cbc-2.10.5 cbc
    cd cbc
    ./configure --prefix=$PWD
    make clean
    make uninstall
    make
    make install
    if [ "$(uname)" == "Darwin" ]; then
      # TBD: Why has the Cbc major version number changed to 3 in the dylib file names.
      install_name_tool -id "@rpath/libCbc.3.dylib" lib/libCbc.3.dylib
    fi
    cp lib/libCbc* ../../optalg/opt_solver/_cbc
    cd ../../
fi

# KLU (uses cmake instead of autotools as the other packages do)
if [ ! -d "lib/SuiteSparse" ] && [ "$OPTALG_KLU" = true ]; then
    mkdir -p lib
    cd lib
		git clone https://github.com/DrTimothyAldenDavis/SuiteSparse.git SuiteSparse
		cp -p cmakelist_suitesparse_entry/build_lib.sh SuiteSparse
		cp -p cmakelist_suitesparse_entry/clean.sh SuiteSparse
		cp cmakelist_suitesparse_entry/CMakeLists.txt SuiteSparse
		cp cmaklists_suitesparse_amd/CMakeLists.txt SuiteSparse/AMD
		cp cmaklists_suitesparse_btf/CMakeLists.txt SuiteSparse/BTF
		cp cmaklists_suitesparse_colamd/CMakeLists.txt SuiteSparse/COLAMD
		cp cmaklists_suitesparse_config/CMakeLists.txt SuiteSparse/SuiteSparse_config
		cp cmaklists_suitesparse_csparse/CMakeLists.txt SuiteSparse/CSparse
		cp cmaklists_suitesparse_klu/CMakeLists.txt SuiteSparse/KLU
		
    cd SuiteSparse

    ./clean.sh
    ./build_lib.sh

    cp ./build/KLU/libKLU.* .
    cp ./build/KLU/libKLU.* ../../optalg/lin_solver/_klu
    cp ./CCOLAMD/Doc/License.txt ../../optalg/lin_solver/_klu/License_CCOLAMD.txt
    cp ./AMD/Doc/License.txt ../../optalg/lin_solver/_klu/License_AMD.txt

    cd ../../
    
fi
