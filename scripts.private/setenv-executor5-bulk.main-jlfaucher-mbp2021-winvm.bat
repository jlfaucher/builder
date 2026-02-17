@echo off
if defined echo echo %echo%

:: File naming convention
:: setenv-%current%-%builder_hostname%.bat
::        executor5-bulk.main
::                  jlfaucher-mbp2021-winvm

:: Those variables must be defined before calling this script
if not defined builder_shared_dir echo builder_shared_dir is undefined & exit /b 1
if not defined builder_shared_drv echo builder_shared_drv is undefined & exit /b 1

:: Workaround because symbolic links on network drive not supported :-((((
:: These variables are used in setenv-oorexx.bat
set oorexx_oorexxshell=%builder_shared_dir%\executor\incubator\ooRexxShell
set oorexx_docmusings=%builder_shared_dir%\executor\incubator\DocMusings
set oorexx_sandboxjlf=%builder_shared_dir%\executor\sandbox\jlf
