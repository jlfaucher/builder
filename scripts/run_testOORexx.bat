@echo off

:: Let find the executables needed by the testsuite for native_api testing,
:: ProcessInvocation.testGroup, RexxStart.testGroup, ProcessRexxStart.testGroup.
:: Let find the dynamic libraries needed by the testsuite for native_api testing
:: and ADDRESS.testGroup.
setlocal
set PATH=%builder_build_dir%/bin;%PATH%

:: The test suite uses the find utility; make sure that it is the Windows one
:: and not the GNU one (I have the GNU one...).
set PATH=C:\WINDOWS\system32;%PATH%
rexx testOORexx %*
endlocal
