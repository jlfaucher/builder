@echo off
if defined echo echo %echo%

set builder_bitness=64

:: See setenv-cl.bat for the compiler options in function of %builder_system_arch%

exit /b 0
