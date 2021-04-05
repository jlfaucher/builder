@echo off
if defined echo echo %echo%

:: Pfff... CPPFLAGS ignored by cmake ???
set CPPFLAGS=/DSTRONG_TYPES %CPPFLAGS%
set CXXFLAGS=/DSTRONG_TYPES %CXXFLAGS%
