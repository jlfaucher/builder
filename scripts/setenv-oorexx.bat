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
if not defined builder_src_dir echo builder_src_dir is undefined & exit /b 1
if not defined builder_src_drv echo builder_src_drv is undefined & exit /b 1
if not defined builder_src_relative_path echo builder_src_relative_path is undefined & exit /b 1
if not defined builder_target echo builder_target is undefined & exit /b 1

doskey cdoorexx=%builder_shared_drv% ^& cd %builder_shared_dir%
doskey cdshared=%builder_shared_drv% ^& cd %builder_shared_dir%
doskey cdoorexxlocal=%builder_local_drv% ^& cd %builder_local_dir%
doskey cdlocal=%builder_local_drv% ^& cd %builder_local_dir%

doskey cdofficial=%builder_shared_drv% ^& cd %builder_shared_dir%\official
doskey cdexecutor=%builder_shared_drv% ^& cd %builder_shared_dir%\executor
doskey cdexecutor5=%builder_shared_drv% ^& cd %builder_shared_dir%\executor5
doskey cdexecutor5bulk=%builder_shared_drv% ^& cd %builder_shared_dir%\executor5-bulk
:: next macro is not registered, probably because of the dash... It works from the command line.
doskey cdexecutor5-bulk=%builder_shared_drv% ^& cd %builder_shared_dir%\executor5-bulk

doskey cdtrunk=%builder_src_drv% ^& cd %builder_src_dir%
doskey cdsrc=%builder_src_drv% ^& cd %builder_src_dir%

doskey cdconfig=%builder_config_drv% ^& cd %builder_config_dir%
doskey cdbuild=%builder_build_drv% ^& cd %builder_build_dir%
doskey cddelivery=%builder_delivery_drv% ^& cd %builder_delivery_dir%

:: Title of console
title ooRexx %builder_target% %builder_branch% %builder_src_relative_path% %builder_system_arch% %builder_compiler% %builder_config%

:: Local scripts, not in Github for the moment
call shellscriptlib :prepend_path PATH "%builder_shared_dir%\scripts"

:: Needed by extensions\platform\windows\ole\events.cpp for for AgtCtl_i.c
:: 09/01/2024 to remove? this directory no longer exists with recent Visual Studio
set sdk=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A
if exist "%sdk%" call shellscriptlib :prepend_path INCLUDE "%sdk%\include"

echo Setting environment for building with ooRexx
call shellscriptlib :prepend_path INCLUDE "%builder_delivery_dir%\api"
call shellscriptlib :prepend_path LIB "%builder_delivery_dir%\api"

echo Setting environment for executing ooRexx
call shellscriptlib :prepend_path PATH "%builder_delivery_dir%"

echo Setting environment for ooRexx documentation
set oorexx_doc_dir=%builder_shared_dir%\%builder_target%\docs
set oorexx_doc_drv=%builder_shared_drv%
doskey cddoc=%oorexx_doc_drv% ^& cd %oorexx_doc_dir%
doskey cddocs=%oorexx_doc_drv% ^& cd %oorexx_doc_dir%

echo Setting environment for ooRexx test framework
set oorexx_test_trunk=%builder_shared_dir%\%builder_target%\test\trunk
set oorexx_test_drv=%builder_shared_drv%
set oorexx_test_src=%oorexx_test_trunk%
call shellscriptlib :prepend_path PATH "%oorexx_test_trunk%"
call shellscriptlib :prepend_path PATH "%oorexx_test_trunk%\framework"
doskey cdtest=%oorexx_test_drv% ^& cd %oorexx_test_trunk%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Cross references between ooRexx and executor
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Next section is not working under Windows 11 Home ARM.
:: There is a workaround in the private script setenv-executor and setenv-official.

:: Optional, to do manually if you have installed official ooRexx:
    :: From the directory official\incubator, reference some subdirectories in executor :
    :: mklink /d ooRexxShell-executor ..\..\executor\incubator\ooRexxShell
    :: mklink /d DocMusings-executor ..\..\executor\incubator\DocMusings

    :: From the directory official\sandbox, reference some subdirectories in executor :
    :: mklink /d jlf-executor ..\..\executor\sandbox\jlf

    :: From the directory executor\incubator, reference some subdirectories in official :
    :: mklink /d ooSQLite ..\..\official\incubator\ooSQLite
    :: mklink /d regex ..\..\official\incubator\regex

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Incubator
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo Setting environment for incubator
set oorexx_incubator=%builder_shared_dir%\%builder_target%\incubator
set oorexx_incubator_drv=%builder_shared_drv%
call shellscriptlib :prepend_path PATH "%oorexx_incubator%"
doskey cdincubator=%oorexx_incubator_drv% ^& cd %oorexx_incubator%

:: echo Setting environment for ooSQLite
:: call shellscriptlib :prepend_path PATH "%oorexx_incubator%\ooSQLite\bin\windows
:: doskey cdoosqlite=%oorexx_incubator_drv% ^& cd %oorexx_incubator%\ooSQLite'

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Executor incubator
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo Setting environment for DocMusings
if not defined executor_docmusings set executor_docmusings=%oorexx_incubator%\docmusings-executor
if not exist "%executor_docmusings%" set executor_docmusings=%oorexx_incubator%\docmusings
set executor_docmusings_drv=%oorexx_incubator_drv%
doskey cddocmusings=%executor_docmusings_drv% ^& cd %executor_docmusings%
set oorexx_transformxml=%executor_docmusings%\transformxml
set oorexx_transformxml_drv=%executor_docmusings_drv%
doskey cdtransformxml=%oorexx_transformxml_drv% ^& cd %oorexx_transformxml%
call shellscriptlib :prepend_path PATH "%executor_docmusings%"

echo Setting environment for ooRexxShell
if not defined executor_oorexxshell set executor_oorexxshell=%oorexx_incubator%\ooRexxShell-executor
if not exist "%executor_oorexxshell%" set executor_oorexxshell=%oorexx_incubator%\ooRexxShell
set executor_oorexxshell_drv=%oorexx_incubator_drv%
call shellscriptlib :prepend_path PATH "%executor_oorexxshell%"
doskey cdoorexxshell=%executor_oorexxshell_drv% ^& cd %executor_oorexxshell%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Sandbox
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo Setting environment for the sandbox
set oorexx_sandbox=%builder_shared_dir%\%builder_target%\sandbox
set oorexx_sandbox_drv=%builder_shared_drv%
doskey cdsandbox=%oorexx_sandbox_drv% ^& cd %oorexx_sandbox%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Executor sandbox
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo Setting environment for the sandbox jlf
if not defined executor_sandboxjlf set executor_sandboxjlf=%oorexx_sandbox%\jlf-executor
if not exist "%executor_sandboxjlf%" set executor_sandboxjlf=%oorexx_sandbox%\jlf
call shellscriptlib :prepend_path PATH "%executor_sandboxjlf%"
doskey cdsandboxjlf=%oorexx_sandbox_drv% ^& cd %executor_sandboxjlf%
doskey cdjlf=%oorexx_sandbox_drv% ^& cd %executor_sandboxjlf%

echo Setting environment for the sandbox packages
set executor_packages=%executor_sandboxjlf%\packages
set executor_packages_drv=%oorexx_sandbox_drv%
call shellscriptlib :prepend_path PATH "%executor_packages%"
doskey cdpackages=%executor_packages_drv% ^& cd %executor_packages%
doskey cdextension=%executor_packages_drv% ^& cd %executor_packages%\extension
doskey cdextensionstd=%executor_packages_drv% ^& cd %executor_packages%\extension\std
doskey cdfunctional=%executor_packages_drv% ^& cd %executor_packages%\functional
doskey cdconcurrency=%executor_packages_drv% ^& cd %executor_packages%\concurrency
doskey cdmutablebuffer=%executor_packages_drv% ^& cd %executor_packages%\mutablebuffer
doskey cdrgfutil2=%executor_packages_drv% ^& cd %executor_packages%\rgf_util2
doskey cdtrace=%executor_packages_drv% ^& cd %executor_packages%\trace

echo Setting environment for the sandbox samples
set executor_samples=%executor_sandboxjlf%\samples
set executor_samples_drv=%oorexx_sandbox_drv%
call shellscriptlib :prepend_path PATH "%executor_samples%"
doskey cdsamples=%executor_samples_drv% ^& cd %executor_samples%
doskey cdextensionsamples=%executor_samples_drv% ^& cd %executor_samples%\extension
doskey cdextensionstdsamples=%executor_samples_drv% ^& cd %executor_samples%\extension\std
doskey cdfunctionalsamples=%executor_samples_drv% ^& cd %executor_samples%\functional
doskey cdconcurrencysamples=%executor_samples_drv% ^& cd %executor_samples%\concurrency
doskey cdmutablebuffersamples=%executor_samples_drv% ^& cd %executor_samples%\mutablebuffer
doskey cdrgfutil2samples=%executor_samples_drv% ^& cd %executor_samples%\rgf_util2
doskey cdtracesamples=%executor_samples_drv% ^& cd %executor_samples%\trace

set executor_tests=%executor_sandboxjlf%\tests
set executor_tests_drv=%oorexx_sandbox_drv%
doskey cdtests=%executor_tests_drv% ^& cd %executor_tests%

set executor_testx=%builder_shared_dir%\executor\testx
set executor_testx_drv=%builder_shared_drv%
doskey cdtestx=%executor_testx_drv% ^& cd %executor_testx%

set executor_demos=%executor_sandboxjlf%\demos
set executor_demos_drv=%oorexx_sandbox_drv%
doskey cddemos=%executor_demos_drv% ^& cd %executor_demos%

set executor_unicode=%executor_sandboxjlf%\unicode
set executor_unicode_drv=%oorexx_sandbox_drv%
doskey cdunicode=%executor_unicode_drv% ^& cd %executor_unicode%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Compatibility with old build system (oorexx <= 4.2)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Old build system : rexximage must be in the path during the build.
:: Old build system : there is no delivery (except NSIS), so PATH must include the build directory.
call shellscriptlib :prepend_path PATH "%builder_build_dir%"
call shellscriptlib :prepend_path INCLUDE "%builder_build_dir%\api"
call shellscriptlib :prepend_path LIB "%builder_build_dir%\api"

set SRC_DRV=%builder_src_drv%
set SRC_DIR=\%builder_src_dir:*\=%
set BUILD_DRV=%builder_build_drv%
set BUILD_DIR=\%builder_build_dir:*\=%

set BUILD_TYPE=
if "%builder_config%" == "release" set BUILD_TYPE=NODEBUG
if "%builder_config%" == "debug" set BUILD_TYPE=DEBUG

exit /b 0
