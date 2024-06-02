This directory contains scripts which are applicable to specific machines.

setenv
# Iterate over each directory, from deeper to root.
# If a script named setenv-<dir> exists in the directory of scripts then execute it.
    script=${builder_scripts_dir}/setenv-${builder_iteration_current}
# If a script named setenv-<dir>-<system-arch>-<computername> exists in the directory of private scripts then execute it.
    script=${builder_scripts_dir}.private/setenv-${builder_iteration_current}-${builder_system_arch}-${builder_hostname}
# If a script named setenv-<dir>-<computername> exists in the directory of private scripts then execute it.
    script=${builder_scripts_dir}.private/setenv-${builder_iteration_current}-${builder_hostname}


setenv.bat
:: Iterate over each directory, from deeper to root.
:: If a script named setenv-<dir>.bat exists in the directory of scripts then execute it.
    set script="%builder_scripts_dir%\setenv-%builder_iteration_current%.bat"
:: If a script named setenv-<dir>-<system-arch>-<computername>.bat exists in the directory of private scripts then execute it.
    set script="%builder_scripts_dir%.private\setenv-%builder_iteration_current%-%builder_system_arch%-%builder_hostname%.bat"
:: If a script named setenv-<dir>-<computername>.bat exists in the directory of private scripts then execute it.
    set script="%builder_scripts_dir%.private\setenv-%builder_iteration_current%-%builder_hostname%.bat"


================================================================================
jlfaucher/jlf macbookPro 2010
================================================================================

macOS           hostname -s: jlfaucher-mbp2010
Windows 10      hostname:    jlf-mbp2010vm
wsl             hostname -s: jlf-mbp2010vm


         ${current} - ${builder_system_arch} - ${builder_hostname}
         %current%  - %builder_system_arch%  - %builder_hostname%
setenv - oorexx     - macos-x86_64           - jlfaucher-mbp2010
setenv - oorexx     - ubuntu-x86_64          - jlfaucher-mbp2010
setenv - oorexx     - windows-x86_32         - jlf-mbp2010vm        .bat
setenv - oorexx     - windows-x86_64         - jlf-mbp2010vm        .bat
setenv - regina     - macos-x86_64           - jlfaucher-mbp2010
setenv - regina     - windows-x86_64         - jlf-mbp2010vm        .bat


================================================================================
jlfaucher/jlf macbookPro M1 2021
================================================================================

macOS           hostname -s: jlfaucher-mbp2021
Windows 10      hostname:    jlf-mbp2021vm
wsl             hostname -s: jlf-mbp2021vm


         %current%        - %builder_hostname%
setenv - executor.master  - jlf-mbp2021vm       .bat
setenv - executor5.master - jlf-mbp2021vm       .bat
setenv - official         - jlf-mbp2021vm       .bat

         ${current} - ${builder_system_arch} - ${builder_hostname}
         %current%  - %builder_system_arch%  - %builder_hostname%
setenv - oorexx     - macos-arm64            - jlfaucher-mbp2021
setenv - oorexx     - ubuntu-arm64           - jlfaucher-mbp2021
setenv - oorexx     - windows-arm64          - jlf-mbp2021vm        .bat
setenv - oorexx     - windows-x86_32         - jlf-mbp2021vm        .bat
setenv - oorexx     - windows-x86_64         - jlf-mbp2021vm        .bat
setenv - regina     - macos-arm64            - jlfaucher-mbp2021
