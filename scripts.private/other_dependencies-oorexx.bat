@echo off
if defined echo echo %echo%


if "%COMPUTERNAME%" == "WIN-7RUPB0TOBV1" goto :WIN-7RUPB0TOBV1
if "%COMPUTERNAME%" == "CSCCHAAE667748" goto :CSCCHAAE667748
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
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Git\bin"

:: Java 64 bits
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre1.8.0_45\bin"
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre1.8.0_45\bin\client"

:: GCI
call shellscriptlib :prepend_path PATH "Y:\Local\rexx\GCI\gci-source.1.1\win%builder_bitness%"

:: NSIS
call shellscriptlib :prepend_path PATH "E:\nsis\Nsis_longStrings"

:: Dropbox scripts
call shellscriptlib :prepend_path PATH "Z:\jlfaucher\Dropbox\oorexx"

:: windiff
call shellscriptlib :prepend_path PATH "E:\windiff"

::echo "Setting environment for bsf4oorexx"
::. /local/rexx/bsf4oorexx/setenv.sh

exit /B 0


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CSCCHAAE667748

:: ooRexx build utilities
call shellscriptlib :prepend_path PATH "C:\jlf\local\rexx\oorexx\official\build-utilities\trunk\platform\windows\bin"

:: Xalan-C
call shellscriptlib :prepend_path PATH "C:\jlf\local\xalan-c"

:: xsltproc
call shellscriptlib :prepend_path PATH "C:\MT Toolkit\bin\xmlsoft.org\bin"

:: Batik
set BATIK_ROOT=C:\jlf\Downloads\Software\Batik\batik-1.8

:: Git
call shellscriptlib :prepend_path PATH "c:\Program Files (x86)\Git\bin"

:: Java 32 bits
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre7\bin"
call shellscriptlib :prepend_path PATH "C:\Program Files (x86)\Java\jre7\bin\client"

:: GCI
call shellscriptlib :prepend_path PATH "C:\jlf\local\rexx\GCI\gci-sources.1.1\win%builder_bitness%"

:: NSIS
call shellscriptlib :prepend_path PATH "C:\jlf\local\nsis\Nsis_longStrings"

:: Dropbox scripts
call shellscriptlib :prepend_path PATH "C:\Users\JFaucher\Dropbox\oorexx"

:: csdiff
call shellscriptlib :prepend_path PATH "C:\jlf\local\csdiff"

:: windiff
call shellscriptlib :prepend_path PATH "C:\jlf\local\windiff"

:: unix-like
call shellscriptlib :prepend_path PATH "C:\MT Toolkit\bin\cygwin\bin"
doskey rm=rm -i $*
doskey ll=ls -lap $*
doskey ls=ls -ap $*
doskey mv=mv -i $*
doskey cp=cp -i $*
