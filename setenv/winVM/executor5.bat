@echo off

:: %1 is mandatory: debug or profiling or reldbg or release
:: %2 is optional: architecture x86_32 or X86_64 or arm32 or arm64 (default is the processor architecture)

set builder_local_dir=E:\local\rexxlocal\oorexx
set builder_local_drv=E:
if not exist "%builder_local_dir%" (echo Directory %builder_local_dir% not found. & exit /B 1)
%builder_local_drv%
cd "%builder_local_dir%"

set ARCH=%2
if not defined ARCH (
if "%PROCESSOR_ARCHITECTURE%" == "X86"   set ARCH=x86_32
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" set ARCH=x86_64
if "%PROCESSOR_ARCHITECTURE%" == "ARM64" set ARCH=arm64
)
if not defined ARCH set ARCH=unknown

y:
cd \local\rexx\oorexx
call ..\builder\scripts\setenv.bat %builder_local_dir%\build\executor5.master\main\trunk\windows-%ARCH%\cl\%1
