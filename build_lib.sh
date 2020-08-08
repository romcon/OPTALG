#! /bin/sh -v

# IPOPT and MUMPS
if [ ! -d "lib/ipopt" ] && [ "$OPTALG_IPOPT" = true ]; then
    mkdir -p lib
    cd lib
    wget https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.8.zip
    unzip Ipopt-3.12.8.zip
    mv Ipopt-3.12.8 ipopt
    cd ipopt/ThirdParty/Mumps
    ./get.Mumps
    cd ../../
    ./configure
    make clean
    make uninstall
    make
    make install
    if [ "$(uname)" == "Darwin" ]; then
      install_name_tool -id "@rpath/libcoinmumps.1.dylib" lib/libcoinmumps.1.dylib
      install_name_tool -id "@rpath/libipopt.1.dylib" lib/libipopt.1.dylib
      install_name_tool -change "$PWD/lib/libcoinmumps.1.dylib" "@loader_path/../../lin_solver/_mumps/libcoinmumps.1.dylib" lib/libipopt.1.dylib
#      install_name_tool -change "$PWD/lib/libcoinmumps.1.dylib" "@loader_path/../../lin_solver/_mumps/libcoinmumps.1.dylib" lib/_dmumps.cpython-37m-darwin.so

    fi
    cp lib/libipopt* ../../optalg/opt_solver/_ipopt
    cp lib/libcoinmumps* ../../optalg/lin_solver/_mumps
    cd ../../
fi

# if [ ! -d "lib/ipopt" ] && [ "$OPTALG_IPOPT" = true ]; then
#     # Prepare ipopt as destination directory
#     mkdir -p lib
#     cd lib
#     wget https://www.coin-or.org/download/source/Ipopt/Ipopt-3.13.2.zip
#     unzip -u Ipopt-3.13.2.zip
#     mv Ipopt-releases-3.13.2 ipopt
#     DEST_DIR=$PWD/ipopt
#     echo $DEST_DIR
#     cd ..
#     
#     # Assume ThirdParty-Mumps is in ../
#     cd ../
#     # Instructions at: https://coin-or.github.io/Ipopt/INSTALL.html
# #    git clone https://github.com/coin-or-tools/ThirdParty-Mumps.git
#     cd ThirdParty-Mumps
#     ./get.Mumps
#     ./configure --prefix=$DEST_DIR
#     make clean
#     make uninstall
#     make
#     make install
#     cd ../OPTALG/
#     
#     cd lib/ipopt
#     ./configure --prefix=$DEST_DIR
#     make clean
#     make uninstall
#     make
#     make install
#     cp ../../../ThirdParty-Mumps/lib/lib* ./lib
#     cp lib/libipopt* ../../optalg/opt_solver/_ipopt
#     cp lib/libcoinmumps* ../../optalg/lin_solver/_mumps
#     
#     if [ "$(uname)" == "Darwin" ]; then
#       install_name_tool -id "@rpath/libcoinmumps.2.dylib" lib/libcoinmumps.2.dylib
#       install_name_tool -id "@rpath/libipopt.3.dylib" lib/libipopt.3.dylib
#       install_name_tool -change "$PWD/lib/libcoinmumps.2.dylib" "@loader_path/../../lin_solver/_mumps/libcoinmumps.2.dylib" lib/libipopt.3.dylib
#     fi
#     
#     cd ../../
# fi

# CLP
if [ ! -d "lib/clp" ] && [ "$OPTALG_CLP" = true ]; then
    mkdir -p lib
    cd lib
    wget https://www.coin-or.org/download/source/Clp/Clp-1.17.6.zip 
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
    wget https://www.coin-or.org/download/source/Cbc/Cbc-2.10.5.zip
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
