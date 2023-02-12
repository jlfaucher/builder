@echo off
if defined echo echo %echo%

:: TOO BAD
:: builder_bitness not yet defined (will be defined by the script in the parent directory)
:: so must get it by testing the builder system name (parent directory)

:: Associated directory in the build hierarchy
:: .../<target[.branch]>/d1/d2/.../system-arch/compiler
set current=%1
set current=%current:&=^&%
set current=%current:"=%

:: .../<target[.branch]>/d1/d2/.../system-arch
call shellscriptlib :dirname "%current%"
set current="%dirname%"
set current=%current:&=^&%
set current=%current:"=%

:: windows-x86_32, windows-x86_64, windows-arm64
call shellscriptlib :basename "%current%"
set builder_system_arch="%basename%"
set builder_system_arch=%builder_system_arch:&=^&%
set builder_system_arch=%builder_system_arch:"=%

set builder_bitness=""
if "%builder_system_arch%" == "windows-x86_32" set builder_bitness=32
if "%builder_system_arch%" == "windows-x86_64" set builder_bitness=64
if "%builder_system_arch%" == "windows-arm32" set builder_bitness=32
if "%builder_system_arch%" == "windows-arm64" set builder_bitness=64
if %builder_bitness% == "" ( echo Invalid builder_bitness : "%builder_bitness%" & exit /b 1 )

:: The value to pass to vcvars, depending on ProcessorArchitecture and builderBitness
set x86_32=x86
set x86_64=x86_amd64
set amd64_32=amd64_x86
set amd64_64=amd64
set arm64_32=arm64_arm
set arm64_64=arm64
set compiler=%PROCESSOR_ARCHITECTURE%_%builder_bitness%
if not defined %compiler%  goto error
call set compiler_option=%%%compiler%%%


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Visual Studio 2022 (internal version: 17.0, cl version 19.30)

:cl_22
if 22 GTR %CL_MAX% goto cl_19
set cl_dir=C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build
if exist "%cl_dir%" (
    call "%cl_dir%\vcvarsall.bat" %compiler_option%
    if errorlevel 1 goto error
    exit /b 0
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Visual Studio 2019 (internal version: 16.0, cl version 19.20)

:cl_19
if 19 GTR %CL_MAX% goto cl_17
set cl_dir=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build
if exist "%cl_dir%" (
    call "%cl_dir%\vcvarsall.bat" %compiler_option%
    if errorlevel 1 goto error
    exit /b 0
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Visual Studio 2017 (internal version: 15.0, cl version 19.10)

:cl_17
if 17 GTR %CL_MAX% goto cl_14
set cl_dir=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build
if exist "%cl_dir%" (
    call "%cl_dir%\vcvarsall.bat" %compiler_option%
    if errorlevel 1 goto error
    exit /b 0
)

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

https://en.wikipedia.org/wiki/Microsoft_Visual_Studio
Product name                Codename        Internal version    cl.exe version      Release date
Visual Studio	            N/A	            4.0	                0.0	                April 1995
Visual Studio 97            Boston          5.0                 0.0                 February 1997
Visual Studio 6.0           Aspen           6.0                 0.0                 June 1998
Visual Studio .NET (2002)   Rainier         7.0                 0.0                 February 13, 2002
Visual Studio .NET 2003     Everett         7.1                 13.0                April 24, 2003
Visual Studio 2005          Whidbey         8.0                 14.00               November 7, 2005
Visual Studio 2008          Orcas           9.0                 15.00               November 19, 2007
Visual Studio 2010          Dev10/Rosario   10.0                16.00               April 12, 2010
Visual Studio 2012          Dev11           11.0                17.00               September 12, 2012
Visual Studio 2013          Dev12           12.0                18.00               October 17, 2013
Visual Studio 2015          Dev14           14.0                19.00               July 20, 2015
Visual Studio 2017          Dev15           15.0                19.10               March 07, 2017
Visual Studio 2019          Dev16           16.0                19.20               April 02, 2019
Visual Studio 2022          Dev17           17.0                19.30               November 08, 2021


Visual Studio includes
32-bit, x86-hosted, native and cross compilers for x86, x64, and ARM targets.
When Visual Studio is installed on a 64-bit Windows operating system,
32-bit, x86-hosted native and cross compilers, and also
64-bit, x64-hosted native and cross compilers,
are installed for each target (x86, x64, and ARM).
The 32-bit and 64-bit compilers for each target generate identical code,
but the 64-bit compilers support more memory for precompiled header symbols
and the Whole Program Optimization (/GL, /LTCG) options.


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
https://docs.microsoft.com/en-us/cpp/build/building-on-the-command-line?redirectedfrom=MSDN&view=msvc-170


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

"x86_arm64" (new in Visual Studio 2022)
compiler: ARM64 on x86 cross
host computer architecture: x86, x64
build output (target) architecture: ARM64


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

"amd64_arm64" (new in Visual Studio 2022)
compiler: ARM64 on x64 cross
host computer architecture: x64
build output (target) architecture: ARM64


--------------------------------------------------
Visual Studio 2022 for Windows ARM - vcvarsall.bat
--------------------------------------------------

arch            target      host
x86             x86         x86
x86_amd64       x64         x86
x86_x64         x64         x86
x86_arm         arm         x86
x86_arm64       arm64       x86
amd64           x64         x64
x64             x64         x64
amd64_x86       x86         x64
x64_x86         x86         x64
amd64_arm       arm         x64
x64_arm         arm         x64
amd64_arm64     arm64       x64
x64_arm64       arm64       x64
arm64           arm64       arm64
arm64_amd64     x64         arm64
arm64_x64       x64         arm64
arm64_x86       x86         arm64
arm64_arm       arm         arm64


https://learn.microsoft.com/en-US/windows/msix/package/device-architecture
x86
x64
ARM
ARM64
