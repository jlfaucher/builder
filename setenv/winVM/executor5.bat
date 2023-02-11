@echo off

:: %1 is mandatory: debug or profiling or reldbg or release

set builder_local_dir=E:\local\rexxlocal\oorexx
set builder_local_drv=E:

set ARCH=unknown
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set ARCH=x86_64
if "%PROCESSOR_ARCHITECTURE%" == "ARM64" set ARCH=arm64

if not exist "%builder_local_dir%" (echo Directory %builder_local_dir% not found. & exit /B 1)
%builder_local_drv%
cd "%builder_local_dir%"
y:
cd \local\rexx\oorexx
call ..\builder\scripts\setenv e:build\executor5.master\main\trunk\windows-%ARCH%\cl\%1
