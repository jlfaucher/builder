@echo off
if defined echo echo %echo%

:: File naming convention
:: setenv-%current%-%builder_system_arch%-%builder_hostname%.bat
::        oorexx    windows-x86_32        jlfaucher-mbp2021-winvm

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

:: Java 32-bit x86_32 (i586)
set JAVA_HOME="C:\Program Files (x86)\BellSoft\LibericaJDK-17-Full"
set JAVA_JVM_FOLDER=bin\server
set JAVA_HOME=%JAVA_HOME:"=%
call shellscriptlib :prepend_path PATH "%JAVA_HOME%\bin"
call shellscriptlib :prepend_path PATH "%JAVA_HOME%\%JAVA_JVM_FOLDER%"

:: NSIS
call shellscriptlib :prepend_path PATH "E:\nsis\Nsis_longStrings"

:: Home scripts
call shellscriptlib :prepend_path PATH "%HOST_DRIVE%\jlfaucher\software\oorexx"

:: windiff
call shellscriptlib :prepend_path PATH "E:\windiff"

if "%builder_target%" == "official" if "%builder_src_relative_path%" == "main\trunk" goto :bsf4oorexx_v850
goto :bsf4oorexx_v641
:bsf4oorexx_v850
    :: bsf4oorexx version 850 - all platforms - can't be used by Executor
    set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
    set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\BSF4ooRexx_install_v850-20240707-refresh\bsf4oorexx
    set BSF4OOREXX_JAR=bsf4ooRexx-v850-20240707-bin.jar
    call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_distribution
    goto :bsf4oorexx_done
:bsf4oorexx_v641
    :: bsf4oorexx version 641 - all platforms
    set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
    set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\BSF4ooRexx_install_v641-20221002-refresh\bsf4oorexx
    set BSF4OOREXX_JAR=bsf4ooRexx-v641-20221002-bin.jar
    call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_distribution
    goto :bsf4oorexx_done
:bsf4oorexx_done

:: bsf4oorexx portable (641) - windows only
::set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
::set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\bsf4oorexx_v641.20220131-Windows-amd64-portable-UNO-runtime
::set BSF4OOREXX_JAR=bsf4ooRexx-v641-20220131-bin.jar
::call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_distribution

:: bsf4oorexx SVN sources
::set BSF4OOREXX_HOME_DRIVE=%HOST_DRIVE%
::set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\svn\trunk
::call %builder_scripts_dir%.private\shellscriptlib-windows :declare_bsf4oorexx_svn

:: On this system, the default console code page is 437 (character set of the original IBM PC).
:: That brings troubles when you execute a script created with a Window application (like Notepad) which contains letters with accent.
:: Change the default code page of the console to 1252 ANSI Latin 1; Western European (Windows).
:: More details in the readme of ooRexxShell.
chcp 1252

exit /B 0
