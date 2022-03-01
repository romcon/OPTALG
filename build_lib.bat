IF "%OPTALG_IPOPT%" == "true" (
    IF NOT EXIST "lib\ipopt" (
	mkdir lib
        cd lib
        bitsadmin /transfer "JobName" https://www.coin-or.org/download/binary/Ipopt/Ipopt-3.11.1-win64-intel13.1.zip "%cd%\lib\ipopt.zip"
        7z x ipopt.zip
        for /d %%G in ("Ipopt*") do move "%%~G" ipopt
        cd ipopt
      	mkdir temp
        cd temp
        bitsadmin /transfer "JobName" https://www.coin-or.org/download/binary/Ipopt/Ipopt-3.11.0-Win32-Win64-dll.7z "%cd%\lib\ipopt\temp\foo.7z"
        7z x foo.7z
        copy lib\x64\ReleaseMKL\IpOptFSS.dll ..\lib
        copy lib\x64\ReleaseMKL\IpOptFSS.lib ..\lib
        copy lib\x64\ReleaseMKL\IpOpt-vc10.dll ..\lib
        copy lib\x64\ReleaseMKL\IpOpt-vc10.lib ..\lib
        cd ..
        copy lib\Ipopt-vc10.dll ..\..\optalg\opt_solver\_ipopt
        copy lib\IpoptFSS.dll ..\..\optalg\opt_solver\_ipopt
        copy lib\IpoptFSS.dll ..\..\optalg\lin_solver\_mumps
        cd ..\..\

        python setup.py setopt --command build -o compiler -s msvc
    )
)
IF "%OPTALG_KLU%" == "true" (
	IF NOT EXIST "lib\SuiteSparse" (
	mkdir lib
		cd lib
		git clone https://github.com/DrTimothyAldenDavis/SuiteSparse.git SuiteSparse
		copy cmakelist_suitesparse_entry\build_lib.bat SuiteSparse
		copy cmakelist_suitesparse_entry\clean.bat SuiteSparse
		copy cmakelist_suitesparse_entry\CMakeLists.txt SuiteSparse
		copy cmaklists_suitesparse_amd\CMakeLists.txt SuiteSparse\AMD
		copy cmaklists_suitesparse_btf\CMakeLists.txt SuiteSparse\BTF
		copy cmaklists_suitesparse_colamd\CMakeLists.txt SuiteSparse\COLAMD
		copy cmaklists_suitesparse_config\CMakeLists.txt SuiteSparse\SuiteSparse_config
		copy cmaklists_suitesparse_csparse\CMakeLists.txt SuiteSparse\CSparse
		copy cmaklists_suitesparse_klu\CMakeLists.txt SuiteSparse\KLU
		
		cd SuiteSparse
				
		CALL clean.bat
		CALL build_lib.bat
		
		copy KLU\Release\KLU.dll ..\..\..\optalg\lin_solver\_klu
		
		cd ..\..\..
		
		python setup.py setopt --command build -o compiler -s msvc

	)
)