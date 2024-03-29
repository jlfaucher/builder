@echo off
if defined echo echo %echo%
setlocal

:: Replace by your path (no space !)
set BSF4OOREXX=y:\local\rexx\bsf4oorexx
set OOREXX=y:\local\rexx\oorexx

goto :main

:: Helper script for Windows.
:: The files under adaptation can be referenced from the packages being adapted,
:: using symbolic or hard links.
:: You can use this script to create those links.


:help
    echo Options:
    echo -show: show the commands that would be executed, but don't execute them.
    echo -doit: really do the commands.
    echo -diff: list the source files which exists and are different from the target
    echo -diffview: list all the differences
    goto :eof


:mklink
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
        if exist %target% %execute% del /F /Q %target%
        :: Symbolic links are not supported by SVN, better to create hard links
        %execute% mklink /H %target% %source%
    )
    endlocal
    goto :eof


:show_mklink
    call :mklink %1 %2 %3 echo
    goto :eof


:do_mklink
    call :mklink %1 %2 %3
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
    :: bsf4oorexx\trunk
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\bsf4oorexx\trunk\bsf4oorexx.dev\source_cc
    set target=%BSF4OOREXX%\svn\trunk\bsf4oorexx.dev\source_cc
    call :%action% %source% %target% Makefile-builder-windows
    call :%action% %source% %target% Makefile-builder-macosx
    call :%action% %source% %target% Makefile-builder-linux
    if "%stop%" == "1" goto :eof


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

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\api\platform\windows
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\api\platform\windows
    call :%action% %source% %target% rexxapitypes.h
    if "%stop%" == "1" goto :eof

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

    :: set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\windows
    :: set target%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\windows
    :: call :%action% $source %target% rexxutil.cpp
    :: if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\interpreter\api
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\api
    call :%action% %source% %target% ThreadContextStubs.cpp
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\interpreter\platform\windows
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\platform\windows
    call :%action% %source% %target% PlatformDefinitions.h
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\lib
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\lib
    call :%action% %source% %target% orxwin32.mak
    if "%stop%" == "1" goto :eof

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\releases\4.2.0\trunk\platform\windows
    set target=%OOREXX%\official\main\releases\4.2.0\trunk\platform\windows
    call :%action% %source% %target% buildorx.bat
    if "%stop%" == "1" goto :eof


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\trunk
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set source=%BUILDER_ADAPTATIONS%\oorexx\official\main\trunk
    set target=%OOREXX%\official\main\trunk
    call :%action% %source% %target% CMakeLists.txt
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
    if "%action%" == "show_mklink" (
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
    call :actions show_mklink
) else if "%1" == "-doit" (
    call :actions do_mklink
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
