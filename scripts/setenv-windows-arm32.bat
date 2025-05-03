@echo off
if defined echo echo %echo%

set builder_bitness=32

:: See setenv-cl.bat for the compiler options in function of %builder_system_arch%

exit /b 0


/*

Tried to build ooRexx and Regina, but it doesn't build.
LINK : fatal error LNK1104: cannot open file 'LIBCMT.lib'


Not supported?

See https://support.microsoft.com/en-us/windows/options-for-using-windows-11-with-mac-computers-with-apple-m1-and-m2-chips-cd15fd62-9b34-4b78-b0bc-121baa3c568c
32-bit Arm apps available from the Store in Windows are not supported by Mac computers with M1 and M2 chips.
32-bit Arm apps are in the process of being deprecated for all Arm versions of Windows.
The preferred customer experience is to run 64-bit Arm apps, but customers can also use apps in x64 or x86 emulation on Mac M1 and M2 computers.

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