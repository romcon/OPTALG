#! /bin/sh
set -e

# IPOPT and MUMPS
if [ ! -d "lib/ipopt" ] && [ "$OPTALG_IPOPT" = true ]; then
    mkdir -p lib
    cd lib
    if [ ! -f Ipopt-3.12.8.zip ]; then
      wget https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.8.zip
    fi
    unzip Ipopt-3.12.8.zip
    mv Ipopt-3.12.8 ipopt
    cd ipopt/ThirdParty/Mumps
    ./get.Mumps
    cd ../../
    ./configure FFLAGS='-fallow-argument-mismatch'  # needed to compile mumps with gcc 10
    make clean
    make uninstall
    make
    make install
    if [ "$(uname)" == "Darwin" ]; then
      install_name_tool -id "@rpath/libcoinmumps.1.dylib" lib/libcoinmumps.1.dylib
      install_name_tool -id "@rpath/libipopt.1.dylib" lib/libipopt.1.dylib
      install_name_tool -change "$PWD/lib/libcoinmumps.1.dylib" "@loader_path/../../lin_solver/_mumps/libcoinmumps.1.dylib" lib/libipopt.1.dylib
    fi
    cp lib/libipopt* ../../optalg/opt_solver/_ipopt
    cp lib/libcoinmumps* ../../optalg/lin_solver/_mumps
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
