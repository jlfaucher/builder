::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Library of shell-script procedures.
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


@echo off
:: Special management of the echo's state :
:: In this file, the fact of echoing is controled by the variable %shellscriptlib.echo%.
:: Indeed, you may want to debug your own script by setting echo=on, but not debug this file...
:: If you really want to debug this file, then set shellscriptlib.echo=on.
@if defined shellscriptlib.echo echo %shellscriptlib.echo%

:: Must undefine errorlevel to be sure to catch the real errorlevel.
@set errorlevel=
call :dispatch %*
set last_errorlevel=%errorlevel%

:: Now we are leaving this file, we come back under the control of the variable %echo%.
@if defined echo echo %echo%

@exit /B %last_errorlevel%


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:dispatch

@set proc=%1
@shift

@if defined proc goto %proc%

@echo This is a library of shell-script procedures.
@echo Usage :
@echo     shellscriptlib :absolute_path ^<filename^>
@echo     shellscriptlib :basename ^<filename^>
@echo     shellscriptlib :dirname ^<filename^>
@echo     shellscriptlib :drive ^<filename^>
@echo     shellscriptlib :drive_path ^<filename^>
@echo     shellscriptlib :drive_path_name ^<filename^>
@echo     shellscriptlib :long_ext ^<filename^>
@echo     shellscriptlib :name ^<filename^>
@echo     shellscriptlib :name_ext ^<filename^>
@echo     shellscriptlib :normalize_path ^<filename^>
@echo     shellscriptlib :prepend_path ^<var^> ^<path^>
@echo     shellscriptlib :short_ext ^<filename^>
@echo     shellscriptlib :which ^<filename^>
@goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:absolute_path
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
set absolute_path="%~f1"
set absolute_path=%absolute_path:&=^&%
set absolute_path=%absolute_path:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:basename
:: Returns the basename of a path.
:: The behavior of basename is not similar to the parameter parsing of cmd.
:: If the path is relative, it remains as-is, i.e. there is no use of the current directory.
:: The trailing \ are removed before calculating the basename.
:: When the path is just a device identifier (like C:) then return an empty value.
:: Ex : file.ext --> file.ext
::      file.ext\ --> file.ext
::      dir1\file.ext --> file.ext
::      dir1\file.ext\ --> file.ext
::      etc...
set basename=
call :normalize_path %1
setlocal
set arg="%normalize_path%"
set arg=%arg:&=^&%
set arg=%arg:"=%
if "%arg%" == "" endlocal & goto :eof
if "%arg:~-1%" == ":" endlocal & goto :eof
call :name_ext "%arg%"
endlocal & set basename="%name_ext%"
set basename=%basename:&=^&%
set basename=%basename:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:dirname
:: Returns the dirname of a path.
:: The behavior of dirname is not similar to the parameter parsing of cmd.
:: If the path is relative, it remains as-is, i.e. there is no use of the current directory.
:: The trailing \ are removed before calculating the dirname.
:: When the path is just a device identifier (like C:) then return an empty value.
:: Ex : file.ext --> (empty)
::      file.ext\ --> (empty)
::      dir1\file.ext --> dir1
::      dir1\file.ext\ --> dir1
::      dir2\dir1\file.ext --> dir2\dir1
::      etc...
set dirname=
call :normalize_path %1
setlocal
set arg="%normalize_path%"
set arg=%arg:&=^&%
set arg=%arg:"=%
if "%arg%" == "" endlocal & goto :eof
if "%arg:~-1%" == ":" endlocal & goto :eof
call :basename "%arg%"
:: Add a trailing * to make the basename unique. * is a forbidden character.
set basename="%basename%*"
set basename=%basename:&=^&%
set basename=%basename:"=%
:: Idem for the full path
set arg="%arg%*"
set arg=%arg:&=^&%
set arg=%arg:"=%
:: Remove the basename, the remaining is the dirname...
call set dirname="%%arg:%basename%=%%"
set dirname=%dirname:&=^&%
set dirname=%dirname:"=%
:: Remove the trailing \
call :normalize_path "%dirname%"
endlocal & set dirname="%normalize_path%"
set dirname=%dirname:&=^&%
set dirname=%dirname:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:drive
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
set drive="%~d1"
set drive=%drive:&=^&%
set drive=%drive:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:drive_path
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
set drive_path="%~dp1"
set drive_path=%drive_path:&=^&%
set drive_path=%drive_path:"=%
set drive_path="%drive_path:~0,-1%"
set drive_path=%drive_path:&=^&%
set drive_path=%drive_path:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:drive_path_name
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
:: If option -remove-last-extension (must be 2nd arg) then remove ONLY the last extensions.
:: See the procedure 'name' for more details.
setlocal
set arg1=%1
set arg1=%arg1:&=^&%
set arg1=%arg1:"=%
call :drive_path "%arg1%"
call :name "%arg1%" %2
endlocal & set drive_path_name="%drive_path%\%name%"
set drive_path_name=%drive_path_name:&=^&%
set drive_path_name=%drive_path_name:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: git branch of the current directory.
:: Typical usage to not see the error message when not a git repo :
:: call shellscriptlib :git_branch 2>nul
:: if defined git_branch ...
:git_branch
set git_branch=
for /f "usebackq" %%i in (`git name-rev --name-only HEAD`) do set git_branch=%%i
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:long_ext
:: Returns the long extension
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
:: Ex :toto.xml.hutn --> .xml.hutn
setlocal
set arg1=%1
set arg1=%arg1:&=^&%
set arg1=%arg1:"=%
call :name_ext "%arg1%"
if "%name_ext:.=%" == "%name_ext%" endlocal & set long_ext=& goto :eof
endlocal & set long_ext=".%name_ext:*.=%"
set long_ext=%long_ext:&=^&%
set long_ext=%long_ext:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:name
:: Returns the name without extensions.
:: If option -remove-last-extension then remove ONLY the last extensions.
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
:: Ex : toto --> toto
::      toto.xml --> toto
::      toto.xml.hutn --> toto.xml
::      etc...
:: Otherwise (default) remove ALL the extensions, recursively.
:: Ex : toto --> toto
::      toto.xml --> toto
::      toto.xml.hutn --> toto
::      etc...

setlocal
:: Must use %arg1% instead of %1 because, that way, the escaped characters are correctly supported.
:: Ex : if %1 == "a^^b" then %arg1% == "a^b"
::      The test "%name%"==%1 is always false because "a^b" is NOT equal to "a^^b"
::      The test "%name%"=="%arg1%" can be true
set arg1=%1
set arg1=%arg1:&=^&%
set arg1=%arg1:"=%
set name="%~n1"
set name=%name:&=^&%
set name=%name:"=%
if /i "%2"=="-remove-last-extension" goto :name.end
if /i "%2"=="--remove-last-extension" goto :name.end
if "%name%"=="%arg1%" goto :name.end
call :name "%name%"
:name.end
endlocal & set name="%name%"
set name=%name:&=^&%
set name=%name:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:name_ext
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
set name_ext="%~nx1"
set name_ext=%name_ext:&=^&%
set name_ext=%name_ext:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:normalize_path
:: Replace several occurences of \ by a single \
:: Remove trailing \
setlocal
:: Add a trailing \, to be sure there is one to delete
set arg1=%1\
:normalize_path_loop
    set arg1=%arg1:&=^&%
    set arg1=%arg1:"=%
    set normalize_path="%arg1:\\=\%"
    set normalize_path=%normalize_path:&=^&%
    set normalize_path=%normalize_path:"=%
    if "%normalize_path%" == "%arg1%" goto :normalize_path_endloop
    set arg1="%normalize_path%"
    goto normalize_path_loop
:normalize_path_endloop
:: Remove the trailing \
endlocal & set normalize_path="%normalize_path:~0,-1%"
set normalize_path=%normalize_path:&=^&%
set normalize_path=%normalize_path:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:prepend_path
:: If the path is already declared (caseless) then do nothing.
:: Otherwise prepend path in front of the current value.
:: When testing for equality, all the characters are tested, including the final \ if any.
:: Up to you to be consistent with the final \.
:: The separator is ;
:: Ex:
:: prepend_path PATH "c:\my program\bin"        added
:: prepend_path PATH "c:\my program\bin"        not added, already declared
:: prepend_path PATH "c:\my program\bin\"       added, because the final \ makes the difference
setlocal
set var=%1
call set val=%%%var%%%
set arg=%2
set arg=%arg:&=^&%
set arg=%arg:"=%
:: Surround with ; do ensure we test a delimited path
set delimited_arg=;%arg%;
set delimited_val1=;%val%;
call set delimited_val2=%%delimited_val1:%delimited_arg%=%%
if not "%delimited_val1%" == "%delimited_val2%" endlocal & goto :eof
endlocal & set %var%=%arg%;%val%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:short_ext
:: Returns the short extension
:: If the path is relative then an absolute path is built by prepending the current directory of the current drive.
:: If a drive letter is provided, then the current directory of this drive is used.
:: Ex :toto.xml.hutn --> .hutn
set short_ext="%~x1"
set short_ext=%short_ext:&=^&%
set short_ext=%short_ext:"=%
goto :eof


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:which
:: Ex : which myappli.exe (you must specify the extension)
::      --> returns the whole path, if found.
::          otherwise returns an empty value
set which=%~$PATH:1
goto :eof
