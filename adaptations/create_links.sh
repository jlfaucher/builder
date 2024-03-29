#!/bin/bash

# Helper script for Linux/MacOs.
# The files under adaptation can be referenced from the packages being adapted,
# using symbolic or hard links.
# You can use this script to create those links.


# Replace by your path (no space !)
BSF4OOREXX=/local/rexx/bsf4oorexx
OOREXX=/local/rexx/oorexx


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
    local source_dir=$1
    local target_dir=$2
    local file=$3
    local execute=$4

    local source=$source_dir/$file
    local target=$target_dir/$file

    if [ ! -d $target_dir ]; then return; fi
    check $source mandatory

    diff --strip-trailing-cr $source $target > /dev/null 2>&1
    local error=$?
    if [ $error -ne 0 ]
    then
        # Symbolic links are not supported by SVN, better to create hard links
        $execute ln -f $source $target
    fi
}


show_mklink()
{
    mklink $1 $2 $3 echo
}


do_mklink()
{
    mklink $1 $2 $3
}


diff_mini()
{
    local source_dir=$1
    local target_dir=$2
    local file=$3
    local execute=$4

    local source=$source_dir/$file
    local target=$target_dir/$file

    if [ ! -d $target_dir ]; then return; fi
    check $source mandatory

    diff --strip-trailing-cr $source $target > /dev/null 2>&1
    local error=$?
    if [ $error -ne 0 ]; then echo $target; fi
}


diff_view()
{
    local source_dir=$1
    local target_dir=$2
    local file=$3
    local execute=$4

    local source=$source_dir/$file
    local target=$target_dir/$file

    if [ ! -d $target_dir ]; then return; fi
    check $source mandatory

    diff --strip-trailing-cr $source $target > /dev/null 2>&1
    local error=$?
    if [ $error -ne 0 ]
    then
        echo $target
        diff --strip-trailing-cr $source $target
    fi
}


actions()
{
    local action=$1


    ################################################################################
    # bsf4oorexx/trunk
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/bsf4oorexx/trunk/bsf4oorexx.dev/source_cc
    local target=$BSF4OOREXX/svn/trunk/bsf4oorexx.dev/source_cc
    $action $source $target Makefile-builder-windows
    $action $source $target Makefile-builder-macosx
    $action $source $target Makefile-builder-linux


    ################################################################################
    # oorexx/official/main/branches/4.2
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/branches/4.2/trunk/api/platform/windows
    local target=$OOREXX/official/main/branches/4.2/trunk/api/platform/windows
    $action $source $target rexxapitypes.h

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/branches/4.2/trunk
    local target=$OOREXX/official/main/branches/4.2/trunk
    $action $source $target cl_infos.cpp
    $action $source $target Makefile.am
    $action $source $target makeorx_verbose.bat
    $action $source $target makeorx.bat
    $action $source $target orxdb.bat

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/branches/4.2/trunk/interpreter/platform/windows
    local target=$OOREXX/official/main/branches/4.2/trunk/interpreter/platform/windows
    $action $source $target PlatformDefinitions.h

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/branches/4.2/trunk/lib
    local target=$OOREXX/official/main/branches/4.2/trunk/lib
    $action $source $target orxwin32.mak

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/branches/4.2/trunk/platform/windows
    local target=$OOREXX/official/main/branches/4.2/trunk/platform/windows
    $action $source $target buildorx.bat


    ################################################################################
    # oorexx/official/main/releases/3.1.2
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/3.1.2/trunk
    local target=$OOREXX/official/main/releases/3.1.2/trunk
    $action $source $target Makefile.am


    ################################################################################
    # oorexx/official/main/releases/3.2.0
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/3.2.0/trunk
    local target=$OOREXX/official/main/releases/3.2.0/trunk
    $action $source $target Makefile.am


    ################################################################################
    # oorexx/official/main/releases/4.0.0
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.0.0/trunk
    local target=$OOREXX/official/main/releases/4.0.0/trunk
    $action $source $target Makefile.am


    ################################################################################
    # oorexx/official/main/releases/4.0.1
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.0.1/trunk
    local target=$OOREXX/official/main/releases/4.0.1/trunk
    $action $source $target Makefile.am


    ################################################################################
    # oorexx/official/main/releases/4.1.0
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.1.0/trunk
    local target=$OOREXX/official/main/releases/4.1.0/trunk
    $action $source $target Makefile.am


    ################################################################################
    # oorexx/official/main/releases/4.1.1
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.1.1/trunk
    local target=$OOREXX/official/main/releases/4.1.1/trunk
    $action $source $target Makefile.am


    ################################################################################
    # oorexx/official/main/releases/4.2.0
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/api/platform/windows
    local target=$OOREXX/official/main/releases/4.2.0/trunk/api/platform/windows
    $action $source $target rexxapitypes.h

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk
    local target=$OOREXX/official/main/releases/4.2.0/trunk
    $action $source $target cl_infos.cpp
    $action $source $target Makefile.am
    $action $source $target makeorx_verbose.bat
    $action $source $target makeorx.bat
    $action $source $target orxdb.bat

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/api
    local target=$OOREXX/official/main/releases/4.2.0/trunk/api
    $action $source $target oorexxapi.h

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/extensions/rexxutil/platform/unix
    local target=$OOREXX/official/main/releases/4.2.0/trunk/extensions/rexxutil/platform/unix
    $action $source $target rexxutil.cpp

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/interpreter/api
    local target=$OOREXX/official/main/releases/4.2.0/trunk/interpreter/api
    $action $source $target ThreadContextStubs.cpp

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/interpreter/platform/windows
    local target=$OOREXX/official/main/releases/4.2.0/trunk/interpreter/platform/windows
    $action $source $target PlatformDefinitions.h

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/lib
    local target=$OOREXX/official/main/releases/4.2.0/trunk/lib
    $action $source $target orxwin32.mak

    local source=$BUILDER_ADAPTATIONS/oorexx/official/main/releases/4.2.0/trunk/platform/windows
    local target=$OOREXX/official/main/releases/4.2.0/trunk/platform/windows
    $action $source $target buildorx.bat


    ################################################################################
    # oorexx/official/test/branches/4.2.0
    ################################################################################

    local source=$BUILDER_ADAPTATIONS/oorexx/official/test/branches/4.2.0/trunk/external/API
    local target=$OOREXX/official/test/branches/4.2.0/trunk/external/API
    $action $source $target Makefile.windows


    ################################################################################

    echo
    if [ "$action" == "show_mklink" ]
    then
        echo "Use the option -doit to really execute the actions"
    else
        echo "Done."
    fi
}

check()
{
    if [ ! -e $1 ]; then
        echo "***FATAL*** NOT FOUND:$1"
        if [ "$2" == "mandatory" ]; then exit 1; fi
    fi
}


################################################################################
# Main routine
################################################################################

# Path to this script
FILE="${BASH_SOURCE[0]}"
BUILDER_ADAPTATIONS="$( cd -P "$(dirname "$FILE")" && pwd )"


check $BUILDER_ADAPTATIONS mandatory

if [ "$1" == "" ]; then help
elif [ "$1" == "-show" ]; then actions show_mklink
elif [ "$1" == "-doit" ]; then actions do_mklink
elif [ "$1" == "-diff" ]; then actions diff_mini
elif [ "$1" == "-diffview" ]; then actions diff_view
else
    echo Unknown option: $1
    help
fi
