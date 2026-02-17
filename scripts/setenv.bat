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
:: Assumptions : build, official, executor, executor5 and executor5-bulk are all in the same shared directory.
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
doskey cdbuilder=%builder_dir_drv% ^& cd %builder_dir%

:: Remember: this argument can be a relative path
set dir=%1
if not defined dir (
    echo Mandatory argument: path to config directory "build/<target[.branch]>\d1\d2\...\system-arch\compiler\config"
    exit /b 1
)
set dir=%dir:&=^&%
set dir=%dir:"=%

:: config
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

:: system-arch
    :: <target[.branch]>/d1/d2/.../system-arch/compiler/config
    set current=%dir%

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

:: Split system-arch into system and arch
for /F "tokens=1,2 delims=-" %%i in ("%builder_system_arch%") do (
set builder_system=%%i
set builder_arch=%%j
)

:: Check system
if "%builder_system%" == "windows" goto :builder_system_ok
echo Invalid system "%builder_system%"
echo Expected: windows
exit /b 1
:builder_system_ok

:: Check arch
if "%builder_arch%" == "x86_32" goto :builder_arch_ok
if "%builder_arch%" == "x86_64" goto :builder_arch_ok
if "%builder_arch%" == "arm32" goto :builder_arch_ok
if "%builder_arch%" == "arm64" goto :builder_arch_ok
echo Invalid architecture "%builder_arch%"
echo Expected: x86_32 or x86_64 or arm32 or arm64
exit /b 1
:builder_arch_ok

:: Check system-arch
if "%builder_system_arch%" == "windows-x86_32" goto :builder_system_arch_ok
if "%builder_system_arch%" == "windows-x86_64" goto :builder_system_arch_ok
if "%builder_system_arch%" == "windows-arm32" goto :builder_system_arch_ok
if "%builder_system_arch%" == "windows-arm64" goto :builder_system_arch_ok
echo Unsupported system-architecture: %builder_system_arch%
echo Expected:"
echo windows-x86_32
echo windows-x86_64
echo windows-arm32
echo windows-arm64
exit /b 1
:builder_system_arch_ok

if exist "%dir%" goto :directory_exists
echo %dir%
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

:: KEEP THIS DECLARATION HERE, TO HAVE A FULLY QUALIFIED PATH
set builder_config_dir=%dir%

call shellscriptlib :drive "%dir%"
set drv=%drive%
set builder_config_drv=%drive%

for /F "usebackq" %%i in (`"hostname 2>nul"`) do set builder_hostname=%%i
:: Fallback: COMPUTERNAME is the hostname in upper case.
if not defined builder_hostname set builder_hostname=%COMPUTERNAME%

:: 2023.07.18: add prefix "builder_private_" to avoid accidental overwriting
:: 2024.06.02: better prefix "builder_iteration_"
set builder_iteration_dir=%dir%

:: Iterate over each directory, from deeper to root.
:: If a script named setenv-<dir>.bat exists in the directory of scripts then execute it.
:: If a script named setenv-<dir>-<system-arch>-<computername>.bat exists in the directory of private scripts then execute it.
:: If a script named setenv-<dir>-<computername>.bat exists in the directory of private scripts then execute it.
:loop
    if "%builder_iteration_dir%"=="%drv%" goto :endloop
    call shellscriptlib :basename "%builder_iteration_dir%"
    set builder_iteration_current=%basename%
    echo [builder_iteration_current=%builder_iteration_current%]

    :: Script common to all machines
    set script="%builder_scripts_dir%\setenv-%builder_iteration_current%.bat"
    set script=%script:&=^&%
    set script=%script:"=%
    if exist "%script%" (
        echo Running "%script%"
        call "%script%" "%builder_iteration_dir%"
        if errorlevel 1 exit /b 1
    )

    :: Private script builder_system_arch + builder_hostname
    set script="%builder_scripts_dir%.private\setenv-%builder_iteration_current%-%builder_system_arch%-%builder_hostname%.bat"
    set script=%script:&=^&%
    set script=%script:"=%
    if exist "%script%" (
        echo Running "%script%"
        call "%script%" "%builder_iteration_dir%"
        if errorlevel 1 exit /b 1
    )

    :: Private script builder_hostname
    set script="%builder_scripts_dir%.private\setenv-%builder_iteration_current%-%builder_hostname%.bat"
    set script=%script:&=^&%
    set script=%script:"=%
    if exist "%script%" (
        echo Running "%script%"
        call "%script%" "%builder_iteration_dir%"
        if errorlevel 1 exit /b 1
    )

    call shellscriptlib :dirname "%builder_iteration_dir%"
    set builder_iteration_dir="%dirname%"
    set builder_iteration_dir=%builder_iteration_dir:&=^&%
    set builder_iteration_dir=%builder_iteration_dir:"=%
    goto :loop
:endloop

exit /b 0
