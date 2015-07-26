@echo off
if defined echo echo %echo%

:: Old build system (makeorx NODEBUG)
set rel=1
set dbg=0

:: New build system (cmake)
set CMAKE_BUILD_TYPE=Release

exit /b 0
