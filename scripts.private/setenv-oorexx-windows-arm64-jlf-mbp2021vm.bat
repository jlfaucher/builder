@echo off
if defined echo echo %echo%

:: File naming convention
:: setenv-oorexx-%builder_system_arch%-%COMPUTERNAME%.bat
::               windows-arm64         jlf-mbp2021vm

:: Shared folders parameterized in PARALLELS:
:: Y: is /Users/Shared

set HOST_DRIVE=Y:

:: ooRexx build utilities
call shellscriptlib :prepend_path PATH "%HOST_DRIVE%\local\rexx\oorexx\official\build-utilities\trunk\platform\windows\bin"

:: Xalan-C
call shellscriptlib :prepend_path PATH "E:\xalan-c"

:: xsltproc
call shellscriptlib :prepend_path PATH "%HOST_DRIVE%\local\XmlToolSet\xsltproc\bin"

:: Batik
set BATIK_ROOT=%HOST_DRIVE%\local\XmlToolSet\batik-1.13
set BATIK_RASTERIZER_JAR=%BATIK_ROOT%\batik-rasterizer-1.13.jar

:: Git
:: Provided with Visual Studio
:: call shellscriptlib :prepend_path PATH "C:\Program Files\Git\bin"

:: Java
if "%builder_bitness%" == "32" (
set JAVA_HOME="32 bits no more available"
set JAVA_JVM_FOLDER=
) else (
set JAVA_HOME="C:\Program Files (Arm)\BellSoft\LibericaJDK-17-Full"
set JAVA_JVM_FOLDER=bin\server
)
set JAVA_HOME=%JAVA_HOME:"=%
call shellscriptlib :prepend_path PATH "%JAVA_HOME%\bin"
call shellscriptlib :prepend_path PATH "%JAVA_HOME%\%JAVA_JVM_FOLDER%"

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

:: NSIS
call shellscriptlib :prepend_path PATH "E:\nsis\Nsis_longStrings"

:: Dropbox scripts
call shellscriptlib :prepend_path PATH "%HOST_DRIVE%\jlfaucher\Dropbox\software\oorexx"

:: windiff
call shellscriptlib :prepend_path PATH "E:\windiff"

:: cmake
:: Provided with Visual Studio
:: call shellscriptlib :prepend_path PATH "C:\Program Files\CMake\bin"

:: Version 641 - all platforms
if "%builder_target%" == "executor" (
    set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
    set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\BSF4ooRexx_install_v641-20220131-ga\bsf4oorexx
    set BSF4OOREXX_JAR=bsf4ooRexx-v641-20220131-bin.jar
    call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_distribution
)

:: Version 850 - all platforms - can't be used by Executor
if not "%builder_target%" == "executor" (
    set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
    set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\BSF4ooRexx_install_v850-20230109-beta\bsf4oorexx
    set BSF4OOREXX_JAR=bsf4ooRexx-v850-20230109-bin.jar
    call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_distribution
)

:: Portable (641) - windows only
::set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
::set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\bsf4oorexx_v641.20220131-Windows-amd64-portable-UNO-runtime
::set BSF4OOREXX_JAR=bsf4ooRexx-v641-20220131-bin.jar
::call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_distribution

:: SVN sources
::set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
::set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\svn\trunk
::call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_svn

:: On this system, the default console code page is 437 (character set of the original IBM PC).
:: That brings troubles when you execute a script created with a Window application (like Notepad) which contains letters with accent.
:: Change the default code page of the console to 1252 ANSI Latin 1; Western European (Windows).
:: More details in the readme of ooRexxShell.
chcp 1252

exit /B 0
