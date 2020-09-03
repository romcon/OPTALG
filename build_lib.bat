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
IF "%OPTALG_CBC%" == "true" ( 
    IF NOT EXIST "lib/cbc" (
    	mkdir lib
    	cd lib
    	bitsadmin /transfer "JobName" https://bintray.com/coin-or/download/download_file?file_path=Cbc-refactor-win64-msvc16-mdd.zip "%cd%\lib\CBC.zip"
    	mkdir cbc
	7z x CBC.zip -o./cbc 
	ren cbc\lib\Cbc.dll.lib CbcSolver.lib
	move "%cd%\lib\cbc\include\coin-or" "%cd%\lib\cbc\include\coin"
        copy cbc\lib\*.lib ..\optalg\opt_solver\_cbc
	copy cbc\bin\*.dll ..\optalg\opt_solver\_cbc
  	cd ..\
	python setup.py setopt --command build -o compiler -s msvc
     )
)
