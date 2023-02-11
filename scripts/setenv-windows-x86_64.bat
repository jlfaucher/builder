@echo off
if defined echo echo %echo%

set builder_bitness=64

:: Redundant with builder_system_arch, but it's a good way to check the
:: consistency between the declarations here, and the system-arch directory
:: (checked in setenv-build)
set builder_system=windows
set builder_arch=x86_64

exit /b 0
