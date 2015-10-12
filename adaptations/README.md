Adaptation
==========

This directory contains adaptations of

- BSF4OORexx
- GCI
- ooRexx

to let build with the builder and bring (sometimes) new functionalities.

GCI New functionalities
-----------------------

Added support for 64-bit.

Added support for type aliases.
Each alias defines a type and a size, no size accepted after these aliases.

- long (signed long)
- llong (signed long long)
- pointer (opaque, no dereferencement, unlike GCI_indirect)
- size_t (unsigned)
- ssize_t (signed)
- ulong (unsigned long)
- ullong (unsigned long long)

The file gci-try.rexx has been updated to support MacOs.

The demo with statvfs in gci-try.rexx has been documented to bring all the
details about the types used in the structure. This function is a good
illustration of the need of type aliases in GCI.

Helper script for Linux/MacOs
-----------------------------
The files under adaptation can be referenced from the packages being adapted,
using symbolic links. You can use the following script to create those symbolic links.

    # Replace by your path
    BUILDER=/local/builder
    GCI=/local/rexx/GCI
    BSF4OOREXX=/local/rexx/bsf4oorexx
    OOREXX=/local/rexx/oorexx

    source=$BUILDER/adaptations/GCI/gci-source.1.1/
    target=$GCI/gci-source.1.1/
    ln -f -s $source/gci-try.rexx                  $target/gci-try.rexx
    ln -f -s $source/gci.h                         $target/gci.h
    ln -f -s $source/gci_convert.linux.86_64       $target/gci_convert.linux.86_64
    ln -f -s $source/gci_convert.macX.all          $target/gci_convert.macX.all
    ln -f -s $source/gci_convert.win32.vc          $target/gci_convert.win32.vc
    ln -f -s $source/gci_oslink.macX               $target/gci_oslink.macX
    ln -f -s $source/gci_rexxbridge.c              $target/gci_rexxbridge.c
    ln -f -s $source/gci_tree.c                    $target/gci_tree.c
    ln -f -s $source/gci_win32.def                 $target/gci_win32.def
    ln -f -s $source/GNUmakefile-builder           $target/GNUmakefile-builder
    ln -f -s $source/Makefile-builder.vc           $target/Makefile-builder.vc


    source=$BUILDER/adaptations/bsf4oorexx/trunk/bsf4oorexx.dev/source_cc/
    target=$BSF4OOREXX/svn/trunk/bsf4oorexx.dev/source_cc/
    ln -f -s $source/Makefile-builder              $target/Makefile-builder
    ln -f -s $source/apple-Makefile-builder.mak    $target/apple-Makefile-builder.mak
    ln -f -s $source/lin_bsf4rexx-builder.mak      $target/lin_bsf4/rexx-builder.mak


    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/api/platform/windows/
    target=$OOREXX/official/main/releases/4.2.0/trunk/api/platform/windows/
    ln -f -s $source/rexxapitypes.h                $target/rexxapitypes.h

    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/
    target=$OOREXX/official/main/releases/4.2.0/trunk/
    ln -f -s $source/cl_infos.cpp                  $target/cl_infos.cpp
    ln -f -s $source/makeorx_verbose.bat           $target/makeorx_verbose.bat
    ln -f -s $source/makeorx.bat                   $target/makeorx.bat
    ln -f -s $source/orxdb.bat                     $target/orxdb.bat

    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/interpreter/platform/windows/
    target=$OOREXX/official/main/releases/4.2.0/trunk/interpreter/platform/windows/
    ln -f -s $source/PlatformDefinitions.h         $target/PlatformDefinitions.h

    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/lib/
    target=$OOREXX/official/main/releases/4.2.0/trunk/lib/
    ln -f -s $source/orxwin32.mak                  $target/orxwin32.mak

    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/platform/windows/
    target=$OOREXX/official/main/releases/4.2.0/trunk/platform/windows/
    ln -f -s $source/buildorx.bat                  $target/buildorx.bat

    source=$BUILDER/adaptations/oorexx/official/test/branches/4.2.0/trunk/external/API/
    target=$OOREXX/official/test/branches/4.2.0/trunk/external/API/
    ln -f -s $source/Makefile.windows              $target/Makefile.windows

    source=$BUILDER/adaptations/oorexx/official/test/trunk/external/API/
    target=$OOREXX/official/test/trunk/external/API/
    ln -f -s $source/Makefile.windows              $target/Makefile.windows


Helper script for Windows
-------------------------
The files under adaptation can be referenced from the packages being adapted,
using symbolic links. You can use the following script to create those symbolic links.

    :: Replace by your path
    set BUILDER=c:\jlf\local\builder
    set GCI=c:\jlf\local\rexx\GCI
    set BSF4OOREXX=c:\jlf\local\rexx\bsf4oorexx
    set OOREXX=c:\jlf\local\rexx\oorexx

    set target=%BUILDER%\adaptations\GCI\gci-source.1.1\
    set source=%GCI%\gci-source.1.1\
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


    set target=%BUILDER%\adaptations\bsf4oorexx\trunk\bsf4oorexx.dev\source_cc\
    set source=%BSF4OOREXX%\svn\trunk\bsf4oorexx.dev\source_cc\
    call :mklink %source%\Makefile-builder              %target%\Makefile-builder
    call :mklink %source%\apple-Makefile-builder.mak    %target%\apple-Makefile-builder.mak
    call :mklink %source%\lin_bsf4rexx-builder.mak      %target%\lin_bsf4\rexx-builder.mak


    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\api\platform\windows\
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\api\platform\windows\
    call :mklink %source%\rexxapitypes.h                %target%\rexxapitypes.h

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\
    call :mklink %source%\cl_infos.cpp                          %target%\cl_infos.cpp
    call :mklink %source%\makeorx_verbose.bat           %target%\makeorx_verbose.bat
    call :mklink %source%\makeorx.bat                   %target%\makeorx.bat
    call :mklink %source%\orxdb.bat                     %target%\orxdb.bat

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\interpreter\platform\windows\
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\interpreter\platform\windows\
    call :mklink %source%\PlatformDefinitions.h         %target%\PlatformDefinitions.h

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\lib\
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\lib\
    call :mklink %source%\orxwin32.mak                  %target%\orxwin32.mak

    set target=%BUILDER%\adaptations\oorexx\official\main\releases\4.2.0\trunk\platform\windows\
    set source=%OOREXX%\official\main\releases\4.2.0\trunk\platform\windows\
    call :mklink %source%\buildorx.bat                  %target%\buildorx.bat

    set target=%BUILDER%\adaptations\oorexx\official\test\branches\4.2.0\trunk\external\API\
    set source=%OOREXX%\official\test\branches\4.2.0\trunk\external\API\
    call :mklink %source%\Makefile.windows              %target%\Makefile.windows

    set target=%BUILDER%\adaptations\oorexx\official\test\trunk\external\API\
    set source=%OOREXX%\official\test\trunk\external\API\
    call :mklink %source%\Makefile.windows              %target%\Makefile.windows

    goto :eof

    :mklink
    set link=%1
    set target=%2
    del /F /Q %link%
    mklink %link% %target%
