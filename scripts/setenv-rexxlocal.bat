@echo off
if defined echo echo %echo%

:: Pfff...
:: Workaround for Windows where the folder "rexx" is renamed "rexxlocal" inside the VM.
:: Forward to the 'rexx' script in the same directory
call "%builder_scripts_dir%\setenv-rexx.bat" %*
