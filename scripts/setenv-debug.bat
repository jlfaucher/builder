@echo off
if defined echo echo %echo%

:: Old build system (makeorx DEBUG)
set rel=0
set dbg=1

:: New build system (cmake)
set CMAKE_BUILD_TYPE=Debug

exit /b 0
