# Helper script for Linux/MacOs.
# The files under adaptation can be referenced from the packages being adapted,
# using symbolic or hard links.
# You can use this script to create those links.


help()
{
    echo Options:
    echo -show: show the commands that would be executed, but don''t execute them.
    echo -doit: really do the commands.
    echo -diff: list the source files which exists and are different from the target
    echo -diffview: list all the differences
}


mklink()
{
    local source=$1
    local target=$2
    local execute=$3
    # Symbolic links are not supported by SVN, better to create hard links
    $execute ln -f $source $target
}


show_mklink()
{
    mklink $1 $2 echo
}


do_mklink()
{
    mklink $1 $2
}


diff_mini()
{
    local source=$1
    local target=$2
    if [ -e $source ]
    then
        diff --strip-trailing-cr $source $target > /dev/null 2>&1
        local error=$?
        if [ $error -eq 1 ]; then echo $source; fi
    fi
}


diff_view()
{
    local source=$1
    local target=$2
    if [ -e $source ]
    then
        diff --strip-trailing-cr $source $target > /dev/null 2>&1
        local error=$?
        if [ $error -eq 1 ]
        then
            echo $source
            diff --strip-trailing-cr $source $target
        fi
    fi
}


actions()
{
    local action=$1

    # Replace by your path (no space !)
    BUILDER=/local/builder
    GCI=/local/rexx/GCI
    BSF4OOREXX=/local/rexx/bsf4oorexx
    OOREXX=/local/rexx/oorexx


    ################################################################################
    # GCI/gci-source.1.1
    ################################################################################

    local source=$BUILDER/adaptations/GCI/gci-source.1.1
    local target=$GCI/gci-source.1.1
    $action $source/gci-try.rexx                  $target/gci-try.rexx
    $action $source/gci.h                         $target/gci.h
    $action $source/gci_convert.linux.86_64       $target/gci_convert.linux.86_64
    $action $source/gci_convert.macX.all          $target/gci_convert.macX.all
    $action $source/gci_convert.win32.vc          $target/gci_convert.win32.vc
    $action $source/gci_oslink.macX               $target/gci_oslink.macX
    $action $source/gci_rexxbridge.c              $target/gci_rexxbridge.c
    $action $source/gci_tree.c                    $target/gci_tree.c
    $action $source/gci_win32.def                 $target/gci_win32.def
    $action $source/GNUmakefile-builder           $target/GNUmakefile-builder
    $action $source/Makefile-builder.vc           $target/Makefile-builder.vc


    ################################################################################
    # bsf4oorexx/trunk
    ################################################################################

    local source=$BUILDER/adaptations/bsf4oorexx/trunk/bsf4oorexx.dev/source_cc
    local target=$BSF4OOREXX/svn/trunk/bsf4oorexx.dev/source_cc
    $action $source/Makefile-builder-windows  $target/Makefile-builder-windows
    $action $source/Makefile-builder-macosx   $target/Makefile-builder-macosx
    $action $source/Makefile-builder-linux    $target/Makefile-builder-linux


    ################################################################################
    # oorexx/official/main/branches/4.2
    ################################################################################

    local source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/api/platform/windows
    local target=$OOREXX/official/main/branches/4.2/trunk/api/platform/windows
    $action $source/rexxapitypes.h                $target/rexxapitypes.h

    local source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk
    local target=$OOREXX/official/main/branches/4.2/trunk
    $action $source/cl_infos.cpp                  $target/cl_infos.cpp
    $action $source/Makefile.am                   $target/Makefile.am
    $action $source/makeorx_verbose.bat           $target/makeorx_verbose.bat
    $action $source/makeorx.bat                   $target/makeorx.bat
    $action $source/orxdb.bat                     $target/orxdb.bat

    local source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/interpreter/platform/windows
    local target=$OOREXX/official/main/branches/4.2/trunk/interpreter/platform/windows
    $action $source/PlatformDefinitions.h         $target/PlatformDefinitions.h

    local source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/lib
    local target=$OOREXX/official/main/branches/4.2/trunk/lib
    $action $source/orxwin32.mak                  $target/orxwin32.mak

    local source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/platform/windows
    local target=$OOREXX/official/main/branches/4.2/trunk/platform/windows
    $action $source/buildorx.bat                  $target/buildorx.bat


    ################################################################################
    # oorexx/official/main/releases/4.2.0
    ################################################################################

    local source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/api/platform/windows
    local target=$OOREXX/official/main/releases/4.2.0/trunk/api/platform/windows
    $action $source/rexxapitypes.h                $target/rexxapitypes.h

    local source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk
    local target=$OOREXX/official/main/releases/4.2.0/trunk
    $action $source/cl_infos.cpp                  $target/cl_infos.cpp
    $action $source/Makefile.am                   $target/Makefile.am
    $action $source/makeorx_verbose.bat           $target/makeorx_verbose.bat
    $action $source/makeorx.bat                   $target/makeorx.bat
    $action $source/orxdb.bat                     $target/orxdb.bat

    local source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/interpreter/platform/windows
    local target=$OOREXX/official/main/releases/4.2.0/trunk/interpreter/platform/windows
    $action $source/PlatformDefinitions.h         $target/PlatformDefinitions.h

    local source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/lib
    local target=$OOREXX/official/main/releases/4.2.0/trunk/lib
    $action $source/orxwin32.mak                  $target/orxwin32.mak

    local source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/platform/windows
    local target=$OOREXX/official/main/releases/4.2.0/trunk/platform/windows
    $action $source/buildorx.bat                  $target/buildorx.bat


    ################################################################################
    # oorexx/official/main/trunk
    ################################################################################

    local source=$BUILDER/adaptations/oorexx/official/main/trunk
    local target=$OOREXX/official/main/trunk
    $action $source/CMakeLists.txt                $target/CMakeLists.txt


    ################################################################################
    # oorexx/official/test/branches/4.2.0
    ################################################################################

    local source=$BUILDER/adaptations/oorexx/official/test/branches/4.2.0/trunk/external/API
    local target=$OOREXX/official/test/branches/4.2.0/trunk/external/API
    $action $source/Makefile.windows              $target/Makefile.windows


    ################################################################################
    # oorexx/official/test/trunk
    ################################################################################

    local source=$BUILDER/adaptations/oorexx/official/test/trunk/external/API
    local target=$OOREXX/official/test/trunk/external/API
    $action $source/Makefile.windows              $target/Makefile.windows


    ################################################################################

    echo
    if [ "$action" == "show_mklink" ]
    then
        echo "Use the option -doit to really execute the actions"
    else
        echo "Done."
    fi
}


if [ "$1" == "" ]; then help
elif [ "$1" == "-show" ]; then actions show_mklink
elif [ "$1" == "-doit" ]; then actions do_mklink
elif [ "$1" == "-diff" ]; then actions diff_mini
elif [ "$1" == "-diffview" ]; then actions diff_view
else
    echo Unknown option: $1
    help
fi
