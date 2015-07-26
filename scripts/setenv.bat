@echo off
if defined echo echo %echo%

:: Path to this script
set oorexx_scripts_dir="%~dp0"
set oorexx_scripts_dir=%oorexx_scripts_dir:&=^&%
set oorexx_scripts_dir=%oorexx_scripts_dir:"=%
:: Remove the last "\"
set oorexx_scripts_dir="%oorexx_scripts_dir:~0,-1%"
set oorexx_scripts_dir=%oorexx_scripts_dir:&=^&%
set oorexx_scripts_dir=%oorexx_scripts_dir:"=%

call "%oorexx_scripts_dir%\shellscriptlib" :prepend_path PATH "%oorexx_scripts_dir%"

set dir=%1
if not defined dir (
    echo Mandatory argument: path to config directory "build/<target[.branch]>\d1\d2\...\system\compiler\config\bitness"
    exit /b 1
)
set dir=%dir:&=^&%
set dir=%dir:"=%

if not exist "%dir%" (
    echo Directory not found
    exit /b 1
)
call shellscriptlib :absolute_path "%dir%"
set dir="%absolute_path%"
set dir=%dir:&=^&%
set dir=%dir:"=%
echo %dir%

set oorexx_config_dir=%dir%

call shellscriptlib :drive "%dir%"
set drv=%drive%

:: Iterate over each directory, from deeper to root.
:: If a script named setenv-<dir>.bat exists in the directory of scripts then execute it.
:: If a script named setenv-<dir>.bat exists in the directory of private scripts then execute it.
:loop
if "%dir%"=="%drv%" goto :endloop
call shellscriptlib :basename "%dir%"
set current=%basename%
echo ***current=%current%
set script="%oorexx_scripts_dir%\setenv-%current%.bat"
set script=%script:&=^&%
set script=%script:"=%
if exist "%script%" (
    echo Running "%script%"
    call "%script%" "%dir%"
    if errorlevel 1 exit /b 1
)
:: Private script
set script="%oorexx_scripts_dir%.private\setenv-%current%.bat"
set script=%script:&=^&%
set script=%script:"=%
if exist "%script%" (
    echo Running "%script%"
    call "%script%" "%dir%"
    if errorlevel 1 exit /b 1
)
call shellscriptlib :dirname "%dir%"
set dir="%dirname%"
set dir=%dir:&=^&%
set dir=%dir:"=%
goto :loop
:endloop

exit /b 0
