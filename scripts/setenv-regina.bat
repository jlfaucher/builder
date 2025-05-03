@echo off
if defined echo echo %echo%

:: Those variables must be defined before calling this script
:: (can be empty, don''t test it) if not defined builder_branch echo builder_branch is undefined & exit /b 1
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

set regina_doc_dir=%builder_shared_dir%\doc
set regina_doc_drv=%builder_shared_drv%

:: Needed by makefile.win64.vc
set REGINA_SRCDIR=%builder_src_dir%
set REGINA_DOCDIR=%regina_doc_dir%
set TOPDIR=%builder_delivery_dir%

doskey cdregina=%builder_shared_drv% ^& cd %builder_shared_dir%
doskey cdshared=%builder_shared_drv% ^& cd %builder_shared_dir%

doskey cdreginalocal=%builder_local_drv% ^& cd %builder_local_dir%
doskey cdlocal=%builder_local_drv% ^& cd %builder_local_dir%

doskey cdofficial=%builder_shared_drv% ^& cd %builder_shared_dir%\official
doskey cdofficial_delivery=%builder_shared_drv% ^& cd %builder_shared_dir%\official_delivery
doskey cd391=%builder_shared_drv% ^& cd %builder_shared_dir%\official_delivery\3.9.1
doskey cd392=%builder_shared_drv% ^& cd %builder_shared_dir%\official_delivery\3.9.2
doskey cd393=%builder_shared_drv% ^& cd %builder_shared_dir%\official_delivery\3.9.3
doskey cd394=%builder_shared_drv% ^& cd %builder_shared_dir%\official_delivery\3.9.4
doskey cd395=%builder_shared_drv% ^& cd %builder_shared_dir%\official_delivery\3.9.5

doskey cdtrunk=%builder_src_drv% ^& cd %builder_src_dir%
doskey cdsrc=%builder_src_drv% ^& cd %builder_src_dir%

doskey cdconfig=%builder_config_drv% ^& cd %builder_config_dir%
doskey cdbuild=%builder_build_drv% ^& cd %builder_build_dir%
doskey cddelivery=%builder_delivery_drv% ^& cd %builder_delivery_dir%

doskey cddoc=%regina_doc_drv% ^& cd %regina_doc_dir%
doskey cddocs=%regina_doc_drv% ^& cd %regina_doc_dir%

:: Title of console
title Regina %builder_target% %builder_branch% %builder_src_relative_path% %builder_config% %builder_system_arch%

call shellscriptlib :prepend_path PATH "%builder_shared_dir%\scripts"

echo Setting environment for building with Regina
call shellscriptlib :prepend_path INCLUDE "%builder_delivery_dir%\include"
call shellscriptlib :prepend_path LIB "%builder_delivery_dir%\lib"

echo Setting environment for executing Regina
call shellscriptlib :prepend_path PATH "%builder_delivery_dir%\bin"
:: no procedure for delivery, run from build
call shellscriptlib :prepend_path PATH "%builder_build_dir%"
