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

Helper script
-------------
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
    ln -f -s $source/gci_tree.c                    $target/gci_tree.c
    ln -f -s $source/gci_win32.def                 $target/gci_win32.def
    ln -f -s $source/GNUmakefile-builder           $target/GNUmakefile-builder
    ln -f -s $source/Makefile-builder.vc           $target/Makefile-builder.vc


    source=$BUILDER/adaptations/bsf4oorexx/trunk/bsf4oorexx.dev/source_cc/
    target=$BSF4OOREXX/trunk/bsf4oorexx.dev/source_cc/
    ln -f -s $source/Makefile-builder              $target/Makefile-builder
    ln -f -s $source/apple-Makefile-builder.mak    $target/apple-Makefile-builder.mak
    ln -f -s $source/lin_bsf4rexx-builder.mak      lin_bsf4$target/rexx-builder.mak


    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/api/platform/windows/
    target=$OOREXX/official/main/releases/4.2.0/trunk/api/platform/windows/
    ln -f -s $source/rexxapitypes.h                $target/rexxapitypes.h

    source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/
    target=$OOREXX/official/main/releases/4.2.0/trunk/
    ln -f -s cl_infos.cpp                          $target/cl_infos.cpp
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
