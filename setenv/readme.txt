Helper scripts to initialize a build environment for
- Executor release
- Executor debug
- Executor5 release
- Executor5 debug
- Official ooRexx release
- Official ooRexx debug
- Regina release
- Regina debug

Environments: macos, ubuntuVM, winVM
The scripts for macos and win contains relative paths.
The scripts for ubuntuVM and winVM contains absolute paths because the build directory is inside the VM.


For Executor and ooRexx, must be called from the oorexx directory.
    Example MacOs:
        cd /local/rexx/oorexx
        . ../builder/setenv/macos/executor_release

    Example winVM:
        Y:
        cd \local\rexx\oorexx
        call ..\builder\setenv\winVM\executor_release



For Regina, must be called from the Regina directory.
    Example MacOs:
        cd /local/rexx/Regina
        . ../builder/setenv/macos/regina_release

    Exemple WinVM:
        Y:
        cd \local\rexx\Regina
        call ..\builder\setenv\winVM\regina_release
