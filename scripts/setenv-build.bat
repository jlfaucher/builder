@echo off
if defined echo echo %echo%

:: Those variables must be defined before calling this script
if not defined builder_config_dir echo builder_config_dir is undefined & exit /b 1
if not defined builder_shared_dir echo builder_shared_dir is undefined & exit /b 1
if not defined builder_shared_drv echo builder_shared_drv is undefined & exit /b 1

call shellscriptlib :drive "%builder_config_dir%"
set builder_config_drv=%drive%

:: Associated directory in the build hierarchy
set build_dir=%1
if not defined build_dir (
    echo Mandatory argument: path to the associated directory in the build hierarchy"
    exit /b 1
)
set build_dir=%build_dir:&=^&%
set build_dir=%build_dir:"=%

:: The shared drive provided by vmWare or VirtualBox is TOO SLOW !
:: So I put the binary files on a local drive inside the VM.
:: The source files remain on the shared drive, I don't want to manage sources per VM.
:: The local directory is derived from the delivery directory
call shellscriptlib :dirname "%build_dir%"
set builder_local_dir="%dirname%"
set builder_local_dir=%builder_local_dir:&=^&%
set builder_local_dir=%builder_local_dir:"=%
call shellscriptlib :drive "%builder_local_dir%"
set builder_local_drv=%drive%

:: Both variables contain an absolute path (same root) with a drive letter, no risk of wrong substitution
:: <target[.branch]>/d1/d2/.../system-arch/compiler/config
call set current=%%builder_config_dir:%build_dir%\=%%

:: <target[.branch]>/d1/d2/.../system-arch/compiler
call shellscriptlib :dirname "%current%"
set current="%dirname%"
set current=%current:&=^&%
set current=%current:"=%

call shellscriptlib :basename "%current%"
set builder_compiler="%basename%"
set builder_compiler=%builder_compiler:&=^&%
set builder_compiler=%builder_compiler:"=%

:: <target[.branch]>/d1/d2/.../system-arch
call shellscriptlib :dirname "%current%"
set current="%dirname%"
set current=%current:&=^&%
set current=%current:"=%

:: <target[.branch]>/d1/d2/...
call shellscriptlib :dirname "%current%"
set current="%dirname%"
set current=%current:&=^&%
set current=%current:"=%

:: d1/d2/...
:: All but first directory : Remove all characters before the first "\", and the "\" itself.
set builder_src_relative_path=%current:*\=%

:: Low risk of wrong substitution, not the case with the current sources
:: target[.branch]
:: First directory : Remove %builder_src_relative_path%
call set builder_target_branch=%%current:%builder_src_relative_path%=%%
:: Remove the last "\"
set builder_target_branch="%builder_target_branch:~0,-1%"
set builder_target_branch=%builder_target_branch:&=^&%
set builder_target_branch=%builder_target_branch:"=%

:: branch (can contain zero or one or several '.')
:: Remove all characters before the first ".", and the "." itself.
set builder_branch=%builder_target_branch:*.=%
if "%builder_target_branch%" == "%builder_branch%" set builder_branch=

:: Low risk of wrong substitution, not the case with the current sources
:: executor or executor5 or official (never contains '.')
set builder_target=%builder_target_branch%
if "%builder_branch%" == "" goto :builder_target_done
call set builder_target=%%builder_target_branch:%builder_branch%=%%
:: Remove the last "."
set builder_target="%builder_target:~0,-1%"
set builder_target=%builder_target:&=^&%
set builder_target=%builder_target:"=%
:builder_target_done

:: d1/d2/...
set builder_src_relative_path=%current:*\=%

set builder_src_drv=%builder_shared_drv%
set builder_src_dir=%builder_shared_dir%\%builder_target%\%builder_src_relative_path%

:: build & delivery are subdirectories of the config directory.
set builder_build_dir=%builder_config_dir%\build
set builder_build_drv=%builder_config_drv%
set builder_delivery_dir=%builder_config_dir%\delivery
set builder_delivery_drv=%builder_config_drv%

if not exist "%builder_build_dir%" mkdir "%builder_build_dir%"
if not exist "%builder_delivery_dir%" mkdir "%builder_delivery_dir%"

exit /b 0
