Helper scripts to initialize a build environment for
- Executor
- Executor5
- Executor5-bulk
- Official ooRexx
- Regina

Environments: macos, linuxVM, winVM
The scripts for macos and win contains relative paths.
The scripts for linuxVM and winVM contains absolute paths because the build directory is inside the VM.


For Executor and ooRexx, must be called from the oorexx directory.
    Example MacOs:
        cd /local/rexx/oorexx
        . ../builder/setenv/macos/executor release

    Example winVM:
        Y:
        cd \local\rexx\oorexx
        call ..\builder\setenv\winVM\executor release



For Regina, must be called from the Regina directory.
    Example MacOs:
        cd /local/rexx/Regina
        . ../builder/setenv/macos/regina release

    Exemple WinVM:
        Y:
        cd \local\rexx\Regina
        call ..\builder\setenv\winVM\regina release
