@echo off
if defined echo echo %echo%

:: Those variables must be defined before calling this script
if not defined builder_config echo builder_config is undefined & exit /b 1
if not defined builder_compiler echo builder_compiler is undefined & exit /b 1
if not defined builder_shared_dir echo builder_shared_dir is undefined & exit /b 1
if not defined builder_shared_drv echo builder_shared_drv is undefined & exit /b 1
if not defined builder_system_arch echo builder_system_arch is undefined & exit /b 1

:: GCI
echo Setting environment for GCI
call shellscriptlib :dirname "%builder_shared_dir%"
set GCI_HOME="%dirname%\rexx-gci"
set GCI_HOME=%GCI_HOME:&=^&%
set GCI_HOME=%GCI_HOME:"=%
set GCI_LIBRARY_PATH=%GCI_HOME%\build\%builder_system_arch%\%builder_compiler%\%builder_config%
call shellscriptlib :prepend_path PATH "%GCI_LIBRARY_PATH%"
call shellscriptlib :drive "%GCI_HOME%"
set GCI_HOME_DRIVE=%drive%
doskey cdgci=%GCI_HOME_DRIVE% ^& cd %GCI_HOME%
