@echo off
if defined echo echo %echo%

:: Path to this script
set builder_scripts_dir="%~dp0"
set builder_scripts_dir=%builder_scripts_dir:&=^&%
set builder_scripts_dir=%builder_scripts_dir:"=%
:: Remove the last "\"
set builder_scripts_dir="%builder_scripts_dir:~0,-1%"
set builder_scripts_dir=%builder_scripts_dir:&=^&%
set builder_scripts_dir=%builder_scripts_dir:"=%

call "%builder_scripts_dir%\shellscriptlib" :prepend_path PATH "%builder_scripts_dir%"

call shellscriptlib :dirname "%builder_scripts_dir%"
set builder_dir="%dirname%"
set builder_dir=%builder_dir:&=^&%
set builder_dir=%builder_dir:"=%

call shellscriptlib :drive "%builder_dir%"
set builder_dir_drv=%drive%
doskey cdbuilder=%builder_drv% ^& cd %builder_dir%

set dir=%1
if not defined dir (
    echo Mandatory argument: path to config directory "build/<target[.branch]>\d1\d2\...\system\compiler\config\bitness"
    exit /b 1
)
set dir=%dir:&=^&%
set dir=%dir:"=%

if exist "%dir%" goto :directory_exists
:ask_create_directory
    set input=Y
    set /p input=Create directory (Y/n)?
    if %input% == "Y" goto :create_directory
    if %input% == "y" goto :create_directory
    if %input% == "N" echo Abort & exit /b 1
    if %input% == "n" echo Abort & exit /b 1
goto :ask_create_directory
:create_directory
mkdir "%dir%"
if not exist "%dir%" (
    echo Directory "%dir%" not found
    exit /b 1
)
:directory_exists
call shellscriptlib :absolute_path "%dir%"
set dir="%absolute_path%"
set dir=%dir:&=^&%
set dir=%dir:"=%
echo %dir%

set builder_config_dir=%dir%

call shellscriptlib :drive "%dir%"
set drv=%drive%

:: Iterate over each directory, from deeper to root.
:: If a script named setenv-<dir>.bat exists in the directory of scripts then execute it.
:: If a script named setenv-<dir>.bat exists in the directory of private scripts then execute it.
:: If a script named setenv-<dir>.bat exists in the current directory then execute it.
:loop
if "%dir%"=="%drv%" goto :endloop
call shellscriptlib :basename "%dir%"
set current=%basename%
echo [current=%current%]
set script="%builder_scripts_dir%\setenv-%current%.bat"
set script=%script:&=^&%
set script=%script:"=%
if exist "%script%" (
    echo Running "%script%"
    call "%script%" "%dir%"
    if errorlevel 1 exit /b 1
)
:: Private script
set script="%builder_scripts_dir%.private\setenv-%current%.bat"
set script=%script:&=^&%
set script=%script:"=%
if exist "%script%" (
    echo Running "%script%"
    call "%script%" "%dir%"
    if errorlevel 1 exit /b 1
)
:: Script in current dirrectory
set script="%dir%\setenv-%current%.bat"
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
