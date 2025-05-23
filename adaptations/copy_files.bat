@echo off
if defined echo echo %echo%
setlocal

:: Helper script for Windows.
:: The files under adaptation can be referenced from the packages being adapted,
:: using symbolic or hard links.
:: You can use this script to create those links.


:: Replace by your path (no space !)
set OOREXX=y:\local\rexx\oorexx

goto :main


:help
    echo Options:
    echo -show: show the commands that would be executed, but don't execute them.
    echo -doit: really do the commands.
    echo -diff: list the source files which exists and are different from the target
    echo -diffview: list all the differences
    goto :eof


:copy_file
    setlocal
    set source_dir=%1
    set target_dir=%2
    set file=%3
    set execute=%4

    set source=%source_dir%\%file%
    set target=%target_dir%\%file%

    if not exist %target_dir% goto :eof
    call :check %source% mandatory
    if "%stop%" == "1" endlocal & set stop=%stop%& goto :eof

    fc %source% %target% >nul 2>&1
    if errorlevel 1 (
        rem source is different from target. A copy is needed.
        rem /-Y to be safe, ask confirmation if target exists.
        %execute% copy /-Y %source% %target%
    )
    endlocal
    goto :eof


:show_copy
    call :copy_file %1 %2 %3 echo
    goto :eof


:do_copy
    call :copy_file %1 %2 %3
    goto :eof


:diff_mini
    setlocal
    set source_dir=%1
    set target_dir=%2
    set file=%3
    set execute=%4

    set source=%source_dir%\%file%
    set target=%target_dir%\%file%

    if not exist %target_dir% goto :eof
    call :check %source% mandatory
    if "%stop%" == "1" endlocal & set stop=%stop%& goto :eof

    fc %source% %target% >nul 2>&1
        :: -1 : Your syntax is incorrect.
        ::  0 : Both files are identical.
        ::  1 : The files are different.
        ::  2 : At least one of the files can�t be found.
    if errorlevel 1 echo %target%
    endlocal
    goto :eof


:diff_view
    setlocal
    set source_dir=%1
    set target_dir=%2
    set file=%3
    set execute=%4

    set source=%source_dir%\%file%
    set target=%target_dir%\%file%

    if not exist %target_dir% goto :eof
    call :check %source% mandatory
    if "%stop%" == "1" endlocal & set stop=%stop%& goto :eof

    fc %source% %target% >nul 2>&1
    if errorlevel 1 (
        echo %target%
        fc %source% %target%
    )
    endlocal
    goto :eof


:actions
    setlocal
    set action=%1


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\branches\4.2
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\branches\4.2\trunk\api\platform\windows
    set target=%OOREXX%\official\main\branches\4.2\trunk\api\platform\windows
    call :%action% %source% %target% rexxapitypes.h
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\branches\4.2\trunk
    set target=%OOREXX%\official\main\branches\4.2\trunk
    call :%action% %source% %target% cl_infos.cpp
    call :%action% %source% %target% Makefile.am
    call :%action% %source% %target% makeorx_verbose.bat
    call :%action% %source% %target% makeorx.bat
    call :%action% %source% %target% orxdb.bat
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\branches\4.2\trunk\interpreter\platform\windows
    set target=%OOREXX%\official\main\branches\4.2\trunk\interpreter\platform\windows
    call :%action% %source% %target% PlatformDefinitions.h
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\branches\4.2\trunk\lib
    set target=%OOREXX%\official\main\branches\4.2\trunk\lib
    call :%action% %source% %target% orxwin32.mak
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\branches\4.2\trunk\platform\windows
    set target=%OOREXX%\official\main\branches\4.2\trunk\platform\windows
    call :%action% %source% %target% buildorx.bat
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\3.1.2
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\3.1.2\trunk
    set target=%OOREXX%\official\main\releases\3.1.2\trunk
    call :%action% %source% %target% Makefile.am
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\3.2.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\3.2.0\trunk
    set target=%OOREXX%\official\main\releases\3.2.0\trunk
    call :%action% %source% %target% Makefile.am
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\4.0.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.0.0\trunk
    set target=%OOREXX%\official\main\releases\4.0.0\trunk
    call :%action% %source% %target% Makefile.am
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\4.0.1
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.0.1\trunk
    set target=%OOREXX%\official\main\releases\4.0.1\trunk
    call :%action% %source% %target% Makefile.am
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\4.1.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.1.0\trunk
    set target=%OOREXX%\official\main\releases\4.1.0\trunk
    call :%action% %source% %target% Makefile.am
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\4.1.1
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.1.1\trunk
    set target=%OOREXX%\official\main\releases\4.1.1\trunk
    call :%action% %source% %target% Makefile.am
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\4.2.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk
    set target=%OOREXX%\official\main\releases\4.2.0\trunk
    call :%action% %source% %target% cl_infos.cpp
    call :%action% %source% %target% Makefile.am
    call :%action% %source% %target% makeorx_verbose.bat
    call :%action% %source% %target% makeorx.bat
    call :%action% %source% %target% orxdb.bat
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\api
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\api
    call :%action% %source% %target% oorexxapi.h
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\api\platform\windows
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\api\platform\windows
    call :%action% %source% %target% rexxapitypes.h
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\extensions\platform\windows\ole
    set target=%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\platform\windows\ole
    call :%action% $source %target% events.cpp
    call :%action% $source %target% orexxole.def
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\extensions\platform\windows\oodialog
    set target=%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\platform\windows\oodialog
    call :%action% $source %target% APICommon.hpp
    call :%action% $source %target% ooDialog.def
    call :%action% $source %target% oodPackageEntry.cpp
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\extensions\platform\windows\orxscrpt
    set target=%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\platform\windows\orxscrpt
    call :%action% $source %target% orxscrpt.def
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\unix
    set target=%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\unix
    call :%action% $source %target% rexxutil.cpp
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\windows
    set target=%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\windows
    call :%action% $source %target% rexxutil.def
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\interpreter\api
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\api
    call :%action% %source% %target% ThreadContextStubs.cpp
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\interpreter\platform\windows
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\platform\windows
    call :%action% %source% %target% PlatformDefinitions.h
    call :%action% %source% %target% SysInterpreterInstance.cpp
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\lib
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\lib
    call :%action% %source% %target% orxwin32.mak
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\platform\windows
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\platform\windows
    call :%action% %source% %target% buildorx.bat
    call :%action% %source% %target% rexxarm64.exe.manifest
    call :%action% %source% %target% rxregexp.def
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\test\branches\4.2.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\test\branches\4.2.0\trunk\external\API
    set target=%OOREXX%\official\test\branches\4.2.0\trunk\external\API
    call :%action% %source% %target% Makefile.windows
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\test\trunk
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\test\trunk\external\API
    set target=%OOREXX%\official\test\trunk\external\API
    call :%action% %source% %target% Makefile.windows
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    echo.
    if "%action%" == "show_copy" (
        echo Use the option -doit to really execute the actions.
    ) else (
        echo Done.
    )

    endlocal
    goto :eof


:check
    if not exist %1 (
        echo ***FATAL*** NOT FOUND: %1
        :: exit /b is not leaving the script, just leaving the current function :-(
        if "%2" == "mandatory" set stop=1
    )
    goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Main routine
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:main

:: Path to this script
set BUILDER_ADAPTATIONS="%~dp0"
set BUILDER_ADAPTATIONS=%BUILDER_ADAPTATIONS:&=^&%
set BUILDER_ADAPTATIONS=%BUILDER_ADAPTATIONS:"=%
:: Remove the last "\"
set BUILDER_ADAPTATIONS="%BUILDER_ADAPTATIONS:~0,-1%"
set BUILDER_ADAPTATIONS=%BUILDER_ADAPTATIONS:&=^&%
set BUILDER_ADAPTATIONS=%BUILDER_ADAPTATIONS:"=%

set stop=0
call :check %BUILDER_ADAPTATIONS% mandatory
if "%stop%" == "1" exit /B 1

if "%1" == "" (
    call :help
) else if "%1" == "-show" (
    call :actions show_copy
) else if "%1" == "-doit" (
    call :actions do_copy
) else if "%1" == "-diff" (
    call :actions diff_mini
) else if "%1" == "-diffview" (
    call :actions diff_view
) else (
    echo Unknown option: %1
    call :help
)


endlocal
exit /B 0
