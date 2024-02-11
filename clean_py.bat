@REM Clean only python generated content only
del /s /f %~dp0*.pyc
del /s /f %~dp0*.a
del /s /f %~dp0*.c
del /s /f %~dp0*.pyd
FOR /d /r . %%d IN (__pycache__) DO @IF EXIST "%%d" rd /s /q "%%d"


rmdir /s /q %~dp0build
rmdir /s /q %~dp0dist
rmdir /s /q %~dp0OPTALG.egg-info