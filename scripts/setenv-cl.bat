@echo off
if defined echo echo %echo%

if "%builder_bitness%" == "32" goto bitness_ok
if "%builder_bitness%" == "64" goto bitness_ok
echo Invalid builder_bitness : "%builder_bitness%" & exit /b 1
:bitness_ok

:: The value to pass to vcvars, depending on ProcessorArchitecture and builderBitness
set x86_32=x86
set x86_64=x86_amd64
set amd64_32=amd64_x86
set amd64_64=amd64
set compiler=%PROCESSOR_ARCHITECTURE%_%builder_bitness%
if not defined %compiler%  goto error
call set compiler_option=%%%compiler%%%


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Visual Studio 2015 (internal version: 14.O, cl version 19.00 ==> _MSC_VER 1900)

:cl_14
if 14 GTR %CL_MAX% goto cl_12
set cl_dir=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC
if exist "%cl_dir%" (
    call "%cl_dir%\vcvarsall.bat" %compiler_option%
    if errorlevel 1 goto error
    exit /b 0
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Visual Studio 2013 (internal version: 12.0, cl version 18.00 ==> _MSC_VER 1800)

:cl_12
if 12 GTR %CL_MAX% goto cl_11
set cl_dir=C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC
if exist "%cl_dir%" (
    call "%cl_dir%\vcvarsall.bat" %compiler_option%
    if errorlevel 1 goto error
    exit /b 0
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Visual Studio 2012 (internal version: 11.0, cl version 17.00 ==> _MSC_VER 1700)

:cl_11
if 11 GTR %CL_MAX%  echo No version for CL_MAX=%CL_MAX% & goto :error
:: VS 11.0 : x86 | amd64 | arm | x86_amd64 | x86_arm
:: Always use the 32-bit command line, because  not sure that the 64-bit command line is installed
set amd64_32=x86
set amd64_64=x86_amd64
call set compiler_option=%%%compiler%%%
set cl_dir=C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC
if exist "%cl_dir%" (
    call "%cl_dir%\vcvarsall.bat" %compiler_option%
    if errorlevel 1 goto error
    exit /b 0
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:error
echo Could not initialize the Microsoft cl compiler.
exit /B 1


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
DOCUMENTATION
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Visual Studio includes
32-bit, x86-hosted, native and cross compilers for x86, x64, and ARM targets.
When Visual Studio is installed on a 64-bit Windows operating system,
32-bit, x86-hosted native and cross compilers, and also
64-bit, x64-hosted native and cross compilers,
are installed for each target (x86, x64, and ARM).
The 32-bit and 64-bit compilers for each target generate identical code,
but the 64-bit compilers support more memory for precompiled header symbols
and the Whole Program Optimization (/GL, /LTCG) options.

C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat
if /i %1 == x86       goto x86
if /i %1 == amd64     goto amd64
if /i %1 == x64       goto amd64
if /i %1 == arm       goto arm
if /i %1 == x86_arm   goto x86_arm
if /i %1 == x86_amd64 goto x86_amd64
if /i %1 == amd64_x86 goto amd64_x86
if /i %1 == amd64_arm goto amd64_arm

C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat
if /i %1 == x86       goto x86          32-bit command-line builds that target x86 platforms
if /i %1 == amd64     goto amd64        64-bit command-line builds that target x64 platforms
if /i %1 == x64       goto amd64        idem
if /i %1 == arm       goto arm          ?
if /i %1 == x86_arm   goto x86_arm      32-bit command line builds that target ARM platforms
if /i %1 == x86_amd64 goto x86_amd64    32-bit command line builds that target x64 platforms
if /i %1 == amd64_x86 goto amd64_x86    64-bit command-line builds that target x86 platforms
if /i %1 == amd64_arm goto amd64_arm    64-bit command-line builds that target ARM platforms

C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat
if /i %1 == x86       goto x86          32-bit command-line builds that target x86 platforms
if /i %1 == amd64     goto amd64        64-bit command-line builds that target x64 platforms
if /i %1 == x64       goto amd64        idem
if /i %1 == arm       goto arm          ?
if /i %1 == x86_arm   goto x86_arm      32-bit command line builds that target ARM platforms
if /i %1 == x86_amd64 goto x86_amd64    32-bit command line builds that target x64 platforms


Under win32 :
    32-bit process :
        <todo>
Under win64 :
    64-bit process :
        Platform=x64
        PROCESSOR_ARCHITECTURE=AMD64 or IA64
    32-bit process :
        PROCESSOR_ARCHITECTURE=x86
        PROCESSOR_ARCHITEW6432=AMD64 or IA64

set Arch=x64
if "%PROCESSOR_ARCHITECTURE%" == "x86" (
    if not defined PROCESSOR_ARCHITEW6432 set Arch=x86
)


PROCESSOR_ARCHITECTURE=x86
    target x86   (32-bit) : x86             set x86_x86=x86
    target amd64 (64-bit) : x86_amd64       set x86_amd64=x86_amd64
PROCESSOR_ARCHITECTURE=AMD64
    target x86   (32-bit) : amd64_x86       set amd64_x86=amd64_x86
    target amd64 (64-bit) : amd64           set amd64_amd64=amd64


https://msdn.microsoft.com/en-us/library/f2ccy3wt.aspx

32 bits command-line
--------------------
"x86"
x86 on x86
Use this toolset to create output files for x86 machines.
It runs as a 32-bit process, native on an x86 machine and under WOW64 on a 64-bit Windows operating system.

"x86_amd64"
x64 on x86 (x64 cross-compiler)
Use this toolset to create output files for x64.
It runs as a 32-bit process, native on an x86 machine and under WOW64 on a 64-bit Windows operating system.

"x86_arm"
ARM on x86 (ARM cross compiler)
Use this toolset to create output files for ARM machines.
It runs as a 32-bit process, native on an x86 machine and under WOW64 on a 64-bit Windows operating system.


64 bits command-line
--------------------

"amd64_x86"
x86 on x64
Use this toolset to create output files for x86 machines.
It runs as a native process on a 64-bit Windows operating system.

"amd64", "x64"
x64 on x64
Use this toolset to create output files for x64 machines.
It runs as a native process on a 64-bit Windows operating system.

"amd64_arm"
ARM on x64 (ARM cross compiler)
Use this toolset to create output files for ARM machines.
It runs as a native 64-bit process on a 64-bit Windows operating system.
