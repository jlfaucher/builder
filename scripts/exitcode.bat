@echo off
call %*
echo %errorlevel%
exit /b %errorlevel%
