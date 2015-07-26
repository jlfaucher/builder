@echo off

set dirname=aa.ext\bb.ext\cc.ext\dd.ext
echo "%dirname%"

:: aa.ext\bb.ext\cc.ext\dd.ext
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: aa.ext\bb.ext\cc.ext
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: aa.ext\bb.ext
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: aa.ext
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: (empty)
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

echo.
echo ---------------------------------------------------------------------------
echo.

set dirname=c:\\\aa.ext\\bb.ext\\cc.ext\\\
echo "%dirname%

:: c:\\\aa.ext\\bb.ext\\cc.ext\\\
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: c:\aa.ext\bb.ext
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: c:\aa.ext
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: c:
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

:: (empty)
echo.
call shellscriptlib :normalize_path "%dirname%"
echo "%normalize_path%"
call shellscriptlib :basename "%dirname%"
echo "%basename%"
call shellscriptlib :dirname "%dirname%"
echo "%dirname%"

exit /b 0
