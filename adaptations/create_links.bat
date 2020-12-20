@echo off
if defined echo echo %echo%
setlocal
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
    set source=%1
    set target=%2
    set execute=%3
    if exist %source% %execute% del /F /Q %source%
    :: Symbolic links are not supported by SVN, better to create hard links
    %execute% mklink /H %source% %target%
    endlocal
    goto :eof


:show_mklink
    call :mklink %1 %2 echo
    goto :eof


:do_mklink
    call :mklink %1 %2
    goto :eof


:diff_mini
    setlocal
    set source=%1
    set target=%2
    if not exist %source% goto :eof
    fc %source% %target% >nul
    :: -1 : Your syntax is incorrect.
    ::  0 : Both files are identical.
    ::  1 : The files are different.
    ::  2 : At least one of the files can�t be found.
    if errorlevel 1 echo %source%
    endlocal
    goto :eof


:diff_view
    setlocal
    set source=%1
    set target=%2
    if not exist %source% goto :eof
    fc %source% %target% >nul
    if errorlevel 1 (
        echo %source%
        fc %source% %target%
    )
    endlocal
    goto :eof


:actions
    setlocal
    set action=%1

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
    call :%action% %source%\gci-try.rexx                  %target%\gci-try.rexx
    call :%action% %source%\gci.h                         %target%\gci.h
    call :%action% %source%\gci_convert.linux.86_64       %target%\gci_convert.linux.86_64
    call :%action% %source%\gci_convert.macX.all          %target%\gci_convert.macX.all
    call :%action% %source%\gci_convert.win32.vc          %target%\gci_convert.win32.vc
    call :%action% %source%\gci_oslink.macX               %target%\gci_oslink.macX
    call :%action% %source%\gci_rexxbridge.c              %target%\gci_rexxbridge.c
    call :%action% %source%\gci_tree.c                    %target%\gci_tree.c
    call :%action% %source%\gci_win32.def                 %target%\gci_win32.def
    call :%action% %source%\GNUmakefile-builder           %target%\GNUmakefile-builder
    call :%action% %source%\Makefile-builder.vc           %target%\Makefile-builder.vc


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: bsf4oorexx\trunk
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set target=%BUILDER%\adaptations\bsf4oorexx\trunk\bsf4oorexx.dev\source_cc
    set source=%BSF4OOREXX%\svn\trunk\bsf4oorexx.dev\source_cc
    call :%action% %source%\Makefile-builder-windows      %target%\Makefile-builder-windows
    call :%action% %source%\Makefile-builder-macosx       %target%\Makefile-builder-macosx
    call :%action% %source%\Makefile-builder-linux        %target%\Makefile-builder-linux


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\branches\4.2
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\api\platform\windows
    set source=%OOREXX%\official\main\branches\4.2\trunk\api\platform\windows
    call :%action% %source%\rexxapitypes.h                %target%\rexxapitypes.h

    set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk
    set source=%OOREXX%\official\main\branches\4.2\trunk
    call :%action% %source%\cl_infos.cpp                  %target%\cl_infos.cpp
    call :%action% %source%\Makefile.am                   %target%\Makefile.am
    call :%action% %source%\makeorx_verbose.bat           %target%\makeorx_verbose.bat
    call :%action% %source%\makeorx.bat                   %target%\makeorx.bat
    call :%action% %source%\orxdb.bat                     %target%\orxdb.bat

    set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\interpreter\platform\windows
    set source=%OOREXX%\official\main\branches\4.2\trunk\interpreter\platform\windows
    call :%action% %source%\PlatformDefinitions.h         %target%\PlatformDefinitions.h

    set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\lib
    set source=%OOREXX%\official\main\branches\4.2\trunk\lib
    call :%action% %source%\orxwin32.mak                  %target%\orxwin32.mak

    set target=%BUILDER%\adaptations\oorexx\official\main\branches\4.2\trunk\platform\windows
    set source=%OOREXX%\official\main\branches\4.2\trunk\platform\windows
    call :%action% %source%\buildorx.bat                  %target%\buildorx.bat


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\releases\4.2.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\api\platform\windows
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\api\platform\windows
    call :%action% %source%\rexxapitypes.h                %target%\rexxapitypes.h

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk
    set source=%OOREXX%\official\main\releases\4.2.0\trunk
    call :%action% %source%\cl_infos.cpp                  %target%\cl_infos.cpp
    call :%action% %source%\Makefile.am                   %target%\Makefile.am
    call :%action% %source%\makeorx_verbose.bat           %target%\makeorx_verbose.bat
    call :%action% %source%\makeorx.bat                   %target%\makeorx.bat
    call :%action% %source%\orxdb.bat                     %target%\orxdb.bat

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\api
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\api
    call :%action% %source%\oorexxapi.h                   %target%\oorexxapi.h

    :: set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\windows
    :: set source%$OOREXX%\official\main\releases\4.2.0\trunk\extensions\rexxutil\platform\windows
    :: call :%action% $source\rexxutil.cpp                    %target%\rexxutil.cpp

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\interpreter\api
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\api
    call :%action% %source%\ThreadContextStubs.cpp        %target%\ThreadContextStubs.cpp

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\interpreter\platform\windows
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\platform\windows
    call :%action% %source%\PlatformDefinitions.h         %target%\PlatformDefinitions.h

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\lib
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\lib
    call :%action% %source%\orxwin32.mak                  %target%\orxwin32.mak

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\platform\windows
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\platform\windows
    call :%action% %source%\buildorx.bat                  %target%\buildorx.bat


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\main\trunk
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set target=%BUILDER%\adaptations\oorexx\official\main\trunk
    set source=%OOREXX%\official\main\trunk
    call :%action% %source%\CMakeLists.txt                %target%\CMakeLists.txt


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\test\branches\4.2.0
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set target=%BUILDER%\adaptations\oorexx\official\test\branches\4.2.0\trunk\external\API
    set source=%OOREXX%\official\test\branches\4.2.0\trunk\external\API
    call :%action% %source%\Makefile.windows              %target%\Makefile.windows


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    :: oorexx\official\test\trunk
    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    set target=%BUILDER%\adaptations\oorexx\official\test\trunk\external\API
    set source=%OOREXX%\official\test\trunk\external\API
    call :%action% %source%\Makefile.windows              %target%\Makefile.windows


    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    echo.
    if "%action%" == "show_mklink" (
        echo Use the option -doit to really execute the actions.
    ) else (
        echo Done.
    )

    endlocal
    goto :eof


:main
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
