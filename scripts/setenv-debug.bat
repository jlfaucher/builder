@echo off
if defined echo echo %echo%

:: MUST use DEBUG=Y for Regina, otherwise no symbols loaded
:: Don't define _DEBUG, to be aligned with setenv-debug
set CFLAGS=/DDEBUG=Y %CFLAGS%
set CPPFLAGS=/DDEBUG=Y %CPPFLAGS%
set CXXFLAGS=/DDEBUG=Y %CXXFLAGS%

:: Old build system (makeorx DEBUG)
set rel=0
set dbg=1

:: New build system (cmake)
set CMAKE_BUILD_TYPE=Debug

:: Activate code to trace the semaphores
:: Pfff... CPPFLAGS ignored by cmake ???
set CPPFLAGS=/DCONCURRENCY_DEBUG %CPPFLAGS%
set CXXFLAGS=/DCONCURRENCY_DEBUG %CXXFLAGS%

exit /b 0
