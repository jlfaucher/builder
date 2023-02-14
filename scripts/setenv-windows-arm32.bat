@echo off
if defined echo echo %echo%

set builder_bitness=32

:: Redundant with builder_system_arch, but it's a good way to check the
:: consistency between the declarations here, and the system-arch directory
:: (checked in setenv-build)
set builder_system=windows
set builder_arch=arm32

exit /b 0


/*

Tried to build ooRexx and Regina, but it doesn't build.
LINK : fatal error LNK1104: cannot open file 'LIBCMT.lib'


Not supported?
See https://dotnet.microsoft.com/en-us/download/dotnet/7.0

.NET 7 is available for these platforms:

Linux Arm32
Linux Arm32 Alpine
Linux Arm64
Linux Arm64 Alpine
Linux x64
Linux x64 Alpine

macOS Arm64
macoOS x64

Windows Arm64
Windows x64
Windows x86


https://github.com/dotnet/runtime/discussions/71042
Dropping support for Arm32 (.NET 9)
As it relates to Arm, all of our effort has gone into Arm64/Armv8.
There have been no substantial improvement in Arm32/Armv7.
We're not focused on it. We've started to talk about dropping support for it.

Our current thinking is to support Arm32 through .NET 7 and 8 and then end support after that (with .NET 9).
We dropped support for Windows Arm32 some time ago. This thinking is specific to CoreCLR, not Mono.


*/