@echo off
if defined echo echo %echo%

:: File naming convention
:: other_dependencies-oorexx-%builder_system%-%COMPUTERNAME%.bat
::                           win              WIN-7RUPB0TOBV1

:: Shared folders parameterized in VMWARE:
:: name "jlfaucher" folder "jlfaucher" Read & Write
:: name "local" folder "local" Read & Write

:: X: is the shared folders root of VMWARE mounted with:  if not exist x: net use x: "\\vmware-host\Shared Folders"
:: Y: is the SMBD folder                   mounted with:  if not exist y: net use Y: \\jlfaucher.local\Local1
:: Y: seems faster than X:
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

:: Zig
call e:\local\zig\setenv-0.9.1.bat

:: Git
call shellscriptlib :prepend_path PATH "C:\Program Files\Git\bin"

:: Java
if "%builder_bitness%" == "32" (
set JAVA_HOME="32 bits no more available"
set JAVA_JVM_FOLDER=
) else (
set JAVA_HOME="C:\Program Files\BellSoft\LibericaJDK-17-Full"
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
set GCI_LIBRARY_PATH=%GCI_HOME%\build\%builder_system%\%builder_compiler%\%builder_config%\%builder_bitness%
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
call shellscriptlib :prepend_path PATH "C:\Program Files\CMake\bin"

set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\BSF4ooRexx_install_v641-20220131-ga\bsf4oorexx
set BSF4OOREXX_JAR=bsf4ooRexx-v641-20220131-bin.jar
call :declare_bsf4oorexx_distribution

::set BSF4OOREXX_HOME=%HOST_DRIVE%\local\rexx\bsf4oorexx\svn\trunk
::call :declare_bsf4oorexx_svn

:: On this system, the default console code page is the OEMCP (437)
:: That brings troubles when you execute a command which contains letters with accent.
:: Change the default code page of the console to ACP (for european users like me : 1252).
:: More details in the readme of ooRexxShell.
chcp 1252

exit /B 0

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:declare_bsf4oorexx_distribution
echo Setting environment for bsf4oorexx
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\%BSF4OOREXX_JAR%"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%"
:: For the next line to work, you must copy manually the dynamic librairies from install/lib to install\32 and install\64, and rename them by removing the end of the filename
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\install\%builder_bitness%"
goto :eof

:declare_bsf4oorexx_svn
echo Setting environment for bsf4oorexx svn
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\janino\commons-compiler.jar"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\janino\janino.jar"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bsf4oorexx.dev\bin"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bsf4oorexx.dev\source_cc\build\%builder_system%\%builder_compiler%\%builder_config%\%builder_bitness%"
goto :eof
