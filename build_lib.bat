IF "%OPTALG_IPOPT%" == "true" (
    IF NOT EXIST "lib\build" (
	mkdir lib
        cd lib

		bitsadmin /transfer "JobName" /priority FOREGROUND https://github.com/coin-or/Ipopt/releases/download/releases/3.14.14/Ipopt-3.14.14-win64-msvs2019-md.zip "%cd%\lib\ipopt.zip"
		7z x ipopt.zip

		for /d %%G in ("Ipopt*") do ren "%%~G" build
        cd build\bin

		@REM Copy DLLs to solver folders
		copy *.dll ..\..\..\optalg\opt_solver\_ipopt
		copy *.dll ..\..\..\optalg\lin_solver\_mumps

        cd ..\..\..\

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
		
		copy build\KLU\Release\KLU.dll .
		copy build\KLU\Release\KLU.lib .

		copy CCOLAMD\Doc\License.txt ..\..\optalg\lin_solver\_klu\License_CCOLAMD.txt
		copy AMD\Doc\License.txt ..\..\optalg\lin_solver\_klu\License_AMD.txt
		copy KLU.dll ..\..\optalg\lin_solver\_klu
		copy KLU.lib ..\..\optalg\lin_solver\_klu

		cd ..\..
		
		python setup.py setopt --command build -o compiler -s msvc

	)
)