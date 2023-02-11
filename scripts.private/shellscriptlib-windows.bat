::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Library of shell-script procedures for Windows.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


@echo off
:: Special management of the echo's state :
:: In this file, the fact of echoing is controled by the variable %shellscriptlib.echo%.
:: Indeed, you may want to debug your own script by setting echo=on, but not debug this file...
:: If you really want to debug this file, then set shellscriptlib.echo=on.
@if defined shellscriptlib.echo echo %shellscriptlib.echo%

:: Must undefine errorlevel to be sure to catch the real errorlevel.
@set errorlevel=
call :dispatch %*
set last_errorlevel=%errorlevel%

:: Now we are leaving this file, we come back under the control of the variable %echo%.
@if defined echo echo %echo%

@exit /B %last_errorlevel%


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:dispatch

@set proc=%1
@shift

@if defined proc goto %proc%

@echo This is a library of shell-script procedures.
@echo Usage :
@echo     shellscriptlib :declare_bsf4oorexx_distribution
@echo     shellscriptlib declare_bsf4oorexx_svn
@goto :eof



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:declare_bsf4oorexx_distribution
echo Setting environment for bsf4oorexx

if exist "%BSF4OOREXX_HOME%\%BSF4OOREXX_JAR%" call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\%BSF4OOREXX_JAR%"
if exist "%BSF4OOREXX_HOME%\lib\%BSF4OOREXX_JAR%" call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\lib\%BSF4OOREXX_JAR%"
if exist "%BSF4OOREXX_HOME%\jars\%BSF4OOREXX_JAR%" call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\%BSF4OOREXX_JAR%"

call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%"
if exist "%BSF4OOREXX_HOME%\bin" call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bin"

:: Equivalent of LD_LIBRARY_PATH
if exist "%BSF4OOREXX_HOME%\lib\%builder_system_arch%" call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\lib\%builder_system_arch%"
if exist "%BSF4OOREXX_HOME%\lib" call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\lib"

doskey cdbsf=%BSF4OOREXX_HOME_DRIVE% ^& cd %BSF4OOREXX_HOME%
doskey cdbsf4oorexx=%BSF4OOREXX_HOME_DRIVE% ^& cd %BSF4OOREXX_HOME%

goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:declare_bsf4oorexx_svn
echo Setting environment for bsf4oorexx svn
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\janino\commons-compiler.jar"
call shellscriptlib :prepend_path CLASSPATH "%BSF4OOREXX_HOME%\jars\janino\janino.jar"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bsf4oorexx.dev\bin"
call shellscriptlib :prepend_path PATH "%BSF4OOREXX_HOME%\bsf4oorexx.dev\source_cc\build\%builder_system_arch%\%builder_compiler%\%builder_config%"
doskey cdbsf=%BSF4OOREXX_HOME_DRIVE% ^& cd %BSF4OOREXX_HOME%
doskey cdbsf4oorexx=%BSF4OOREXX_HOME_DRIVE% ^& cd %BSF4OOREXX_HOME%
goto :eof
