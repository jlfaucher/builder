@echo off
if defined echo echo %echo%

:: File naming convention
:: other_dependencies-regina-%builder_system%-%COMPUTERNAME%.bat
::                           win              WIN-7RUPB0TOBV1

:: Shared folders parameterized in VMWARE:
:: name "jlfaucher" folder "jlfaucher" Read & Write
:: name "local" folder "local" Read & Write

:: X: is the shared folders root of VMWARE mounted with:  if not exist x: net use x: "\\vmware-host\Shared Folders"
:: Y: is the SMBD folder                   mounted with:  if not exist y: net use Y: \\jlfaucher.local\Local1
:: Y: seems faster than X:
set HOST_DRIVE=Y:

:: GCI
echo Setting environment for GCI
call shellscriptlib :dirname "%builder_shared_dir%"
set GCI_HOME="%dirname%\rexx-gci"
set GCI_HOME=%GCI_HOME:&=^&%
set GCI_HOME=%GCI_HOME:"=%
set GCI_LIBRARY_PATH=%GCI_HOME%\build\%builder_system%\%builder_compiler%\%builder_config%\%builder_bitness%
call shellscriptlib :prepend_path PATH "%GCI_LIBRARY_PATH%"
call shellscriptlib :drive "%GCI_HOME%"
set GCI_HOME_DRIVE=%drive%
doskey cdgci=%GCI_HOME_DRIVE% ^& cd %GCI_HOME%

:: NSIS
call shellscriptlib :prepend_path PATH "E:\nsis\Nsis_longStrings"

:: Dropbox scripts
call shellscriptlib :prepend_path PATH "%HOST_DRIVE%\jlfaucher\Dropbox\software\Rexx"

:: windiff
call shellscriptlib :prepend_path PATH "E:\windiff"

:: cmake
call shellscriptlib :prepend_path PATH "C:\Program Files\CMake\bin"

:: On this system, the default console code page is 850 OEM Multilingual Latin 1; Western European (DOS).
:: That brings troubles when you execute a script created with a Window application (like Notepad) which contains letters with accent.
:: Change the default code page of the console to 1252 ANSI Latin 1; Western European (Windows).
chcp 1252
