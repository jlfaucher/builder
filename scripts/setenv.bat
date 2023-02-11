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

:: THE CURRENT DIRECTORY IS USED AS BUILDER SHARED DIR
:: This is the directory which contains the source, shared by all the platforms (MacOs, Linux, Windows)
:: Assumptions : build, official, executor and executor5 are all in the same shared directory.
set builder_shared_dir=%cd%
set builder_shared_dir=%builder_shared_dir:&=^&%
set builder_shared_dir=%builder_shared_dir:"=%
call shellscriptlib :drive "%builder_shared_dir%"
set builder_shared_drv=%drive%

call shellscriptlib :dirname "%builder_scripts_dir%"
set builder_dir="%dirname%"
set builder_dir=%builder_dir:&=^&%
set builder_dir=%builder_dir:"=%

call shellscriptlib :drive "%builder_dir%"
set builder_dir_drv=%drive%
doskey cdbuilder=%builder_drv% ^& cd %builder_dir%

:: Remember: this argument can be a relative path
set dir=%1
if not defined dir (
    echo Mandatory argument: path to config directory "build/<target[.branch]>\d1\d2\...\system-arch\compiler\config"
    exit /b 1
)
set dir=%dir:&=^&%
set dir=%dir:"=%

:: debug, profiling, reldbg, release
call shellscriptlib :basename "%dir%"
set builder_config="%basename%"
set builder_config=%builder_config:&=^&%
set builder_config=%builder_config:"=%

if "%builder_config%" == "debug" goto config_ok
if "%builder_config%" == "profiling" goto config_ok
if "%builder_config%" == "reldbg" goto config_ok
if "%builder_config%" == "release" goto config_ok
echo Invalid config: %builder_config%
echo Expected: debug or profiling or reldbg or release
exit /b 1
:config_ok

if exist "%dir%" goto :directory_exists
:ask_create_directory
    set input=Y
    set /p input=Create directory (Y/n)?
    if "%input%" == "Y" goto :create_directory
    if "%input%" == "y" goto :create_directory
    if "%input%" == "N" echo Abort & exit /b 1
    if "%input%" == "n" echo Abort & exit /b 1
goto :ask_create_directory
:create_directory
mkdir "%dir%"
if not exist "%dir%" (
    echo Directory "%dir%" not found
    exit /b 1
)
:directory_exists

:: Fully qualified path
call shellscriptlib :absolute_path "%dir%"
set dir="%absolute_path%"
set dir=%dir:&=^&%
set dir=%dir:"=%
echo %dir%

:: KEEP THIS DECLARATION HERE, TO HAVE A FULLY QUALIFIED PATH
set builder_config_dir=%dir%

call shellscriptlib :drive "%dir%"
set drv=%drive%
set builder_config_drv=%drive%

:: Retrieve system from builder_config_dir
    :: <target[.branch]>/d1/d2/.../system-arch/compiler/config
    set current=%builder_config_dir%

    :: <target[.branch]>/d1/d2/.../system-arch/compiler
    call shellscriptlib :dirname "%current%"
    set current="%dirname%"
    set current=%current:&=^&%
    set current=%current:"=%

    :: <target[.branch]>/d1/d2/.../system-arch
    call shellscriptlib :dirname "%current%"
    set current="%dirname%"
    set current=%current:&=^&%
    set current=%current:"=%
    call shellscriptlib :basename "%current%"
    set builder_system_arch="%basename%"
    set builder_system_arch=%builder_system_arch:&=^&%
    set builder_system_arch=%builder_system_arch:"=%
::

:: Iterate over each directory, from deeper to root.
:: If a script named setenv-<dir>.bat exists in the directory of scripts then execute it.
:: If a script named setenv-<dir>-<system>-<computername>.bat exists in the directory of private scripts then execute it.
:: If a script named setenv-<dir>.bat exists in the current directory then execute it.
:loop
    if "%dir%"=="%drv%" goto :endloop
    call shellscriptlib :basename "%dir%"
    set current=%basename%
    echo [current=%current%]

    :: Script common to all machines
    set script="%builder_scripts_dir%\setenv-%current%.bat"
    set script=%script:&=^&%
    set script=%script:"=%
    if exist "%script%" (
        echo Running "%script%"
        call "%script%" "%dir%"
        if errorlevel 1 exit /b 1
    )

    :: Private script
    set script="%builder_scripts_dir%.private\setenv-%current%-%builder_system_arch%-%COMPUTERNAME%.bat"
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
