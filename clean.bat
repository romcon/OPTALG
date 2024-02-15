echo "Cleaning all autoogenerated content (3rd party libraries and optalg)"
del /s /f %~dp0*.pyc
del /s /f %~dp0*.dll
del /s /f %~dp0*.lib
del /s /f %~dp0*.a
del /s /f %~dp0*.c
del /s /f %~dp0*.pyd
del /s /f %~dp0*AMD.txt
del /s /f %~dp0lib\build\*.zip
rmdir /s /q %~dp0build
rmdir /s /q %~dp0dist
rmdir /s /q %~dp0OPTALG.egg-info
:: rmdir /s /q %~dp0lib\ThirdParty-Mumps
rmdir /s /q %~dp0lib\ipopt
rmdir /s /q %~dp0lib\build 
rmdir /s /q %~dp0lib\SuiteSparse
del /s /f %~dp0lib\clp*
del /s /f %~dp0lib\cbc*
del /s /f %~dp0lib\Ipopt*
del /s /f %~dp0lib\Clp*
del /s /f %~dp0lib\Cbc*
del /s /f %~dp0lib\SuiteSparse*
