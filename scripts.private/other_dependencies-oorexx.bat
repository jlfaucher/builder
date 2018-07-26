@echo off
if defined echo echo %echo%


if "%COMPUTERNAME%" == "WIN-7RUPB0TOBV1" goto :WIN-7RUPB0TOBV1
if "%COMPUTERNAME%" == "CSCFRAAH783788" goto :CSCFRAAH783788

exit /B 0


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:WIN-7RUPB0TOBV1

:: ooRexx build utilities
call shellscriptlib :prepend_path PATH "y:\Local\rexx\oorexx\official\build-utilities\trunk\platform\windows\bin"

:: Xalan-C
call shellscriptlib :prepend_path PATH "E:\xalan-c"

:: xsltproc
call shellscriptlib :prepend_path PATH "Y:\Local\XmlToolSet\xsltproc\bin"

:: Batik
set BATIK_ROOT=Y:\Local\XmlToolSet\batik-1.7

:: Git
call shellscriptlib :prepend_path PATH "C:\Program Files\Git\bin"

:: Java
if "%builder_bitness%" == "32" (
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre1.8.0_144\bin"
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre1.8.0_144\bin\client"
set JAVA_HOME="C:\Program Files (x86)\Java\jdk1.8.0_144"
) else (
call shellscriptlib :prepend_path PATH "C:\Program Files\Java\jre1.8.0_144\bin"
call shellscriptlib :prepend_path PATH "C:\Program Files\Java\jre1.8.0_144\bin\server"
set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_144"
)
set JAVA_HOME=%JAVA_HOME:"=%
call shellscriptlib :prepend_path PATH "%JAVA_HOME%\bin"

:: GCI
call shellscriptlib :prepend_path PATH "Y:\Local\rexx\GCI\gci-source.1.1\build\%builder_system%\%builder_compiler%\%builder_config%\%builder_bitness%"

:: NSIS
call shellscriptlib :prepend_path PATH "E:\nsis\Nsis_longStrings"

:: Dropbox scripts
call shellscriptlib :prepend_path PATH "Z:\jlfaucher\Dropbox\software\oorexx"

:: windiff
call shellscriptlib :prepend_path PATH "E:\windiff"

:: cmake
call shellscriptlib :prepend_path PATH "C:\Program Files\CMake\bin"

::set BSF4OOREXX_HOME=Y:\Local\local\rexx\bsf4oorexx\BSF4ooRexx_install_v452-20150825-beta\bsf4oorexx
::set BSF4OOREXX_JAR=bsf4ooRexx-v452-20150825-bin.jar
::call :declare_bsf4oorexx_distribution

set BSF4OOREXX_HOME=Y:\Local\local\rexx\bsf4oorexx\svn\trunk
call :declare_bsf4oorexx_svn

:: On this system, the default console code page is the OEMCP (437)
:: That brings troubles when you execute a command which contains letters with accent.
:: Change the default code page of the console to ACP (for european users like me : 1252).
:: More details in the readme of ooRexxShell.
chcp 1252

exit /B 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CSCFRAAH783788

:: TEMPORARY workaround: "mt.exe" not found after installation of SDK 10
set PATH=C:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x64;%PATH%

:: ooRexx build utilities
call shellscriptlib :prepend_path PATH "C:\jlf\local\rexx\oorexx\official\build-utilities\trunk\platform\windows\bin"

:: Xalan-C
call shellscriptlib :prepend_path PATH "C:\jlf\local\xalan-c"

:: xsltproc
call shellscriptlib :prepend_path PATH "C:\MT Toolkit\bin\xmlsoft.org\bin"

:: Batik
set BATIK_ROOT=C:\jlf\local\Batik\batik-1.8

:: Git
call shellscriptlib :prepend_path PATH "C:\Program Files\Git\bin"

:: Java
if "%builder_bitness%" == "32" (
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre1.8.0_131\bin"
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre1.8.0_131\bin\client"
set JAVA_HOME="C:\Program Files (x86)\Java\jdk1.8.0_74"
) else (
call shellscriptlib :prepend_path PATH "C:\Program Files\Java\jre1.8.0_131\bin"
call shellscriptlib :prepend_path PATH "C:\Program Files\Java\jre1.8.0_131\bin\server"
set JAVA_HOME="C:\Program Files\Java\jdk1.8.0_74"
)
set JAVA_HOME=%JAVA_HOME:"=%
call shellscriptlib :prepend_path PATH "%JAVA_HOME%\bin"

:: GCI
call shellscriptlib :prepend_path PATH "C:\jlf\local\rexx\GCI\gci-source.1.1\build\%builder_system%\%builder_compiler%\%builder_config%\%builder_bitness%"

:: NSIS
call shellscriptlib :prepend_path PATH "C:\jlf\local\nsis\Nsis_longStrings"

:: Dropbox scripts
call shellscriptlib :prepend_path PATH "C:\Users\JFaucher.EMEA\Dropbox\software\oorexx"

:: csdiff
call shellscriptlib :prepend_path PATH "C:\jlf\local\csdiff"

:: windiff
call shellscriptlib :prepend_path PATH "C:\jlf\local\windiff"

:: cmake
call shellscriptlib :prepend_path PATH "C:\Program Files\CMake\bin"

::set BSF4OOREXX_HOME=C:\jlf\local\rexx\bsf4oorexx\BSF4ooRexx_install_v452-20150825-beta
::set BSF4OOREXX_JAR=bsf4ooRexx-v452-20150825-bin.jar
::call :declare_bsf4oorexx_distribution

set BSF4OOREXX_HOME=C:\jlf\local\rexx\bsf4oorexx\svn\trunk
call :declare_bsf4oorexx_svn

:: unix-like
call shellscriptlib :prepend_path PATH "C:\MT Toolkit\bin\cygwin\bin"
doskey rm=rm -i $*
doskey ll=ls -lap $*
doskey ls=ls -ap $*
doskey mv=mv -i $*
doskey cp=cp -i $*

:: On this system, the default console code page is the OEMCP (437)
:: That brings troubles when you execute a command which contains letters with accent.
:: Change the default code page of the console to ACP (for european users like me : 1252).
:: More details in the readme of ooRexxShell.
chcp 1252

exit /B 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:declare_bsf4oorexx_distribution
echo "Setting environment for bsf4oorexx"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\%BSF4OOREXX_JAR%"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\install\%builder_bitness%"
goto :eof

:declare_bsf4oorexx_svn
echo "Setting environment for bsf4oorexx svn"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\janino\commons-compiler.jar"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\janino\janino.jar"

call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bsf4oorexx.dev\bin"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bsf4oorexx.dev\source_cc\build\%builder_system%\%builder_compiler%\%builder_config%\%builder_bitness%"
goto :eof
