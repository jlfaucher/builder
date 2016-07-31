# Helper script for Linux/MacOs.
# The files under adaptation can be referenced from the packages being adapted,
# using symbolic links. You can use this script to create those symbolic links.

# By default, just echo the commands.
# If you pass the parameter "doit" then really do the commands.
doit=echo
if [ "$1" == "-doit" ] ; then doit= ; fi

# Replace by your path (no space !)
BUILDER=/local/builder
GCI=/local/rexx/GCI
BSF4OOREXX=/local/rexx/bsf4oorexx
OOREXX=/local/rexx/oorexx

# Symbolic links are not supported by SVN, better to create hard links
# symbolic=-s
symbolic=

################################################################################
# GCI/gci-source.1.1
################################################################################

source=$BUILDER/adaptations/GCI/gci-source.1.1
target=$GCI/gci-source.1.1
$doit ln -f $symbolic $source/gci-try.rexx                  $target/gci-try.rexx
$doit ln -f $symbolic $source/gci.h                         $target/gci.h
$doit ln -f $symbolic $source/gci_convert.linux.86_64       $target/gci_convert.linux.86_64
$doit ln -f $symbolic $source/gci_convert.macX.all          $target/gci_convert.macX.all
$doit ln -f $symbolic $source/gci_convert.win32.vc          $target/gci_convert.win32.vc
$doit ln -f $symbolic $source/gci_oslink.macX               $target/gci_oslink.macX
$doit ln -f $symbolic $source/gci_rexxbridge.c              $target/gci_rexxbridge.c
$doit ln -f $symbolic $source/gci_tree.c                    $target/gci_tree.c
$doit ln -f $symbolic $source/gci_win32.def                 $target/gci_win32.def
$doit ln -f $symbolic $source/GNUmakefile-builder           $target/GNUmakefile-builder
$doit ln -f $symbolic $source/Makefile-builder.vc           $target/Makefile-builder.vc


################################################################################
# bsf4oorexx/trunk
################################################################################

source=$BUILDER/adaptations/bsf4oorexx/trunk/bsf4oorexx.dev/source_cc
target=$BSF4OOREXX/svn/trunk/bsf4oorexx.dev/source_cc
$doit ln -f $symbolic $source/Makefile-builder              $target/Makefile-builder
$doit ln -f $symbolic $source/apple-Makefile-builder.mak    $target/apple-Makefile-builder.mak
$doit ln -f $symbolic $source/lin_bsf4rexx-builder.mak      $target/lin_bsf4rexx-builder.mak


################################################################################
# oorexx/official/main/branches/4.2
################################################################################

source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/api/platform/windows
target=$OOREXX/official/main/branches/4.2/trunk/api/platform/windows
$doit ln -f $symbolic $source/rexxapitypes.h                $target/rexxapitypes.h

source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk
target=$OOREXX/official/main/branches/4.2/trunk
$doit ln -f $symbolic $source/cl_infos.cpp                  $target/cl_infos.cpp
$doit ln -f $symbolic $source/Makefile.am                   $target/Makefile.am
$doit ln -f $symbolic $source/makeorx_verbose.bat           $target/makeorx_verbose.bat
$doit ln -f $symbolic $source/makeorx.bat                   $target/makeorx.bat
$doit ln -f $symbolic $source/orxdb.bat                     $target/orxdb.bat

source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/interpreter/platform/windows
target=$OOREXX/official/main/branches/4.2/trunk/interpreter/platform/windows
$doit ln -f $symbolic $source/PlatformDefinitions.h         $target/PlatformDefinitions.h

source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/lib
target=$OOREXX/official/main/branches/4.2/trunk/lib
$doit ln -f $symbolic $source/orxwin32.mak                  $target/orxwin32.mak

source=$BUILDER/adaptations/oorexx/official/main/branches/4.2/trunk/platform/windows
target=$OOREXX/official/main/branches/4.2/trunk/platform/windows
$doit ln -f $symbolic $source/buildorx.bat                  $target/buildorx.bat


################################################################################
# oorexx/official/main/releases/4.2.0
################################################################################

source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/api/platform/windows
target=$OOREXX/official/main/releases/4.2.0/trunk/api/platform/windows
$doit ln -f $symbolic $source/rexxapitypes.h                $target/rexxapitypes.h

source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk
target=$OOREXX/official/main/releases/4.2.0/trunk
$doit ln -f $symbolic $source/cl_infos.cpp                  $target/cl_infos.cpp
$doit ln -f $symbolic $source/Makefile.am                   $target/Makefile.am
$doit ln -f $symbolic $source/makeorx_verbose.bat           $target/makeorx_verbose.bat
$doit ln -f $symbolic $source/makeorx.bat                   $target/makeorx.bat
$doit ln -f $symbolic $source/orxdb.bat                     $target/orxdb.bat

source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/interpreter/platform/windows
target=$OOREXX/official/main/releases/4.2.0/trunk/interpreter/platform/windows
$doit ln -f $symbolic $source/PlatformDefinitions.h         $target/PlatformDefinitions.h

source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/lib
target=$OOREXX/official/main/releases/4.2.0/trunk/lib
$doit ln -f $symbolic $source/orxwin32.mak                  $target/orxwin32.mak

source=$BUILDER/adaptations/oorexx/official/main/releases/4.2.0/trunk/platform/windows
target=$OOREXX/official/main/releases/4.2.0/trunk/platform/windows
$doit ln -f $symbolic $source/buildorx.bat                  $target/buildorx.bat


################################################################################
# oorexx/official/main/trunk
################################################################################

source=$BUILDER/adaptations/oorexx/official/main/trunk
target=$OOREXX/official/main/trunk
$doit ln -f $symbolic $source/CMakeLists.txt                $target/CMakeLists.txt


################################################################################
# oorexx/official/test/branches/4.2.0
################################################################################

source=$BUILDER/adaptations/oorexx/official/test/branches/4.2.0/trunk/external/API
target=$OOREXX/official/test/branches/4.2.0/trunk/external/API
$doit ln -f $symbolic $source/Makefile.windows              $target/Makefile.windows


################################################################################
# oorexx/official/test/trunk
################################################################################

source=$BUILDER/adaptations/oorexx/official/test/trunk/external/API
target=$OOREXX/official/test/trunk/external/API
$doit ln -f $symbolic $source/Makefile.windows              $target/Makefile.windows


################################################################################

echo
if [ "$doit" == "echo" ]
then
    echo "Use the option -doit to really execute the actions"
else
    echo "Done."
fi
