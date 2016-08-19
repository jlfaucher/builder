@echo off
if defined echo echo %echo%
setlocal

:: Helper script for Windows.
:: The files under adaptation can be referenced from the packages being adapted,
:: using symbolic links. You can use this script to create those symbolic links.

:: By default, just echo the commands.
:: If you pass the parameter "doit" then really do the commands.
set doit=echo
if "%1" == "-doit" set doit=

:: Replace by your path (no space !)
set BUILDER=c:\jlf\local\builder
set GCI=c:\jlf\local\rexx\GCI
set BSF4OOREXX=c:\jlf\local\rexx\bsf4oorexx
set OOREXX=c:\jlf\local\rexx\oorexx

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::GCI\gci-sources.1.1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\GCI\gci-source.1.1
set source=%GCI%\gci-source.1.1
call :mklink %source%\gci-try.rexx                  %target%\gci-try.rexx
call :mklink %source%\gci.h                         %target%\gci.h
call :mklink %source%\gci_convert.linux.86_64       %target%\gci_convert.linux.86_64
call :mklink %source%\gci_convert.macX.all          %target%\gci_convert.macX.all
call :mklink %source%\gci_convert.win32.vc          %target%\gci_convert.win32.vc
call :mklink %source%\gci_oslink.macX               %target%\gci_oslink.macX
call :mklink %source%\gci_rexxbridge.c              %target%\gci_rexxbridge.c
call :mklink %source%\gci_tree.c                    %target%\gci_tree.c
call :mklink %source%\gci_win32.def                 %target%\gci_win32.def
call :mklink %source%\GNUmakefile-builder           %target%\GNUmakefile-builder
call :mklink %source%\Makefile-builder.vc           %target%\Makefile-builder.vc


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: bsf4oorexx\trunk
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\bsf4oorexx\trunk\bsf4oorexx.dev\source_cc
set source=%BSF4OOREXX%\svn\trunk\bsf4oorexx.dev\source_cc
call :mklink %source%\Makefile-builder              %target%\Makefile-builder
call :mklink %source%\apple-Makefile-builder.mak    %target%\apple-Makefile-builder.mak
call :mklink %source%\lin_bsf4rexx-builder.mak      %target%\lin_bsf4rexx-builder.mak


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: oorexx\official\main\branches\4.2
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\api\platform\windows
set source=%OOREXX%\official\main\branches\4.2\trunk\api\platform\windows
call :mklink %source%\rexxapitypes.h                %target%\rexxapitypes.h

set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk
set source=%OOREXX%\official\main\branches\4.2\trunk
call :mklink %source%\cl_infos.cpp                  %target%\cl_infos.cpp
call :mklink %source%\Makefile.am                   %target%\Makefile.am
call :mklink %source%\makeorx_verbose.bat           %target%\makeorx_verbose.bat
call :mklink %source%\makeorx.bat                   %target%\makeorx.bat
call :mklink %source%\orxdb.bat                     %target%\orxdb.bat

set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\interpreter\platform\windows
set source=%OOREXX%\official\main\branches\4.2\trunk\interpreter\platform\windows
call :mklink %source%\PlatformDefinitions.h         %target%\PlatformDefinitions.h

set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\lib
set source=%OOREXX%\official\main\branches\4.2\trunk\lib
call :mklink %source%\orxwin32.mak                  %target%\orxwin32.mak

set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\platform\windows
set source=%OOREXX%\official\main\branches\4.2\trunk\platform\windows
call :mklink %source%\buildorx.bat                  %target%\buildorx.bat


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: oorexx\official\main\releases\4.2.0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\api\platform\windows
set source=%OOREXX%\official\main\releases\4.2.0\trunk\api\platform\windows
call :mklink %source%\rexxapitypes.h                %target%\rexxapitypes.h

set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk
set source=%OOREXX%\official\main\releases\4.2.0\trunk
call :mklink %source%\cl_infos.cpp                  %target%\cl_infos.cpp
call :mklink %source%\Makefile.am                   %target%\Makefile.am
call :mklink %source%\makeorx_verbose.bat           %target%\makeorx_verbose.bat
call :mklink %source%\makeorx.bat                   %target%\makeorx.bat
call :mklink %source%\orxdb.bat                     %target%\orxdb.bat

set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\interpreter\platform\windows
set source=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\platform\windows
call :mklink %source%\PlatformDefinitions.h         %target%\PlatformDefinitions.h

set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\lib
set source=%OOREXX%\official\main\releases\4.2.0\trunk\lib
call :mklink %source%\orxwin32.mak                  %target%\orxwin32.mak

set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\platform\windows
set source=%OOREXX%\official\main\releases\4.2.0\trunk\platform\windows
call :mklink %source%\buildorx.bat                  %target%\buildorx.bat


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: oorexx\official\main\trunk
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\oorexx\official\main\trunk
set source=%OOREXX%\official\main\trunk
call :mklink %source%\CMakeLists.txt                %target%\CMakeLists.txt


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: oorexx\official\test\branches\4.2.0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\oorexx\official\test\branches\4.2.0\trunk\external\API
set source=%OOREXX%\official\test\branches\4.2.0\trunk\external\API
call :mklink %source%\Makefile.windows              %target%\Makefile.windows


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: oorexx\official\test\trunk
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set target=%BUILDER%\adaptations\oorexx\official\test\trunk\external\API
set source=%OOREXX%\official\test\trunk\external\API
call :mklink %source%\Makefile.windows              %target%\Makefile.windows


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo.
if "%doit%" == "echo" (
    echo Use the option -doit to really execute the actions
) else (
    echo Done.
)

endlocal
goto :eof

:mklink
setlocal
set link=%1
set target=%2
if exist %link% %doit% del /F /Q %link%
%doit% mklink /H %link% %target%
endlocal
