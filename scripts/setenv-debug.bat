@echo off
if defined echo echo %echo%

:: MUST use DEBUG=Y for Regina, otherwise no symbols loaded
set CFLAGS=/D_DEBUG /DDEBUG=Y %CFLAGS%
set CPPFLAGS=/D_DEBUG /DDEBUG=Y %CPPFLAGS%
set CXXFLAGS=/D_DEBUG /DDEBUG=Y %CXXFLAGS%

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
