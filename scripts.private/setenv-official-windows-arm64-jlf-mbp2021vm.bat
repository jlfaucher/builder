@echo off
if defined echo echo %echo%

:: File naming convention
:: setenv-oorexx-%builder_system_arch%-%COMPUTERNAME%.bat
::               windows-arm64         jlf-mbp2021vm

:: Those variables must be defined before calling this script
if not defined builder_shared_dir echo builder_shared_dir is undefined & exit /b 1
if not defined builder_shared_drv echo builder_shared_drv is undefined & exit /b 1

:: Workaround because symbolic links not supported :-((((
:: These variables are used in setenv-oorexx.bat
set oorexx_oorexxshell=%builder_shared_dir%\executor\incubator\ooRexxShell
set oorexx_docmusings=%builder_shared_dir%\executor\incubator\DocMusings
set oorexx_sandboxjlf=%builder_shared_dir%\executor\sandbox\jlf
