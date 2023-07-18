@echo off
if defined echo echo %echo%

:: File naming convention
:: setenv-%current%-%builder_system_arch%-%builder_hostname%.bat
::        regina    windows-x86_64        jlf-mbp2010vm

:: Shared folders parameterized in VMWARE:
:: name "jlfaucher" folder "jlfaucher" Read & Write
:: name "local" folder "local" Read & Write

:: X: is the shared folders root of VMWARE mounted with:  if not exist x: net use x: "\\vmware-host\Shared Folders"
:: Y: is the SMBD folder                   mounted with:  if not exist y: net use Y: \\jlfaucher.local\Local1
:: Y: seems faster than X:
set HOST_DRIVE=Y:

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
