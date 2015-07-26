@echo off
if defined echo echo %echo%

:: Old build system (makeorx NODEBUG) (yes... same than release)
set rel=1
set dbg=1

:: New build system (cmake)
set CMAKE_BUILD_TYPE=RelWithDebInfo

exit /b 0
