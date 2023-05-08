@echo off
if defined echo echo %echo%

:: File naming convention
:: setenv-%current%-%builder_hostname%.bat
::        executor.master
::                  jlf-mbp2021vm

:: Those variables must be defined before calling this script
if not defined builder_shared_dir echo builder_shared_dir is undefined & exit /b 1
if not defined builder_shared_drv echo builder_shared_drv is undefined & exit /b 1

:: Workaround because symbolic links not supported :-((((
:: In order to find the package regex.cls, must add the official incubator in PATH
set oorexx_official_incubator=%builder_shared_dir%\official\incubator
set oorexx_official_incubator_drv=%builder_shared_drv%
call shellscriptlib :prepend_path PATH "%oorexx_official_incubator%"
