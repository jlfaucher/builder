@echo off
if defined echo echo %echo%

:: Installed C++ Profiling Tools (50 MB)
:: Installed Windows Performance Toolkit (Download 322 MB, Install 900 MB)
:: Pfff... still no vsinstr.exe!!
:: https://learn.microsoft.com/en-us/visualstudio/profiling/instrumentation-overview?view=vs-2022
:: https://learn.microsoft.com/en-us/visualstudio/profiling/vsinstr?view=visualstudio
:: https://learn.microsoft.com/en-us/visualstudio/profiling/profile-apps-from-command-line?view=visualstudio
set builder_profiling=1

:: MEMPROFILE activates dumpMemoryProfile in ooRexx
:: VERBOSE_GC activates the GC verbose messages
echo Adding -DMEMPROFILE to activate dumpMemoryProfile
echo Adding -DVERBOSE_GC to activate the GC verbose messages
set CFLAGS=-DMEMPROFILE -DVERBOSE_GC -g -O3 %CFLAGS%
set CXXFLAGS=-DMEMPROFILE -DVERBOSE_GC -g -O3 %CXXFLAGS%

:: Cmake has no build type for profiling.
set CMAKE_BUILD_TYPE=RelWithDebInfo
exit /b 0
