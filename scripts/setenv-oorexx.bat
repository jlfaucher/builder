@echo off
if defined echo echo %echo%

:: Those variables must be defined before calling this script
:: (can be empty, don't test it) if not defined builder_branch echo builder_branch is undefined & exit /b 1
if not defined builder_build_dir echo builder_build_dir is undefined & exit /b 1
if not defined builder_config echo builder_config is undefined & exit /b 1
if not defined builder_config_dir echo builder_config_dir is undefined & exit /b 1
if not defined builder_delivery_dir echo builder_delivery_dir is undefined & exit /b 1
if not defined builder_local_dir echo builder_local_dir is undefined & exit /b 1
if not defined builder_scripts_dir echo builder_scripts_dir is undefined & exit /b 1
if not defined builder_shared_dir echo builder_shared_dir is undefined & exit /b 1
if not defined builder_shared_drv echo builder_shared_drv is undefined & exit /b 1
if not defined builder_src_relative_path echo builder_src_relative_path is undefined & exit /b 1
if not defined builder_target echo builder_target is undefined & exit /b 1

set oorexx_doc_dir=%builder_shared_dir%\official\docs
set oorexx_doc_drv=%builder_shared_drv%
set oorexx_test_trunk=%builder_shared_dir%\official\test\trunk
set oorexx_test_drv=%builder_shared_drv%
set oorexx_test_src=%oorexx_test_trunk%

doskey cdoorexx=%builder_shared_drv% $T cd %builder_shared_dir%
doskey cdshared=%builder_shared_drv% $T cd %builder_shared_dir%
doskey cdoorexxlocal=%builder_local_drv% $T cd %builder_local_dir%
doskey cdlocal=%builder_local_drv% $T cd %builder_local_dir%

doskey cdofficial=%builder_shared_drv% $T cd %builder_shared_dir%\official
doskey cdexecutor=%builder_shared_drv% $T cd %builder_shared_dir%\executor
doskey cdexecutor5=%builder_shared_drv% $T cd %builder_shared_dir%\executor5

doskey cdtrunk=%builder_src_drv% $T cd %builder_src_dir%
doskey cdsrc=%builder_src_drv% $T cd %builder_src_dir%

doskey cdconfig=%builder_config_drv% $T cd %builder_config_dir%
doskey cdbuild=%builder_build_drv% $T cd %builder_build_dir%
doskey cddelivery=%builder_delivery_drv% $T cd %builder_delivery_dir%

doskey cddoc=%oorexx_doc_drv% $T cd %oorexx_doc_dir%
doskey cddocs=%oorexx_doc_drv% $T cd %oorexx_doc_dir%

:: Title of console
title ooRexx %builder_target% %builder_branch% %builder_src_relative_path% %builder_config% %builder_bitness%

call shellscriptlib :prepend_path PATH "%builder_shared_dir%\scripts"

:: Needed by extensions\platform\windows\ole\events.cpp for for AgtCtl_i.c
set sdk=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A
if exist "%sdk%" set INCLUDE=%INCLUDE%;%sdk%\include

echo Setting environment for building with ooRexx
set INCLUDE=%builder_delivery_dir%\api;%INCLUDE%
set LIB=%builder_delivery_dir%\api;%LIB%

echo Setting environment for executing ooRexx
call shellscriptlib :prepend_path PATH "%builder_delivery_dir%"

echo Setting environment for ooRexx test framework
call shellscriptlib :prepend_path PATH "%oorexx_test_trunk%"
call shellscriptlib :prepend_path PATH "%oorexx_test_trunk%\framework"
doskey cdtest=%oorexx_test_drv% $T cd %oorexx_test_trunk%
doskey cdtests=%oorexx_test_drv% $T cd %oorexx_test_trunk%

:: From the directory official\incubator, reference some subdirectories in executor :
:: move ooRexxShell ooRexxShell.svn
:: mklink /d ooRexxShell ..\..\executor\incubator\ooRexxShell
:: move DocMusings DocMusings.svn
:: mklink /d DocMusings ..\..\executor\incubator\DocMusings
echo Setting environment for incubator
set oorexx_incubator=%builder_shared_dir%\official\incubator
set oorexx_incubator_drv=%builder_shared_drv%
call shellscriptlib :prepend_path PATH "%oorexx_incubator%"
doskey cdincubator=%oorexx_incubator_drv% $T cd %oorexx_incubator%

echo Setting environment for DocMusings
set oorexx_docmusings=%oorexx_incubator%\docmusings
set oorexx_docmusings_drv=%oorexx_incubator_drv%
doskey cddocmusings=%oorexx_docmusings_drv% $T cd %oorexx_docmusings%
set oorexx_transformxml=%oorexx_docmusings%\transformxml
set oorexx_transformxml_drv=%oorexx_docmusings_drv%
doskey cdtransformxml=%oorexx_transformxml_drv% $T cd %oorexx_transformxml%
call shellscriptlib :prepend_path PATH "%oorexx_docmusings%"

echo Setting environment for ooRexxShell
call shellscriptlib :prepend_path PATH "%oorexx_incubator%\oorexxshell"
doskey cdoorexxshell=%oorexx_incubator_drv% $T cd %oorexx_incubator%\oorexxshell

::echo Setting environment for ooSQLite
::prepend_path PATH $oorexx_incubator/ooSQLite/bin/linux
::prepend_path LD_LIBRARY_PATH $oorexx_incubator/ooSQLite/bin/linux
::prepend_path DYLD_LIBRARY_PATH $oorexx_incubator/ooSQLite/bin/linux
::prepend_path DYLD_FALLBACK_LIBRARY_PATH $oorexx_incubator/ooSQLite/bin/linux
::alias cdoosqlite='cd $oorexx_incubator/ooSQLite'

:: Replace the directory official/sandbox/jlf by a symbolic link to executor/sandbox/jlf
:: move jlf jlf.svn
:: mklink /d jlf ..\..\executor\sandbox\jlf
echo Setting environment for the sandbox
set oorexx_sandbox=%builder_shared_dir%\official\sandbox
set oorexx_sandbox_drv=%builder_shared_drv%
doskey cdsandbox=%oorexx_sandbox_drv% $T cd %oorexx_sandbox%
doskey cdsandboxjlf=%oorexx_sandbox_drv% $T cd %oorexx_sandbox%\jlf

echo Setting environment for the sandbox samples
set oorexx_samples=%oorexx_sandbox%\jlf\samples
set oorexx_samples_drv=%oorexx_sandbox_drv%
call shellscriptlib :prepend_path PATH "%oorexx_samples%"
doskey cdsamples=%oorexx_samples_drv% $T cd %oorexx_samples%
doskey cdextension=%oorexx_samples_drv% $T cd %oorexx_samples%\extension
doskey cdextensionstd=%oorexx_samples_drv% $T cd %oorexx_samples%\extension\std
doskey cdfunctional=%oorexx_samples_drv% $T cd %oorexx_samples%\functional
doskey cdconcurrency=%oorexx_samples_drv% $T cd %oorexx_samples%\concurrency
doskey cdmutablebuffer=%oorexx_samples_drv% $T cd %oorexx_samples%\mutablebuffer
doskey cdrgfutil2=%oorexx_samples_drv% $T cd %oorexx_samples%\rgf_util2
doskey cdtrace=%oorexx_samples_drv% $T cd %oorexx_samples%\trace

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Other dependencies (like NSIS, BSF4ooRexx)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set other_dependencies="%builder_scripts_dir%.private\other_dependencies-oorexx.bat"
set other_dependencies=%other_dependencies:&=^&%
set other_dependencies=%other_dependencies:"=%
if exist "%other_dependencies%" (
    echo Running "%other_dependencies%"
    call "%other_dependencies%"
    if errorlevel 1 exit /b 1
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compatibility with old build system (oorexx <= 4.2, executor)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Old build system : rexximage must be in the path during the build.
:: Old build system : there is no delivery (except NSIS), so PATH must include the build directory.
echo Setting environment for building ooRexx (old build system)
call shellscriptlib :prepend_path PATH "%builder_build_dir%"


:: The following scripts must be adapted to support a build directory outside the source directory.
:: They are already adapted for executor, but not adapted for ooRexx.
::
:: - makeorx.bat :
::   The executor version can be used as-is for ooRexx.
::   You must copy cl_infos.cpp in trunk.
::
:: - orxdb.bat :
::   The executor version can be used for ooRexx, but some changes must be applied :
::   Search for
::       OODIALOGSRCW
::       m17n
::   and remove the part in relation with this text.
::   Add set OR_ORYXINCL=%OR_ORYXINCL% -I%OR_OODIALOGSRC%\
::
:: - lib\orxwin32.mak :
::   The executor version can be used as-is for ooRexx.
::
:: - platform\windows\buildorx.bat :
::   The executor version can be reused as-is for ooRexx.

set SRC_DRV=%builder_src_drv%
set SRC_DIR=\%builder_src_dir:*\=%
set BUILD_DRV=%builder_build_drv%
set BUILD_DIR=\%builder_build_dir:*\=%

set BUILD_TYPE=
if "%builder_config%" == "release" set BUILD_TYPE=NODEBUG
if "%builder_config%" == "debug" set BUILD_TYPE=DEBUG

exit /b 0
